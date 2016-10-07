/*
 * Copyright (C) 2016 Intel Corporation
 *
 * Author: Guillaume Betous <guillaume.betous@intel.com>
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

#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <log/log.h>
#include <cutils/properties.h>

#define LOG_TAG "ioc_slcand"
char *slcand_init[] = {"slcand", "-S", "4000000", "-t", "hw", "ttyS1", "slcan0", NULL};
char *slcan_attach_init[] = {"slcan_attach", "-o", "-f", "/dev/ttyS1", NULL};
char *ifconfig_init[] = {"ifconfig", "slcan0", "up", NULL};
char *stack_ready[] = {"cansend", "slcan0", "0000FFFF#0A005555555555", NULL};
char *heartbeat[] = {"cansend", "slcan0", "0000FFFF#00015555555555", NULL};

void execute(char **argv)
{
	pid_t  pid;
	int    status;

	pid = fork();
	if (pid < 0) {
		ALOGE("forking child process failed\n");
		exit(1);
	}

	if (pid == 0) {
		if (execvp(*argv, argv) < 0) {
			ALOGE("exec failed\n");
			exit(1);
		}
	}
	else {
		while (wait(&status) != pid)
			sleep(1);
	}
}

int main(int argc, char *argv[])
{
	char recovery_process[PROPERTY_VALUE_MAX];

	execute(slcand_init);
	execute(slcan_attach_init);
	execute(ifconfig_init);
	execute(stack_ready);

	while(1) {
		execute(heartbeat);
		sleep(1);
	}

	return 0;
}
