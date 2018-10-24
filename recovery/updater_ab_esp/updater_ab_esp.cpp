/*
 * Copyright (c) 2018, Intel Corporation
 * All rights reserved.
 *
 * Author: Lihua Zhou <lihuax.zhou@intel.com>
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

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h>
#include <sys/mount.h>
#include <errno.h>

#ifndef errno
extern int errno;
#endif

#define KERNELFLINGER_RELATIVE_PATH    "/../firmware/kernelflinger.efi"
#define BIOSUPDATE_RELATIVE_PATH	    "/../firmware/BIOSUPDATE.fv"
#define DEV_PATH                       "/dev/block/by-name/bootloader"
#define MOUNT_POINT                    "/bootloader"
#define DESTINATION_FILE               "/bootloader/EFI/BOOT/kernelflinger_new.efi"
#define BIOSUPDATE_DESTINATION_FILE    "/bootloader/BIOSUPDATE.fv"

bool is_file_exist(const char *file_path)
{
	if (file_path == NULL)
		return false;
	if (access(file_path, F_OK) == 0)
		return true;
	return false;
}

int file_copy(const char *src, const char *des)
{
	FILE *input, *output;
	int len;
	size_t buffer_size = 1024 * 1024;
	char *buffer = (char *)malloc(buffer_size);
	if (buffer == NULL) {
		printf("Failed to malloc 1MB buffer");
		return -1;
	}
	if ((input = fopen(src, "r")) == NULL) {
		printf("%s does not exist: %s \n", src, strerror(errno));
		free(buffer);
		return -1;
	}
	if ((output = fopen(des, "w")) == NULL) {
		printf("Open des file fails: %s \n", strerror(errno));
		fclose(input);
		free(buffer);
		return -2;
	}

	while (len = fread(buffer, 1, buffer_size, input))
		fwrite(buffer, 1, len, output);

	free(buffer);
	fclose(input);
	fclose(output);

	return 0;
}

int main(int argc, char** argv)
{
	printf("This tool is used for update the kernelflinger.efi\n");

	// Check whether ../firmware/kernelflinger.efi exist.
	// If not exist, exit.
	char cwdbuf[PATH_MAX];
	if (getcwd(cwdbuf, sizeof(cwdbuf)) != NULL)
		printf("Current directory: %s \n", cwdbuf);
	else
		printf("Get current directory failed: %s \n", strerror(errno));

	char file_path[PATH_MAX];
	char file_path_bios[PATH_MAX];
	int is_exist_kernelflinger = 0;
	int is_exist_bios = 0;
	char *selfdir = strrchr(argv[0], '/');
	size_t selfdir_len = 0;
	if (selfdir != NULL) {
		selfdir_len = selfdir - argv[0];
		if (selfdir_len < sizeof(file_path)) {
			bcopy(argv[0], file_path, selfdir_len);
			bcopy(argv[0], file_path_bios, selfdir_len);
		}
	}
	snprintf(file_path + selfdir_len, sizeof(file_path) - selfdir_len, "%s", KERNELFLINGER_RELATIVE_PATH);
	if (!is_file_exist(file_path)) {
		printf("File %s does not exist!\n", file_path);
	} else{
		is_exist_kernelflinger = 1;
		printf("File %s exists!\n", file_path);
	}

	snprintf(file_path_bios + selfdir_len, sizeof(file_path_bios) - selfdir_len, "%s", BIOSUPDATE_RELATIVE_PATH);
	if (!is_file_exist(file_path_bios)) {
		printf("File %s does not exist!\n", file_path_bios);
	} else{
		is_exist_bios = 1;
		printf("File %s exists!\n", file_path_bios);
	}

	// Mount /dev/block/by-name/bootloader to /bootloader
	if (mkdir(MOUNT_POINT, 0755) != 0)
		printf("mkdir %s fails: %s \n", MOUNT_POINT, strerror(errno));
	else
		printf("mkdir %s succeeds!\n", MOUNT_POINT);

	if (mount(DEV_PATH, MOUNT_POINT, "vfat", 0, NULL) != 0) {
		printf("Mount %s to %s fails: %s \n", DEV_PATH, MOUNT_POINT, strerror(errno));
		return -1;
	} else
		printf("Mount %s to %s succeeds!\n", DEV_PATH, MOUNT_POINT);

	// Copy ../firmware/kernelflinger.efi to /bootloader/EFI/BOOT/kernelflinger_new.efi
	//check whether des file exists
	if(is_exist_kernelflinger == 1)
	{
		if (!is_file_exist(DESTINATION_FILE))
			printf("File %s does not exist! Create it!\n", DESTINATION_FILE);
		else
			printf("File %s exists! Overwrite it!\n", DESTINATION_FILE);

		if (file_copy(file_path, DESTINATION_FILE) != 0) {
			printf("File %s copy to %s fails!\n", file_path, DESTINATION_FILE);
		} else
			printf("File %s copy to %s succeeds!\n", file_path, DESTINATION_FILE);
	}

	// Copy ../firmware/kernelflinger.efi to /bootloader/EFI/BOOT/kernelflinger_new.efi
	//check whether des file exists
	if(is_exist_bios == 1)
	{
		if (!is_file_exist(BIOSUPDATE_DESTINATION_FILE))
			printf("File %s does not exist! Create it!\n", BIOSUPDATE_DESTINATION_FILE);
		else
			printf("File %s exists! Overwrite it!\n", BIOSUPDATE_DESTINATION_FILE);

		if (file_copy(file_path_bios, BIOSUPDATE_DESTINATION_FILE) != 0) {
			printf("File %s copy to %s fails!\n", file_path_bios, BIOSUPDATE_DESTINATION_FILE);
		} else
			printf("File %s copy to %s succeeds!\n", file_path_bios, BIOSUPDATE_DESTINATION_FILE);
	}

	// Umount /bootloader
	if (umount(MOUNT_POINT) != 0) {
		printf("Unmount %s fails: %s \n", MOUNT_POINT, strerror(errno));
		return -1;
	} else
		printf("Unmount %s succeeds!\n", MOUNT_POINT);

	return 0;
}
