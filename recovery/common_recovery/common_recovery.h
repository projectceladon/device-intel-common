/*
 * Copyright (C) 2013 Intel Corporation
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

#ifndef COMMON_RECOVERY_H
#define COMMON_RECOVERY_H

#include <bootloader.h>

ssize_t robust_read(int fd, void *buf, size_t count, int short_ok);
ssize_t robust_write(int fd, const void *buf, size_t count);
int read_write(int srcfd, int destfd);
int copy_file(const char *src, const char *dest);
int sysfs_read_int(int *ret, char *fmt, ...);

/* Functions for reading/writing the Bootloader Control block
 * which is normally stored as raw data in the 'misc' partition */
int read_bcb(const char *device, struct bootloader_message *bcb);
int write_bcb(const char *device, const struct bootloader_message *bcb);

char *dmi_detect_machine(void);

#endif
