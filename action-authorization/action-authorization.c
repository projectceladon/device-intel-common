/*
 * Copyright (c) 2015, Intel Corporation
 * All rights reserved.
 *
 * Author: Jeremy Compostella <jeremy.compostella@intel.com>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *    * Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *    * Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer
 *      in the documentation and/or other materials provided with the
 *      distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <libgen.h>
#include <getopt.h>
#include <stdint.h>
#include <stdbool.h>
#include <ctype.h>
#include <sys/time.h>
#include <openssl/pem.h>
#include <openssl/err.h>
#include <openssl/pkcs12.h>
#include <openssl/rand.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*x))

static BIO *err_bio;
static int nopassword;
static int verbose;

static uint8_t SUPPORTED_VERSION = 0;
static uint8_t SUPPORTED_ACTIONS[] = { 0 };

#define RANDOM_BYTE_LENGTH	16

#define error(fmt, ...) do {					\
		BIO_printf(err_bio, fmt "\n", ##__VA_ARGS__);	\
		if (verbose)					\
			ERR_print_errors(err_bio);		\
	} while (0)

static X509 *load_cert_from_PEM_file(const char *file)
{
	X509 *cert;
	BIO *cert_bio;

	cert_bio = BIO_new_file(file, "rb");
	if (!cert_bio)
		return NULL;

	cert = PEM_read_bio_X509_AUX(cert_bio, NULL, NULL, NULL);
	BIO_free(cert_bio);

	return cert;
}

static EVP_PKEY *load_key_from_DER_file(const char *file, const char *password)
{
	EVP_PKEY *key = NULL;
	BIO *key_bio = NULL;
	X509_SIG *p8 = NULL;
	PKCS8_PRIV_KEY_INFO *p8inf = NULL;
	char pass[50];

	key_bio = BIO_new_file(file, "rb");
	if (!key_bio)
		return NULL;

	if (nopassword) {
		key = d2i_PrivateKey_bio(key_bio, NULL);
		goto out;
	}

	OpenSSL_add_all_algorithms();

	p8 = d2i_PKCS8_bio(key_bio, NULL);
	if (!p8) {
		error("Failed to read PKCS8");
		goto out;
	}

	if (!password) {
		EVP_read_pw_string(pass, sizeof(pass), "Enter Password:", 0);
		password = pass;
	}

	p8inf = PKCS8_decrypt(p8, password, strlen(password));
	if (!p8inf) {
		error("Failed to decrypt key");
		goto out;
	}

	key = EVP_PKCS82PKEY(p8inf);
	if (!key)
		error("Failed to convert the key");

out:
	if (p8)
		X509_SIG_free(p8);
	if (p8inf)
		PKCS8_PRIV_KEY_INFO_free(p8inf);
	BIO_free(key_bio);
	return key;
}

static int gen_pkcs7(const char *key_file, const char *cert_file,
		     char *str, const char *out_file, char *password)
{
	const EVP_MD *DIGEST = EVP_sha256();
	EVP_PKEY *key = NULL;
	X509 *cert = NULL;
	BIO *in_bio = NULL, *out_bio = NULL;
	PKCS7 *p7 = NULL;
	PKCS7_SIGNER_INFO *signer_info;
	int ret = EXIT_FAILURE, internal_ret;

	key = load_key_from_DER_file(key_file, password);
	if (!key) {
		error("Failed to load the private key");
		goto out;
	}

	cert = load_cert_from_PEM_file(cert_file);
	if (!cert) {
		error("Failed to load the certificate");
		goto out;
	}

	in_bio = BIO_new_mem_buf(str, strlen(str) + 1);
	if (!in_bio) {
		error("Failed to create input data BIO");
		goto out;
	}

	p7 = PKCS7_sign(NULL, NULL, NULL, NULL, PKCS7_PARTIAL);
	if (!p7) {
		error("Failed to generate PKCS7");
		goto out;
	}

	signer_info = PKCS7_sign_add_signer(p7, cert, key, DIGEST, 0);
	if (!signer_info) {
		error("Failed to add signer info");
		goto out;
	}

	EVP_add_digest(DIGEST);
	internal_ret = PKCS7_final(p7, in_bio, 0);
	if (internal_ret != 1) {
		error("Failed to finalize PKCS7");
		goto out;
	}

	out_bio = BIO_new_file(out_file, "wb");
	if (!out_bio) {
		error("Failed to create output data BIO");
		goto out;
	}

	internal_ret = i2d_PKCS7_bio(out_bio, p7);
	if (internal_ret != 1) {
		error("Failed to write PKCS7 file");
		goto out;
	}

	ret = EXIT_SUCCESS;

out:
	if (key)
		EVP_PKEY_free(key);
	if (cert)
		X509_free(cert);
	if (in_bio)
		BIO_free(in_bio);
	if (out_bio)
		BIO_free(out_bio);
	if (p7)
		PKCS7_free(p7);

	return ret;
}

void bytes_to_hex_str(unsigned char *bytes, size_t length, char *str)
{
	char hex;
	size_t i;

	if (!bytes || !str)
		return;

	for (i = 0; i < length * 2; i++) {
		hex = ((i & 1) ? bytes[i / 2] & 0xf : bytes[i / 2] >> 4);
		*str++ = (hex > 9 ? (hex + 'a' - 10) : (hex + '0'));
	}
	*str = '\0';
}

static bool is_valid_nonce_message(char *message)
{
	uint8_t msg_version, msg_action;
	char *version, *serial, *action, *random, *saveptr, *tmp, *msgcopy;
	size_t i;

	msgcopy = strdup(message);
	if (!msgcopy) {
		error("Failed to make a copy of the message");
		return false;
	}

	/* Version */
	version = strtok_r(msgcopy, ":", &saveptr);
	if (!version) {
		error("No version found");
		goto parse_error;
	}

	if (strlen(version) != sizeof(SUPPORTED_VERSION) * 2) {
		error("Version string length is invalid");
		goto parse_error;
	}

	msg_version = strtoul(version, &tmp, 16);
	if (*tmp != '\0' || msg_version != SUPPORTED_VERSION) {
		error("Unsupported version");
		goto parse_error;
	}

	/* Serial: per Android CDD, the value must be 7-bit ASCII and
	   match the regex ^[a-zA-Z0-9](6,20)$ */
	serial = strtok_r(NULL, ":", &saveptr);
	if (!serial) {
		error("No serial found");
		goto parse_error;
	}
	if (strlen(serial) < 6 || strlen(serial) > 20) {
		error("Serial too short or too long");
		goto parse_error;
	}
	for (i = 0; serial[i] != '\0'; i++)
		if (!isalnum(serial[i])) {
			error("Invalid serial number for Android device");
			goto parse_error;
		}

	/* Action */
	action = strtok_r(NULL, ":", &saveptr);
	if (!action) {
		error("No action found");
		goto parse_error;
	}

	if (strlen(action) != sizeof(*SUPPORTED_ACTIONS) * 2) {
		error("Action string length is invalid");
		goto parse_error;
	}

	msg_action = strtoul(action, &tmp, 16);
	if (*tmp != '\0') {
		error("Invalid action ID");
		goto parse_error;
	}

	for (i = 0; i < ARRAY_SIZE(SUPPORTED_ACTIONS); i++)
		if (msg_action == SUPPORTED_ACTIONS[i])
			break;

	if (i == ARRAY_SIZE(SUPPORTED_ACTIONS)) {
		error("Unsupported action ID");
		goto parse_error;
	}

	/* Device random */
	random = strtok_r(NULL, ":", &saveptr);
	if (!random) {
		error("No random string found");
		goto parse_error;
	}
	if (strlen(random) != RANDOM_BYTE_LENGTH * 2) {
		error("Random string is too short");
		goto parse_error;
	}

	free(msgcopy);
	return true;

