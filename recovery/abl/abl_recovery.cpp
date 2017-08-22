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

#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <ftw.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <regex.h>
#include <dirent.h>
#include <sys/mount.h>
#include <libgen.h>
#include <stdbool.h>
#include <string>

#include <edify/expr.h>

#include <common_recovery.h>
#include <cutils/properties.h>
#include <bootloader.h>
#include <cutils/android_reboot.h>


#define CAPSULE_SYSFS_ENTRY "/sys/kernel/capsule/capsule_name"

static Value *CapsuleABL(const char *name, State *state,
        const std::vector<std::unique_ptr<Expr>>& argv) {
    FILE *f_capsule;
    Value *ret = NULL;
    std::vector<std::string> args;
    int i;

    if (!ReadArgs(state, argv, &args))
        return NULL;

    if (args.size() == 0) {
        ErrorAbort(state, kArgsParsingFailure, "%s: Missing required argument", name);
        return NULL;
    }

    f_capsule = fopen(CAPSULE_SYSFS_ENTRY, "w+");
    if (!f_capsule) {
        ErrorAbort(state, kFileOpenFailure, "%s: cannot access %s", name, CAPSULE_SYSFS_ENTRY);
        goto done;
    }

    i = fprintf(f_capsule, "%s", args[0].c_str());

    if (i < 0) {
        ErrorAbort(state, kFwriteFailure, "%s: could not write in %s. errno=%d str=%s",
                   name, CAPSULE_SYSFS_ENTRY, errno, strerror(errno));
        goto done;
    }
    else
        printf("writing %d bytes : %s in %s\n", i, args[0].c_str(), CAPSULE_SYSFS_ENTRY);

    fclose(f_capsule);
    ret = StringValue(strdup(""));

done:
    return ret;
}

void Register_libabl_recovery(void)
{
    RegisterFunction("capsule_abl", CapsuleABL);
}
