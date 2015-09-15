/*
 * Copyright 2012 Intel Corporation
 *
 * Author: Andrew Boie <andrew.p.boie@intel.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
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

#include <edify/expr.h>
#include <gpt/gpt.h>
#include <common_recovery.h>
#include <cutils/properties.h>
#include <bootloader.h>
#include <cutils/android_reboot.h>

#define CHUNK 1024*1024

#define CAP_LOADING     "/sys/firmware/efi/capsule/loading"
#define CAP_DATA        "/sys/firmware/efi/capsule/data"

struct Capsule {
    char *path;
    struct stat f_stat;
    int existence;
};

static Value *CopyPartFn(const char *name, State *state, int argc, Expr *argv[])
{
    char *src = NULL;
    char *dest = NULL;
    int srcfd = -1;
    int destfd = -1;
    int result = -1;

    if (argc != 2)
        return ErrorAbort(state, "%s() expects 2 arguments, got %d", name, argc);

    if (ReadArgs(state, argv, 2, &src, &dest))
        return NULL;

    if (strlen(src) == 0 || strlen(dest) == 0) {
        ErrorAbort(state, "%s: Missing required argument", name);
        goto done;
    }

    srcfd = open(src, O_RDONLY);
    if (srcfd < 0) {
        ErrorAbort(state, "%s: Unable to open %s for reading: %s",
                name, src, strerror(errno));
        goto done;
    }
    destfd = open(dest, O_WRONLY);
    if (destfd < 0) {
        ErrorAbort(state, "%s: Unable to open %s for writing: %s",
                name, dest, strerror(errno));
        goto done;
    }

    if (read_write(srcfd, destfd)) {
        ErrorAbort(state, "%s: failed to write to: %s",
                name, dest);
        goto done;
    }

    result = 0;

done:
    if (srcfd >= 0)
        close(srcfd);
    if (destfd >= 0 && close(destfd) < 0) {
        ErrorAbort(state, "%s: failed to close destination device: %s",
                name, strerror(errno));
        result = -1;
    }
    free(src);
    free(dest);
    return (result ? NULL : StringValue(strdup("")));
}


static struct gpt_entry *find_android_partition(struct gpt *gpt, const char *name)
{
    uint32_t i;
    struct gpt_entry *e;
    int ret;
    int nlen = strlen(name);

    partition_for_each(gpt, i, e) {
        char *pname = gpt_entry_get_name(e);
        if (!pname)
            return NULL;

        int plen = strlen(pname);
        if (nlen > plen)
            continue;

        /* Match partition that ends with the specifid name
         * Various schemes prepend additional data */
        ret = strcmp(pname + (plen - nlen), name);
        free(pname);
        if (!ret)
            return e;
    }
    return NULL;
}


/* This func assumes that the char *dev that is passed is of size
 * PATH_MAX.  This is due to the in-place modification of that
 * char* for the return string. */
static int follow_links(char *dev)
{
    ssize_t ret;
    char buf[PATH_MAX];

    ret = readlink(dev, buf, sizeof(buf) - 1);
    if (ret < 0) {
        printf("Failed to readlink: %s\n", strerror(errno));
        return -1;
    }

    buf[ret] = '\0';

    printf("%s --> %s\n", dev, buf);

    strncpy(dev, buf, PATH_MAX);

    return 0;
}

/* This func assumes that the char *ptn that is passed is of size
 * PATH_MAX. ptn is modified in-place for the return string with
 * PATH_MAX as the assumed size. */
static int get_disk_node(char *ptn)
{
    int mj, mn, ret, val;
    struct stat sb;
    char link[PATH_MAX];

    if (stat(ptn, &sb)) {
       printf("Failed to stat ptn: %s\n", strerror(errno));
       return -1;
    }

    mj = major(sb.st_rdev);
    mn = minor(sb.st_rdev);

    /* Get the partition index; subtract this from minor to get to disk */
    ret = sysfs_read_int(&val, "/sys/dev/block/%d:%d/partition", mj, mn);
    if (ret) {
        printf("Error reading sysfs: %s\n", strerror(errno));
        return -1;
    }
    mn -= val;

    /* Corresponds to the entire block device */
    printf("Referencing GPT in block device %d:%d\n", mj, mn);

    ret = snprintf(link, PATH_MAX, "/sys/dev/block/%d:%d", mj, mn);
    if (ret < 0 || ret >= PATH_MAX) {
        printf("Error creating root sysfs node string: %d\n", ret);
        return -1;
    }

    printf("Following link: %s\n", link);

    ret = follow_links(link);
    if (ret < 0) {
        printf("Couldn't follow symlink: %s\n", link);
        return -1;
    }

    ret = snprintf(ptn, PATH_MAX, "/dev/block/%s", basename(link));
    if (ret < 0 || ret >= PATH_MAX) {
        printf("Error creating root node string: %d\n", ret);
        return -1;
    }

    if (stat(ptn, &sb) == -1) {
        printf("Failed to stat path (%s): %s\n", ptn, strerror(errno));
        return -1;
    }

    if (!S_ISBLK(sb.st_mode)) {
        printf("Path is not a block device: %s\n", ptn);
        return -1;
    }

    printf("Root block device = %s\n", ptn);

    return 0;
}


