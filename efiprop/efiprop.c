/*
 * Copyright (C) 2015 Intel Corporation
 *
 * Author: Jeremy Compostella <jeremy.compostella@intel.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <stdlib.h>
#include <stdio.h>
#include <efivar.h>
#include <ctype.h>
#include <cutils/properties.h>
#include <stdbool.h>
#include <libgen.h>
#include <errno.h>
#include <getopt.h>
#include <string.h>

#define GUID_FORMAT	"%08x-%04x-%04x-%04x-%02x%02x%02x%02x%02x%02x"
#define COMMAND		"efiprop"

static const efi_guid_t EFI_PROP_GUID =
 { 0xfb7e31f5, 0x21de, 0x4c4c, 0xb79e, { 0x16, 0x30, 0x51, 0xbb, 0x06, 0xdb } };

static int verbose_flag;

#define debug(x, ...) do { 			\
    if (verbose_flag) 				\
        fprintf(stdout, x "\n", ##__VA_ARGS__);	\
} while (0)

#define error(x, ...) do {			\
    fprintf(stderr, x "\n", ##__VA_ARGS__);	\
} while (0)

static void skip_whitespace(char **line)
{
	char *cur = *line;
	while (*cur && isspace(*cur))
		cur++;
	*line = cur;
}

static void load_properties_from_string(char *data, size_t size)
{
	char *key, *value, *eol, *sol, *tmp;
	unsigned lineno = 1;
	int ret;

	debug("starting to load properties");

	for (sol = data; sol - data < (ssize_t)size; sol = eol + 1, lineno++) {
		eol = memchr(sol, '\n', size - (sol - data));
		if (!eol)
			eol = &data[size - 1];
		*eol = '\0';

		skip_whitespace(&sol);

		/* Comment or empty line */
		if (*sol == '#' || sol == eol)
			continue;

		key = sol;
		value = memchr(key, '=', eol - key);
		if (!value) {
			error("line %d is invalid", lineno);
			return;
		}
		*value++ = '\0';

		/* snip key trailing whitespace */
		tmp = value - 2;
		while ((tmp > key) && isspace(*tmp))
			*tmp-- = '\0';

		if (*key == '\0' || tmp - key + 2 > PROPERTY_KEY_MAX) {
			error("Invalid key at line %d", lineno);
			return;
		}

		/* snip value trailing whitespace */
		tmp = eol - 1;
		while ((tmp > value) && isspace(*tmp))
			*tmp-- = '\0';

		skip_whitespace(&value);

		if (*value == '\0' || tmp - value + 2 > PROPERTY_VALUE_MAX) {
			error("Invalid value at line %d", lineno);
			return;
		}

		ret = property_set(key, value);
		if (ret < 0) {
			error("failed to set '%s' property to '%s', ret=%d",
			      key, value, ret);
			return;
		}
		debug("'%s' property set to '%s'", key, value);
	}

	debug("all properties have been successfully loaded");
}

static int verify_data(char *data, size_t *size)
{
	size_t i;

	if (*size == 0)
		goto fail;

	for (i = 0; i < *size - 1; i++)
		if (!isgraph(data[i]) && !isspace(data[i])) {
			debug("i=%zd/%zd, data[i]='%c'", i, *size, data[i]);
			goto fail;
		}

	if (isgraph(data[*size - 1]) || isspace(data[*size - 1])) {
		data = realloc(data, ++*size);
		if (!data) {
			error("Realloc failed");
			return -1;
		}

		data[*size - 1] = '\0';
	}

	if (data[*size - 1] != '\0')
		goto fail;

	return 0;

fail:
	error("This EFI variable data is invalid");
	return -1;
}

void usage(int status)
{
	FILE *out = status == EXIT_SUCCESS ? stdout : stderr;

	fprintf(out, "Usage: %s [ OPTIONS ] -e <efi-varmane>\n\
  Loads and sets the properties contained in the EFI EFI-VARNAME variable\n\
  associated with the GUID '"GUID_FORMAT"'.\n", COMMAND,
		EFI_PROP_GUID.a, EFI_PROP_GUID.b, EFI_PROP_GUID.c,
		bswap_16(EFI_PROP_GUID.d), EFI_PROP_GUID.e[0],
		EFI_PROP_GUID.e[1], EFI_PROP_GUID.e[2], EFI_PROP_GUID.e[3],
		EFI_PROP_GUID.e[4], EFI_PROP_GUID.e[5]);
	fprintf(out, "\
   --efi-varname, -e <name>   EFI variable NAME to load\n\
   --verbose                  print all debug messages\n\
   --help, -h                 display this help and exit\n");

	exit(status);
}

static struct option long_options[] = {
	{"help", no_argument, 0, 'h'},
	{"verbose", no_argument, &verbose_flag, 1},
	{"efi-varname",  required_argument, 0, 'e'},
	{0, 0, 0, 0}
};

int main(int argc, char **argv)
{
	uint32_t attributes;
	uint8_t *data = NULL;
	size_t size;
	char *varname = NULL;
	int option_index = 0;
	int ret;
	char c;

	while (1) {
		c = getopt_long(argc, argv, "he:",
				long_options, &option_index);
		if (c == -1)
			break;
		switch(c) {
		case 0:
			break;
		case 'h':
			usage(EXIT_SUCCESS);
			break;
		case 'e':
			varname = optarg;
			break;
		default:
			usage(EXIT_FAILURE);
			break;
		}
	}

	if (!varname)
		usage(EXIT_FAILURE);

	ret = efi_get_variable(EFI_PROP_GUID, varname, &data, &size,
			       &attributes);
	if (ret < 0) {
		error("unable to read the %s EFI variable, ret=%d",
		      varname, ret);
		return EXIT_FAILURE;
	}

	if (verify_data((char *)data, &size)) {
		free(data);
		return EXIT_FAILURE;
	}

	debug("EFI variable '%s' successfully loaded", varname);
	debug("data loaded: '%s'", data);

	load_properties_from_string((char *)data, size);
	free(data);

	return EXIT_SUCCESS;
}
