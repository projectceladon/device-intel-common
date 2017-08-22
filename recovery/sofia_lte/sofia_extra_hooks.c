/*
 * Copyright (C) 2015 Intel Mobile Communications GmbH
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
 *
 * Notes - Intel Mobile Communications:
 * Variant specific updater binary functions to include inside an OTA update
 * Most logic in init_sys_paths() copied from services/jni/com_android_server_BatteryService.cpp
 */


#include <stdio.h>
#include <errno.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>
#include <dirent.h>
#include <limits.h>
#include <sys/statfs.h>
#include <sys/ioctl.h>
#include <linux/fs.h>
#include <sys/utsname.h>

#include "edify/expr.h"
#include <cutils/android_reboot.h>
#include <common_recovery.h>


Value* maybe_install_firmware_update(const char* name, State* state, int argc, Expr* argv[])
{
    struct bootloader_message boot;
    char *device = NULL;
    Value *ret = NULL;

    if (argc != 1) {
        ErrorAbort(state, kArgsParsingFailure, "%s() expects 1 arg, got %d",
                          name, argc);
        goto done;
    }

    if (ReadArgs(state, argv, 1, &device))
        goto done;


    if (strlen(device) == 0) {
        ErrorAbort(state, kArgsParsingFailure, "%s: Missing required argument", name);
        goto done;
    }

    memset(&boot, 0, sizeof(boot));

    if (read_bcb(device, &boot)) {
        ErrorAbort(state, kFreadFailure, "Couldn't read BCB from %s", device);
        goto done;
    }

    /* Tell the bootloader to engage the bootloader update mechanism */
    strncpy(boot.command, "update-radio/hboot", sizeof(boot.command));

    /* Reset the command line to just 'recovery', the bootloader will
     * add extra arguments to it to convey error status if necessary */
    strncpy(boot.recovery, "recovery\n", sizeof(boot.recovery));

    if (write_bcb(device, &boot)) {
        ErrorAbort(state, kFwriteFailure, "Couldn't write BCB to %s", device);
        goto done;
    }

    ret = StringValue(strdup(""));

done:
    free(device);
    return ret;
}


void Register_librecovery_sofia_lte_1a_intel()
{
    fprintf(stderr, "Registering device extensions\n");
    RegisterFunction("intel_install_firmware_update",
                     maybe_install_firmware_update);
}