static void swap64bit(uint64_t *a, uint64_t *b)
{
    uint64_t tmp;

    tmp = *a;
    *a = *b;
    *b = tmp;
}


static Value *SwapEntriesFn(const char *name, State *state,
        int argc, Expr *argv[])
{
    int rc;

    char *dev = NULL;
    char *part1 = NULL;
    char *part2 = NULL;
    char buf[PATH_MAX];

    struct gpt_entry *e1, *e2;
    struct gpt *gpt = NULL;
    Value *ret = NULL;

    if (argc != 3)
        return ErrorAbort(state, "%s() expects 3 arguments, got %d", name, argc);

    if (ReadArgs(state, argv, 3, &dev, &part1, &part2))
        return NULL;

    if (strlen(dev) == 0 || strlen(part1) == 0 || strlen(part2) == 0) {
        ErrorAbort(state, "%s: Missing required argument", name);
        goto done;
    }

    if (strlen(dev) > (PATH_MAX - 1)) {
        ErrorAbort(state, "%s: dev too large", name);
        goto done;
    }

    /* If the device node is a symlink, follow it to the 'real'
     * device node and then get the node for the entire disk.
     *
     * dev is copied to buf to ensure that the character array
     * is of size PATH_MAX; required for follow_links. */
    strncpy(buf, dev, PATH_MAX);
    rc = follow_links(buf);
    if (rc < 0) {
        ErrorAbort(state, "%s: Couldn't follow symlink", name);
        goto done;
    }

    /* Since get_disk_node will call follow_links with the arg passed,
     * it must be of size PATH_MAX for the same reasoning as above. */
    rc = get_disk_node(buf);
    if (rc < 0) {
        ErrorAbort(state, "%s: Couldn't get disk node from %s", name, buf);
        goto done;
    }

    gpt = gpt_init(buf);
    if (!gpt) {
        ErrorAbort(state, "%s: Couldn't init GPT structure", name);
        goto done;
    }

    if (gpt_read(gpt)) {
        ErrorAbort(state, "%s: Failed to read GPT", name);
        goto done;
    }

    e1 = find_android_partition(gpt, part1);
    if (!e1) {
        ErrorAbort(state, "%s: unable to find partition '%s'", name, part1);
        goto done;
    }

    e2 = find_android_partition(gpt, part2);
    if (!e2) {
        ErrorAbort(state, "%s: unable to find partition '%s'", name, part1);
        goto done;
    }

    swap64bit(&e1->first_lba, &e2->first_lba);
    swap64bit(&e1->last_lba, &e2->last_lba);

    if (gpt_write(gpt))
        ErrorAbort(state, "%s: failed to write GPT", name);

    ret = StringValue(strdup(""));
done:
    if (gpt)
        gpt_close(gpt);
    free(dev);
    free(part1);
    free(part2);

    return ret;
}

static const char *SFU_DST = "/bootloader/BIOSUPDATE.fv";

static Value *CopySFUFn(const char *name, State *state, int argc, Expr *argv[])
{
    struct stat sb;
    char *result = NULL;
    char *sfu_src = NULL;

    if (argc != 1)
        return ErrorAbort(state, "%s() expects 1 argument, got %d", name, argc);

    if (ReadArgs(state, argv, 1, &sfu_src))
        return NULL;

    if (strlen(sfu_src) == 0) {
        ErrorAbort(state, "sfu_src argyment to %s can't be empty", name);
        goto done;
    }

    if (!stat(sfu_src, &sb)) {
        if (copy_file(sfu_src, SFU_DST)) {
            ErrorAbort(state, "Couldn't copy SFU capsule to ESP");
            goto done;
        }
        printf("Copied SFU capsule from %s to %s\n", sfu_src, SFU_DST);
    } else {
        printf("No SFU capsule found in %s to stage\n", sfu_src);
    }
    result = strdup("");

done:
    free(sfu_src);
    return StringValue(result);
}


void Register_libupdater_esp(void)
{
    printf("Registering edify commands for EFI\n");

    RegisterFunction("swap_entries", SwapEntriesFn);
    RegisterFunction("copy_partition", CopyPartFn);
    RegisterFunction("copy_sfu", CopySFUFn);
}

