/*
 * Copyright (C) 2012 The Android Open Source Project
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

#include <errno.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>

#include <common_recovery.h>
#include <edify/expr.h>
#include <minzip/DirUtil.h>
#include <updater/updater.h>
#include <cutils/properties.h>

#define CHUNK 1024*1024

ssize_t robust_read(int fd, void *buf, size_t count, int short_ok)
{
    unsigned char *pos = buf;
    ssize_t ret;
    ssize_t total = 0;
    do {
        ret = read(fd, pos, count);
        if (ret < 0) {
            if (errno != EINTR)
                return -1;
            else
                continue;
        }
        count -= ret;
        pos += ret;
        total += ret;
    } while (count && !short_ok);

    return total;
}


ssize_t robust_write(int fd, const void *buf, size_t count)
{
    const char *pos = buf;
    ssize_t total_written = 0;
    ssize_t written;

    /* Short write due to insufficient space OK;
     * partitions may not be exactly the same size
     * but underlying fs should be min of both sizes */
    do {
        written = write(fd, pos, count);
        if (written < 0) {
            if (errno != EINTR)
                return -1;
            else
                continue;
        }
        count -= written;
        pos += written;
        total_written += written;
    } while (count && written);

    return total_written;
}

/* Caller needs to provide valid fd(s) and close them after call this function */
int read_write(int srcfd, int destfd) {
    char *buf = NULL;
    ssize_t to_write;
    ssize_t written;
    int ret = -1;

    buf = malloc(CHUNK);
    if (!buf) {
        printf("%s: memory allocation error\n", __FUNCTION__);
        return -1;
    }

    while (1) {
        to_write = robust_read(srcfd, buf, CHUNK, 1);
        if (to_write < 0) {
            printf("%s: failed to read source data: %s\n",
                    __FUNCTION__, strerror(errno));
            goto out;
        }
        if (!to_write)
            break;

        written = robust_write(destfd, buf, to_write);
        if (written != to_write) {
            printf("%s: failed to write data: %s\n", __FUNCTION__,
                    strerror(errno));
            goto out;
        }
    }

    ret = 0;
out:
    free(buf);
    return ret;
}


int copy_file(const char *src, const char *dest)
{
    int srcfd = -1;
    int destfd = -1;

    srcfd = open(src, O_RDONLY);
    if (srcfd < 0) {
        printf("%s: %s couldn't be opened for reading\n", __func__, src);
        return -1;
    }
    destfd = open(dest, O_TRUNC | O_CREAT | O_WRONLY, 0700);
    if (destfd < 0) {
        printf("%s: %s couldn't be opened for reading\n", __func__, dest);
        goto out;
    }

    if (read_write(srcfd, destfd)) {
        printf("%s: file copy operation failed\n", __func__);
        goto out;
    }

    if (close(destfd)) {
        printf("%s: couldn't close output file\n", __func__);
        goto out;
    }
    close(srcfd);
    return 0;
out:
    if (srcfd >= 0)
        close(srcfd);
    if (destfd >= 0)
        close(destfd);
    return -1;
}


int sysfs_read_int(int *ret, char *fmt, ...)
{
    char path[PATH_MAX];
    va_list ap;
    char buf[4096];
    int fd;
    ssize_t bytes_read;
    int rv = -1;

    va_start(ap, fmt);
    vsnprintf(path, sizeof(path), fmt, ap);
    va_end(ap);

    fd = open(path, O_RDONLY);
    if (fd < 0)
        return -1;

    bytes_read = robust_read(fd, buf, sizeof(buf) - 1, 1);
    if (bytes_read < 0)
        goto out;

    buf[bytes_read] = '\0';
    *ret = atoi(buf);
    rv = 0;
out:
    close(fd);
    return rv;
}


int read_bcb(const char *device, struct bootloader_message *bcb)
{
    int fd;
    int ret = 0;

    fd = open(device, O_RDONLY);

    if (fd < 0) {
        printf("Coudln't open BCB device for reading %s: %s\n", device, strerror(errno));
        return -1;
    }

    if (robust_read(fd, bcb, sizeof(*bcb), 0) < 0) {
        printf("Couldn't read BCB data\n");
        ret = -1;
    }

    if (close(fd)) {
        printf("Couldn't close BCB device: %s\n", strerror(errno));
        ret = -1;
    }

    return ret;
}


int write_bcb(const char *device, const struct bootloader_message *bcb)
{
    int fd;
    int ret = 0;

    fd = open(device, O_WRONLY);

    if (fd < 0) {
        printf("Coudln't open BCB device for writing %s: %s\n", device, strerror(errno));
        return -1;
    }

    if (robust_write(fd, bcb, sizeof(*bcb)) < 0) {
        printf("Couldn't write BCB data\n");
        ret = -1;
    }

    if (close(fd)) {
        printf("Couldn't close BCB device: %s\n", strerror(errno));
        ret = -1;
    }

    return ret;
}