parse_error:
	error("Invalid nonce message");
	free(msgcopy);
	return false;
}

static char *build_answer_message(char *message)
{
	unsigned char newrandom[RANDOM_BYTE_LENGTH];
	char newrandom_str[RANDOM_BYTE_LENGTH * 2 + 1];
	char *output;
	int ret, output_size;

	ret = RAND_bytes(newrandom, sizeof(newrandom));
	if (ret != 1) {
		error("Failed to generate random numbers");
		return NULL;
	}

	bytes_to_hex_str(newrandom, sizeof(newrandom), newrandom_str);

	output_size = strlen(message) + 1 + strlen(newrandom_str) + 1;
	output = malloc(output_size);
	if (!output) {
		error("Failed to allocate the result message buffer");
		return NULL;
	}

	ret = snprintf(output, output_size, "%s:%s", message, newrandom_str);
	if (ret != output_size - 1) {
		error("Failed to format the result message");
		return NULL;
	}

	return output;
}

static void usage(char *cmd, int status)
{
	FILE *out = status == EXIT_SUCCESS ? stdout : stderr;

	fprintf(out, "Usage: %s OPTIONS\n\
\n\
  Produce a PKCS7 answer message to a fastboot get-action-nonce.\n\
  This PKCS7 can be sent using the fastboot flash action-authorization\n\
  <file> command.\n\
\n\
   --oak-cert, -O <file>          OAK certificate (PEM)\n\
   --oak-private-key, -P <file>   private key file (PEM)\n\
   --message, -M <string>         message received from get-action-nonce\n\
                                  fastboot command\n\
   --output-file, -F <file>       output file for the PKCS7 message\n\
   --nopassword                   private key does not need a password\n\
   --password <password>          private key password\n\
   --verbose                      print all debug messages\n\
   --supported-version, -V        print the nonce version supported\n\
   --help, -h                     display this help and exit\n", cmd);

	exit(status);
}

