/*
 * Copyright (C) 2015 Intel Corporation
 *
 * Author: Sylvain Chouleur <sylvain.chouleur@intel.com>
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
#include <unistd.h>
#include <cutils/properties.h>
#include <ctype.h>
#include <sys/types.h>
#include <pwd.h>
#include <sys/stat.h>

#define LOG_TAG "set_storage"
#include <log/log.h>

#define LINK_PATH "/dev/block/by-name"
static const char *diskbus_prop = "ro.boot.diskbus";
static const char *storage_path = "/dev/block/pci/pci0000:00/0000:00:%s/by-name";
static const char *link_device = LINK_PATH;
static const char *diskbus_format = "dd.f"; /* Device.Function */
static const char *persistent_partition = LINK_PATH "/android_persistent";

int main(int argc, char **argv)
{
	int ret;
	char pci_id[PROPERTY_VALUE_MAX];
	uint8_t *data;
	size_t size;
	unsigned i;
	char *path;
	struct passwd *passwd;

	ret = property_get(diskbus_prop, pci_id, "");
	if (ret != (int)strlen(diskbus_format)) {
		ALOGE("Inconsistent boot device pci id: ret=%d\n", ret);
		return EXIT_FAILURE;
	}

	for (i = 0; i < strlen(pci_id); i++)
		pci_id[i] = (char)tolower(pci_id[i]);

	ret = asprintf(&path, storage_path, pci_id);
	if (ret == -1) {
		ALOGE("Failed to format storage path\n");
		return EXIT_FAILURE;
	}

	ret = symlink(path, link_device);
	free(path);
	if (ret) {
		ALOGE("Failed to symlink storage device %s\n", path);
		return EXIT_FAILURE;
	}

	passwd = getpwnam("system");
	if (!passwd) {
		ALOGE("Failed to get 'system' uid/gid\n");
		return EXIT_FAILURE;
	}

	ret = chown(persistent_partition, passwd->pw_uid, passwd->pw_gid);
	if (ret) {
		ALOGE("Failed to set owner of persistent partition\n");
		return EXIT_FAILURE;
	}

	ret = chmod(persistent_partition, S_IRGRP | S_IWGRP | S_IRUSR | S_IWUSR);
	if (ret) {
		ALOGE("Failed to set permissions of persistent partition\n");
		return EXIT_FAILURE;
	}

	return EXIT_SUCCESS;
}