static Value *GetBCBStatus(const char *name, State *state, int __unused argc, Expr *argv[])
{
    char *device;
    char *status;
    struct bootloader_message bcb;

    if (ReadArgs(state, argv, 1, &device))
        return NULL;

    if (strlen(device) == 0) {
        ErrorAbort(state, "%s: Missing required argument", name);
        return NULL;
    }

    if (read_bcb(device, &bcb)) {
        ErrorAbort(state, "%s: Failed to read Bootloader Control Block", name);
        return NULL;
    }

    status = strdup(bcb.status);
    printf("Read status '%s' from Bootloader Control Block\n", status);

    return StringValue(status);
}


/* Similar functionality in init, but /system isn't available and up-to-date
 * until now. */
char *dmi_detect_machine(void)
{
    char dmi[256], buf[256], *hash, *tag, *name, *toksav, allmatched;
    char dmi_detect[PROPERTY_VALUE_MAX];
    FILE *dmif, *cfg;
    char *ret = NULL;

    /* Skip if disabled */
    property_get("ro.boot.dmi_detect", dmi_detect, "1");
    if (!strcmp(dmi_detect, "0")) {
        printf("DMI machine detection disabled\n");
        return NULL;
    }

    /* Fail silently (no error) on devices without DMI */
    dmif = fopen("/sys/devices/virtual/dmi/id/modalias", "r");
    if (!dmif || !fgets(dmi, sizeof(dmi), dmif)) {
        printf("Couldn't open DMI modalias\n");
        return NULL;
    }
    fclose(dmif);

    /* ...or if the system filesystem lacks configuration */
    if (!(cfg = fopen("/system/etc/dmi-machine.conf", "r"))) {
        printf("DMI machine configuration not present\n");
        return NULL;
    }

    while (fgets(buf, sizeof(buf), cfg)) {
        /* snip comments */
        if ((hash = strchr(buf, '#')))
            *hash = 0;

        /* parse line: cfg name, then a list of tags to test.  If they
         * all match then load the config file and return (note that
         * "no tags" means "everything matched" and can be used to
         * load a default if needed, though that is probably best done
         * with build.props) */
        allmatched = 1;
        if ((name = strtok_r(buf, " \t\v\r\n", &toksav))) {
            while ((tag = strtok_r(NULL, " \t\v\r\n", &toksav)))
                if (!strstr(dmi, tag))
                    allmatched = 0;

            if (allmatched) {
                ret = strdup(name);
                break;
            }
        }
    }

    fclose(cfg);
    return ret;
}



// mkdir(pathname)
static Value *MkdirFn(const char *name, State *state, int argc, Expr *argv[]) {
    Value *ret = NULL;
    char *pathname = NULL;

    if (ReadArgs(state, argv, 1, &pathname) < 0) {
        return NULL;
    }

    if (strlen(pathname) == 0) {
        ErrorAbort(state, "pathname argument to %s can't be empty", name);
        goto done;
    }

    if (mkdir(pathname, 0755) < 0) {
        ErrorAbort(state, "%s: cannot create %s", name, pathname);
    }

    ret = StringValue(strdup(""));

done:
    if (pathname)
        free(pathname);

    return ret;
}

// package_extract_file_safe(package_path, destination_path)
//
// this extracts the file with a temporary name first, and
// then renames to overwrite the original file.
static Value* PackageExtractFileSafeFn(const char* name, State* state,
                               int argc, Expr* argv[]) {
    if (argc != 2) {
        return ErrorAbort(state, "%s() expects args, got %d",
                          name, argc);
    }

    bool success = false;
    char* zip_path;
    char* dest_path;
    char* dest_path_tmp;

    if (ReadArgs(state, argv, 2, &zip_path, &dest_path) < 0) return NULL;

    if (asprintf(&dest_path_tmp, "%sXXXXXX", dest_path) < 0) return NULL;

    ZipArchive* za = ((UpdaterInfo*)(state->cookie))->package_zip;
    const ZipEntry* entry = mzFindZipEntry(za, zip_path);
    if (entry == NULL) {
        fprintf(stderr, "%s: no %s in package\n", name, zip_path);
        goto done2;
    }

    int tmp_fd = mkstemp(dest_path_tmp);
    if (tmp_fd < 0) {
        fprintf(stderr, "%s: can't open %s for write: %s\n",
                name, dest_path, strerror(errno));
        goto done2;
    }
    success = mzExtractZipEntryToFile(za, entry, tmp_fd);
    close(tmp_fd);

    if (rename(dest_path_tmp, dest_path) < 0) {
        fprintf(stderr, "%s: can't rename %s to %s: %s\n",
                name, dest_path_tmp, dest_path, strerror(errno));
        goto done2;
    }

done2:
    free(zip_path);
    free(dest_path);
    free(dest_path_tmp);
    return StringValue(strdup(success ? "t" : ""));
}

void Register_libcommon_recovery(void)
{
    RegisterFunction("mkdir", MkdirFn);
    RegisterFunction("package_extract_file_safe", PackageExtractFileSafeFn);
    RegisterFunction("get_bcb_status", GetBCBStatus);
}
