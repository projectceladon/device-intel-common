/*
 * Copyright (C) 2013 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *	  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#include <getopt.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#include <gpt/gpt.h>


void usage(void)
{
	printf("Usage: gptdump <options> <disk device>\n");
	printf("    -h Show this message\n");
}


int main(int argc, char **argv)
{
	int opt;
	char *device;
	struct gpt *gpt;
	char *buf;

	while ((opt = getopt(argc, argv, "h")) != -1) {
		switch (opt) {
		case 'h':
			usage();
			exit(EXIT_SUCCESS);
		default:
			usage();
			exit(EXIT_FAILURE);
		}
	}

	if (optind != argc - 1) {
		fprintf(stderr, "Expected one argument for the disk device\n");
		exit(EXIT_FAILURE);
	}

	device = argv[optind];

	gpt = gpt_init(device);
	if (!gpt) {
		fprintf(stderr, "gpt_init() failed\n");
		exit(EXIT_FAILURE);
	}

	if (gpt_read(gpt)) {
		fprintf(stderr, "Unable to read GPT\n");
		exit(EXIT_FAILURE);
	}

	buf = gpt_dump_header(gpt);
	if (buf) {
		printf("%s", buf);
		free(buf);
	} else {
		fprintf(stderr, "Memory error\n");
	}

	buf = gpt_dump_pentries(gpt);
	if (buf) {
		printf("%s", buf);
		free(buf);
	} else {
		fprintf(stderr, "Memory error\n");
	}

	gpt_close(gpt);
	return EXIT_SUCCESS;
}