static struct option long_options[] = {
	{"help", no_argument, 0, 'h'},
	{"oak-cert", required_argument, 0, 'O'},
	{"oak-private-key", required_argument, 0, 'K'},
	{"message", required_argument, 0, 'M'},
	{"output-file", required_argument, 0, 'F' },
	{"nopassword", no_argument, &nopassword, 1 },
	{"password", required_argument, 0, 'P' },
	{"supported-version", no_argument, &verbose, 'V' },
	{"verbose", no_argument, &verbose, 1 },
	{0, 0, 0, 0}
};

int main(int argc, char **argv)
{
	char *key_file = NULL, *cert_file = NULL, *out_file = NULL, *message = NULL;
	char *password = NULL;
	char c, *new_message, *cmd;
	int option_index = 0, ret = EXIT_FAILURE;

	cmd = basename(argv[0]);

	err_bio = BIO_new(BIO_s_file());
	if (!err_bio) {
		fprintf(stderr, "Failed to initialized the BIO error\n");
		return EXIT_FAILURE;
	}

	BIO_set_fp(err_bio, stderr, BIO_NOCLOSE|BIO_FP_TEXT);

	while (1) {
		c = getopt_long(argc, argv, "hO:K:M:F:P:V",
				long_options, &option_index);
		if (c == -1)
			break;
		switch(c) {
		case 0:
			break;

		case 'h':
			usage(cmd, EXIT_SUCCESS);
			break;

		case 'O':
			cert_file = optarg;
			break;

		case 'K':
			key_file = optarg;
			break;

		case 'M':
			message = optarg;
			break;

		case 'F':
			out_file = optarg;
			break;

		case 'P':
			password = optarg;
			break;

		case 'V':
			fprintf(stdout, "Supported version: %d\n",
				SUPPORTED_VERSION);
			exit(EXIT_SUCCESS);
			break;

		default:
			usage(cmd, EXIT_FAILURE);
			break;
		}
	}

	if (!key_file || !cert_file || !out_file || !message)
		usage(cmd, EXIT_FAILURE);
	if (password && nopassword)
		usage(cmd, EXIT_FAILURE);

	if (!is_valid_nonce_message(message))
		goto out;

	new_message = build_answer_message(message);
	if (!new_message)
		goto out;

	ret = gen_pkcs7(key_file, cert_file, new_message, out_file, password);
	free(new_message);

out:
	BIO_free(err_bio);

	if (ret == EXIT_SUCCESS)
		fprintf(stdout, "%s successfully generated.\n", out_file);
	return ret;
}
