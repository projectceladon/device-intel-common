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

#define KERNELFLINGER_ABSOLUTE_PATH    "/mnt/firmware/kernelflinger.efi"
#define BIOSUPDATE_ABSOLUTE_PATH       "/mnt/firmware/BIOSUPDATE.fv"
#define KFLD_ABSOLUTE_PATH             "/mnt/firmware/kfld.efi"
#define ESP_DEV_PATH                   "/dev/block/by-name/esp"
#define DEV_PATH                       "/dev/block/by-name/bootloader"
#define MOUNT_POINT                    "/bootloader"
#define ESP_MOUNT_POINT                "/esp"
#define KFLD_DESTINATION_FILE          "/esp/EFI/INTEL/KFLD_NEW.EFI"
#define KERNELFLINGER_DESTINATION_FILE "/bootloader/EFI/BOOT/kernelflinger_new.efi"
#define BIOSUPDATE_DESTINATION_FILE    "/bootloader/BIOSUPDATE.fv"
#define ESP_BIOSUPDATE_DEST_FILE       "/esp/BIOSUPDATE.fv"

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

	while ((len = fread(buffer, 1, buffer_size, input)))
		fwrite(buffer, 1, len, output);

	free(buffer);
	fclose(input);
	fclose(output);

	return 0;
}

int main(int /* argc */, char** /* argv */)
{
	printf("This tool is used to update kernelflinger.efi, kfld.efi and bios\n");

	// Check whether ../firmware/kernelflinger.efi exist.
	// If not exist, exit.
	char file_path[PATH_MAX] = {0};
	char file_path_bios[PATH_MAX] = {0};
	int is_exist_efi = 0;
	int is_exist_bios = 0;

	const char *dest_path = NULL;
	const char *biosupdate_dest_path = NULL;
	const char *dev_path = NULL;
	const char *mount_point = NULL;

	if (is_file_exist(ESP_DEV_PATH)) {
		dev_path = ESP_DEV_PATH;
		dest_path = KFLD_DESTINATION_FILE;
		biosupdate_dest_path = ESP_BIOSUPDATE_DEST_FILE;
		mount_point = ESP_MOUNT_POINT;
		snprintf(file_path, sizeof(file_path), "%s", KFLD_ABSOLUTE_PATH);
	} else {
		dev_path = DEV_PATH;
		dest_path = KERNELFLINGER_DESTINATION_FILE;
		biosupdate_dest_path = BIOSUPDATE_DESTINATION_FILE;
		mount_point = MOUNT_POINT;
		snprintf(file_path, sizeof(file_path), "%s", KERNELFLINGER_ABSOLUTE_PATH);
	}

	if (!is_file_exist(file_path)) {
		is_exist_efi = 0;
		printf("File %s does not exist!\n", file_path);
	} else {
		is_exist_efi = 1;
		printf("File %s exists!\n", file_path);
	}

	snprintf(file_path_bios, sizeof(file_path_bios), "%s", BIOSUPDATE_ABSOLUTE_PATH);
	if (!is_file_exist(file_path_bios)) {
		is_exist_bios = 0;
		printf("File %s does not exist!\n", file_path_bios);
	} else {
		is_exist_bios = 1;
		printf("File %s exists!\n", file_path_bios);
	}

	if (is_exist_efi == 0 && is_exist_bios == 0) {
		printf("File %s and %s all not exist!\n", file_path, file_path_bios);
		return -1;
	}
	// Mount partition to mount_point
	if (mkdir(mount_point, S_IRWXU|S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH) != 0)
		printf("mkdir %s fails: %s \n", mount_point, strerror(errno));
	else
		printf("mkdir %s succeeds!\n", mount_point);

	if (mount(dev_path, mount_point, "vfat", 0, NULL) != 0) {
		printf("Mount %s to %s fails: %s \n", dev_path, mount_point, strerror(errno));
		return -1;
	} else
		printf("Mount %s to %s succeeds!\n", dev_path, mount_point);

	// Copy ../firmware/kernelflinger.efi to /bootloader/EFI/BOOT/kernelflinger_new.efi
	// or copy "kfld.efi" to "/bootloader/EFI/BOOT/kfld_new.efi"
	if (is_exist_efi == 1) {
		if (!is_file_exist(dest_path))
			printf("File %s does not exist! Create it!\n", dest_path);
		else
			printf("File %s exists! Overwrite it!\n", dest_path);

		if (file_copy(file_path, dest_path) != 0) {
			printf("File %s copy to %s fails!\n", file_path, dest_path);
			return -1;
		}
		printf("File %s copy to %s succeeds!\n", file_path, dest_path);
	}

	// Copy ../firmware/BIOSUPDATE.fv to /bootloader/BIOSUPDATE.fv
	// or copy BIOSUPDATE.fv to /esp/BIOSUPDATE.fv
	if (is_exist_bios == 1) {
		if (!is_file_exist(biosupdate_dest_path))
			printf("File %s does not exist! Create it!\n", biosupdate_dest_path);
		else
			printf("File %s exists! Overwrite it!\n", biosupdate_dest_path);

		if (file_copy(file_path_bios, biosupdate_dest_path) != 0) {
			printf("File %s copy to %s fails!\n", file_path_bios, biosupdate_dest_path);
			return -1;
		}
		printf("File %s copy to %s succeeds!\n", file_path_bios, biosupdate_dest_path);
	}

	// Umount bootloader or esp
	if (umount(mount_point) != 0) {
		printf("Unmount %s fails, but proceed since file copy succeeds: %s \n",
			mount_point, strerror(errno));
	} else
		printf("Unmount %s succeeds!\n", mount_point);

	return 0;
}
