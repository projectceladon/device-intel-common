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


#include <ctype.h>
#include <dirent.h>
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <linux/fs.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <inttypes.h>
#include <string.h>
#include <sys/ioctl.h>

#if DEBUG_STDOUT
#define pr_debug    printf
#define pr_error    printf
#else
#define pr_debug    ALOGD
#define pr_error    ALOGE
#define LOG_TAG     "libgpt"
#include <cutils/log.h>
#endif

#include <zlib.h>
#include <gpt/gpt.h>

#define pr_perror(x, ...) pr_error(x ": %s\n", ##__VA_ARGS__, strerror(errno));

#define min(a,b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a < _b ? _a : _b; })


static const struct guid efi_sys_ptn = GPT_GUID(0xC12A7328, 0xF81F, 0x11D2,
		0xBA4B, 0x00A0C93EC93BULL);

static const struct guid ms_reserved_ptn = GPT_GUID(0xE3C9E316, 0x0B5C, 0x4DB8,
		0x817D, 0xF92DF00215AEULL);

static const struct guid ms_data_ptn = GPT_GUID(0xEBD0A0A2, 0xB9E5, 0x4433,
		0x87C0, 0x68B6B72699C7ULL);

static const struct guid linux_ptn = GPT_GUID(0x0FC63DAF, 0x8483, 0x4772,
		0x8E79, 0x3D69D8477DE4ULL);

static const struct guid linux_swap = GPT_GUID(0x0657FD6D, 0xA4AB, 0x43C4,
		0x84E5, 0x0933C84B4F4FULL);

/* These aren't defined anywhere so I generated them */
static const struct guid android_boot = GPT_GUID(0x49a4d17f, 0x93a3, 0x45c1,
		0xa0de, 0xf50b2ebe2599ULL);

static const struct guid android_recovery = GPT_GUID(0x4177c722, 0x9e92, 0x4aab,
		0x8644, 0x43502bfd5506ULL);

static const struct guid android_tertiary = GPT_GUID(0x767941d0, 0x2085, 0x11e3,
		0xad3b, 0x6cfdb94711e9ULL);

static const struct guid android_misc = GPT_GUID(0xef32a33b, 0xa409, 0x486c,
		0x9141, 0x9ffb711f6266ULL);

static const struct guid android_metadata = GPT_GUID(0x20ac26be, 0x20b7, 0x11e3,
		0x84c5, 0x6cfdb94711e9ULL);

struct mbr_chs {
	uint8_t head;
	uint8_t sector; /* sector in bits 5-0, 7-6 hi bits of cyl */
	uint8_t cylinder;
} __attribute__((__packed__));

struct mbr_entry {
	uint8_t status;
	struct mbr_chs first_chs;
	uint8_t type;
	struct mbr_chs last_chs;
	uint32_t first_lba;
	uint32_t lba_count;
} __attribute__((__packed__));

struct mbr {
	uint32_t disk_sig;
	uint16_t reserved;
	struct mbr_entry entries[4];
	uint16_t sig;
} __attribute__((__packed__));


const struct guid *get_guid_type(enum part_type t)
{
	switch (t) {
	case PART_LINUX:
		return &linux_ptn;
	case PART_LINUX_SWAP:
		return &linux_swap;
	case PART_MS_DATA:
		return &ms_data_ptn;
	case PART_ESP:
		return &efi_sys_ptn;
	case PART_MS_RESERVED:
		return &ms_reserved_ptn;
	case PART_ANDROID_BOOT:
		return &android_boot;
	case PART_ANDROID_MISC:
		return &android_misc;
	case PART_ANDROID_RECOVERY:
		return &android_recovery;
	case PART_ANDROID_TERTIARY:
		return &android_tertiary;
	case PART_ANDROID_METADATA:
		return &android_metadata;
	default:
		return NULL;
	}
}


/* Generate version 4 UUID as per RFC 4122 */
static int generate_uuid(struct guid *uuid)
{
	int fd;
	size_t to_read;
	fd = open("/dev/urandom", O_RDONLY);
	to_read = sizeof(*uuid);
	if (fd < 0) {
		pr_perror("open");
		return -1;
	}

	while (to_read) {
		int rv;
		rv = read(fd, uuid, sizeof(*uuid));
		if (rv <= 0 && errno != EINTR) {
			pr_perror("read");
			close(fd);
			return -1;
		}
		to_read -= rv;
	}
	close(fd);
	/* Set bits 6 and 7 of clock_seq_hi_and_reserved to 0 and 1 */
	uuid->data4[0] = (uuid->data4[0] & 0x3F) | 0x80;
	/* Set bits 12-15 of time_hi_and_version to 0x4 (Version
	 * 4 randomly generated UUID) */
	uuid->data3 = (uuid->data3 & 0x0FFF) | 0x4000;
	return 0;
}


int guidcmp(const struct guid *a, const struct guid *b)
{
	return memcmp(a, b, sizeof(struct guid));
}


static char *lechar16_to_ascii(uint16_t *str16)
{
	int i, len = 0;
	uint16_t *pos;
	char *ret;

	pos = str16;
	while (*(pos++))
		len++;

	ret = malloc(len + 1);
	if (!ret) {
		pr_perror("malloc");
		return NULL;
	}

	/* XXX This is NOT how to do utf16le to char * conversion! */
	for (i = 0; i < len; i++) {
		uint16_t p = letoh16(str16[i]);
		if (p > 127)
			ret[i] = '?';
		else
			ret[i] = p;
	}
	ret[i] = 0;
	return ret;
}



static ssize_t robust_read(int fd, void *buf, size_t count, bool short_ok)
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


static ssize_t robust_write(int fd, void *buf, size_t count)
{
	int ret;
	size_t bytes_written = 0;

	while (count) {
		ret = write(fd, buf, count);
		if (ret <= 0 && errno != EINTR) {
			pr_perror("write");
			return -1;
		}
		count -= ret;
		bytes_written += ret;
	}
	return bytes_written;
}

int gpt_flush_ptable(const char *device)
{
    int fd;
    sync();
    fd = open(device, O_RDWR);
    if (fd < 0) {
        pr_perror("open");
        return -errno;
    }
    if (ioctl(fd, BLKFLSBUF, NULL)) {
        pr_perror("BLKFLSBUF");
        close(fd);
        return -errno;
    }
    close(fd);
    return 0;
}

int gpt_sync_ptable(const char *device)
{
	int fd;
	sync();
	fd = open(device, O_RDWR);
	if (fd < 0) {
		pr_perror("open");
		return -errno;
	}
	if (ioctl(fd, BLKRRPART, NULL)) {
		pr_perror("BLKRRPART");
		close(fd);
		return -errno;
	}
	close(fd);
	return 0;
}



char *gpt_guid_to_string(struct guid *g)
{
	char *ret;
	/* data1, data2, data3 printed with MSB first (big-endian).
	 * data4 elements printed literally */
	if (asprintf(&ret, "%08x-%04x-%04x-%02x%02x-%02x%02x%02x%02x%02x%02x",
			g->data1, g->data2, g->data3,
			g->data4[0], g->data4[1], g->data4[2], g->data4[3],
			g->data4[4], g->data4[5], g->data4[6], g->data4[7]) < 0)
		return NULL;
	return ret;
}


int gpt_string_to_guid(struct guid *g, const char *s)
{
	int ret;

	ret = sscanf(s, "%08x-%04hx-%04hx-%02hhx%02hhx-%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx",
			&g->data1, &g->data2, &g->data3,
			&g->data4[0], &g->data4[1], &g->data4[2], &g->data4[3],
			&g->data4[4], &g->data4[5], &g->data4[6], &g->data4[7]);
	return !(ret == 11);
}


/* re-factor gpt_entry_get, use when bounds-checking provided */
struct gpt_entry *gpt_entry_offset(uint32_t entry_index, struct gpt *gpt)
{
	return ((struct gpt_entry *)(gpt->entries + (gpt->header.pentry_size *
				--entry_index)));
}

struct gpt_entry *gpt_entry_get(uint32_t entry_index, struct gpt *gpt)
{
	if (!entry_index || entry_index > gpt->header.num_pentries)
		return NULL;

	return (gpt_entry_offset(entry_index, gpt));
}

uint32_t gpt_next_index(struct gpt *gpt)
{
	uint32_t i;

	for (i = 1; i <= gpt->header.num_pentries; i++) {
		struct gpt_entry *e = gpt_entry_offset(i, gpt);
		if (!e->first_lba)
			return i;
	}
	return 0;
}


char *gpt_get_device_node(unsigned int gpt_index, struct gpt *gpt)
{
	char *ret;
	int rv;
	if (isdigit(gpt->device[strlen(gpt->device) - 1]))
		rv = asprintf(&ret, "%sp%d", gpt->device, gpt_index);
	else
		rv = asprintf(&ret, "%s%d", gpt->device, gpt_index);
	if (rv < 0)
		return NULL;
	else
		return ret;
}


static void gpt_guid_bytes_to_host(struct guid *g)
{
	g->data1 = letoh32(g->data1);
	g->data2 = letoh16(g->data2);
	g->data3 = letoh16(g->data3);
}


static void gpt_guid_bytes_to_le(struct guid *g)
{
	g->data1 = htole32(g->data1);
	g->data2 = htole16(g->data2);
	g->data3 = htole16(g->data3);
}


static void gpt_header_bytes_to_host(struct gpt *gpt)
{
	struct gpt_header *h = &gpt->header;
	h->revision = letoh32(h->revision);
	h->header_size = letoh32(h->header_size);
	h->current_lba = letoh64(h->current_lba);
	h->backup_lba = letoh64(h->backup_lba);
	h->first_usable_lba = letoh64(h->first_usable_lba);
	h->last_usable_lba = letoh64(h->last_usable_lba);
	h->pentry_start_lba = letoh64(h->pentry_start_lba);
	h->num_pentries = letoh32(h->num_pentries);
	h->pentry_size = letoh32(h->pentry_size);
	gpt_guid_bytes_to_host(&h->disk_guid);
}


static void gpt_header_bytes_to_le(struct gpt *gpt)
{
	struct gpt_header *h = &gpt->header;
	h->revision = htole32(h->revision);
	h->header_size = htole32(h->header_size);
	h->current_lba = htole64(h->current_lba);
	h->backup_lba = htole64(h->backup_lba);
	h->first_usable_lba = htole64(h->first_usable_lba);
	h->last_usable_lba = htole64(h->last_usable_lba);
	h->pentry_start_lba = htole64(h->pentry_start_lba);
	h->num_pentries = htole32(h->num_pentries);
	h->pentry_size = htole32(h->pentry_size);
	gpt_guid_bytes_to_le(&h->disk_guid);
}


/* Assumes header has been converted from little endian already */
static void gpt_entries_bytes_to_host(struct gpt *gpt)
{
	uint32_t i;
	struct gpt_entry *e;

	for (i = 0; i < gpt->header.num_pentries; i++) {
		e = (struct gpt_entry *)(gpt->entries + (gpt->header.pentry_size * i));
		e->first_lba = letoh64(e->first_lba);
		e->last_lba = letoh64(e->last_lba);
		e->flags = letoh64(e->flags);
		gpt_guid_bytes_to_host(&e->type_guid);
		gpt_guid_bytes_to_host(&e->part_guid);
	}
}


/* Assumes header has not been converted back to little-endian yet */
static void gpt_entries_bytes_to_le(struct gpt *gpt)
{
	uint32_t i;
	struct gpt_entry *e;

	for (i = 0; i < gpt->header.num_pentries; i++) {
		e = (struct gpt_entry *)(gpt->entries + (gpt->header.pentry_size * i));
		e->first_lba = htole64(e->first_lba);
		e->last_lba = htole64(e->last_lba);
		e->flags = htole64(e->flags);
		gpt_guid_bytes_to_le(&e->type_guid);
		gpt_guid_bytes_to_le(&e->part_guid);
	}
}


static int get_sizes(const char *device, uint32_t *lba_size, uint64_t *num_sectors)
{
	int fd, ret;

	fd = open(device, O_RDONLY);
	if (fd < 0) {
		pr_perror("open %s", device);
		return -1;
	}

	pr_debug("get_sizes %s\n", device);
	ret = ioctl(fd, BLKSSZGET, lba_size);
	if (ret) {
		pr_perror("ioctl BLKSSZGET %s failed", device);
		goto out;
	}
	if (!*lba_size) {
		pr_error("Wrong LBA size %u\n", *lba_size);
		ret = -1;
		goto out;
	}
	ret = ioctl (fd, BLKGETSIZE64, num_sectors);
	if (ret) {
		pr_perror("ioctl BLKGETSIZE64 %s failed", device);
		goto out;
	}

	*num_sectors /= (uint64_t)*lba_size;
out:
	close(fd);
	return ret;
}


struct gpt *gpt_init(const char *device)
{
	struct gpt *gpt;
	uint32_t lba_size;
	uint64_t sectors;

	if (get_sizes(device, &lba_size, &sectors))
		return NULL;

	gpt = malloc(sizeof(*gpt));
	if (!gpt)
		return NULL;
	gpt->device = strdup(device);
	if (!gpt->device) {
		free(gpt);
		return NULL;
	}
	gpt->lba_size = lba_size;
	gpt->sectors = sectors;
	gpt->entries = NULL;

	pr_debug("init  GPT for %s Sectors %" PRIu64 " LBA size %u\n",
		gpt->device, gpt->sectors, gpt->lba_size);
	return gpt;
}


int gpt_new(struct gpt *gpt)
{
	struct gpt_header *h = &gpt->header;
	size_t gpt_sz;

	memset(h, 0, sizeof(struct gpt_header));
	memcpy(h->sig, "EFI PART", 8);
	h->revision = 0x00010000;
	h->header_size = sizeof(struct gpt_header);

	/* All the math assumes that total size of pentries is
	 * some multiple of sector size */
	h->num_pentries = 128;
	h->pentry_size = 128;
	gpt_sz = 1 + (h->num_pentries * h->pentry_size / gpt->lba_size);
	h->first_usable_lba = 1 + gpt_sz;
	h->last_usable_lba = gpt->sectors - (1 + gpt_sz);
	if (generate_uuid(&h->disk_guid))
		return -1;

	free(gpt->entries);
	gpt->entries = calloc(h->num_pentries, h->pentry_size);
	if (!gpt->entries)
		return -1;
	/* checksums, current_lba, backup_lba, pentry_start_lba filled
	 * in when we write to disk */
	return 0;
}


/* Assumes entries are little-endian
 * Assumes header is host format
 * Returned checksum is byte-swapped */
static uint32_t get_entries_crc32(struct gpt *gpt)
{
	uint32_t crc = crc32(0L, Z_NULL, 0);
	crc = crc32(crc, (void *)gpt->entries,
			gpt->header.num_pentries * gpt->header.pentry_size);
	return htole32(crc);
}


/* Assumes header is in le format and has NOT been byte-swapped yet.
 * Returned checksum is byte-swapped */
static uint32_t get_header_crc32(struct gpt *gpt)
{
	uint32_t crc;
	uint32_t old_crc;

	old_crc = gpt->header.crc32;
	gpt->header.crc32 = 0;
	crc = crc32(0L, Z_NULL, 0);
	crc = crc32(crc, (void*)&gpt->header, letoh32(gpt->header.header_size));
	gpt->header.crc32 = old_crc;
	return htole32(crc);
}



struct gpt *gpt_copy(struct gpt *src)
{
	size_t entries_size;
	struct gpt *dest;

	dest = malloc(sizeof(struct gpt));
	if (!dest) {
		pr_perror("malloc");
		return NULL;
	}
	memcpy(dest, src, sizeof(struct gpt));
	dest->device = strdup(src->device);
	if (!dest->device) {
		pr_perror("strdup");
		free(dest);
		return NULL;
	}
	entries_size = src->header.num_pentries * src->header.pentry_size;
	dest->entries = malloc(entries_size);
	if (!dest->entries) {
		pr_perror("malloc");
		free(dest->device);
		free(dest);
		return NULL;
	}
	memcpy(dest->entries, src->entries, entries_size);
	return dest;
}


static int write_gpt_to_disk(struct gpt *gpt)
{
	int fd;
	uint64_t header_offset, entries_offset, entries_size;

	/* Stash some data before we swap back to little-endian */
	entries_size = gpt->header.num_pentries * gpt->header.pentry_size;
	header_offset = gpt->header.current_lba * gpt->lba_size;
	entries_offset = gpt->header.pentry_start_lba * gpt->lba_size;

	/* byteswap and compute checksums */
	gpt_entries_bytes_to_le(gpt);
	gpt->header.pentry_crc32 = get_entries_crc32(gpt);
	gpt_header_bytes_to_le(gpt);
	gpt->header.crc32 = get_header_crc32(gpt);

	fd = open(gpt->device, O_WRONLY);
	if (fd < 0) {
		pr_perror("open");
		return -1;
	}

	if (lseek64(fd, header_offset, SEEK_SET) == -1) {
		pr_perror("lseek64");
		goto out_fd;
	}

	if (robust_write(fd, &gpt->header, sizeof(struct gpt_header)) < 0) {
		pr_error("couldn't write GPT header\n");
		goto out_fd;
	}

	if (lseek64(fd, entries_offset, SEEK_SET) == -1) {
		pr_perror("lseek64\n");
		goto out_fd;
	}

	if (robust_write(fd, gpt->entries, entries_size) < 0) {
		pr_error("Couldn't write GPT entries array\n");
		goto out_fd;
	}

	if (close(fd)) {
		pr_perror("close");
		return -1;
	}

	return 0;
out_fd:
	close(fd);
	return -1;
}


static int write_mbr(const char *device, struct mbr *mbr)
{
	int fd;

	fd = open(device, O_WRONLY);
	if (fd < 0) {
		pr_perror("open");
		return -1;
	}

	if (lseek64(fd, 440, SEEK_SET) == -1) {
		pr_perror("lseek64");
		goto out_fd;
	}

	if (robust_write(fd, mbr, sizeof(struct mbr)) < 0) {
		pr_error("Couldn't write MBR\n");
		goto out_fd;
	}

	if (close(fd)) {
		pr_perror("close");
		return -1;
	}

	return 0;
out_fd:
	close(fd);
	return -1;
}


int gpt_write(struct gpt *gpt)
{
	struct gpt *le_gpt;
	int ret;
	struct mbr mbr;
	uint64_t entries_size;

	entries_size = gpt->header.num_pentries * gpt->header.pentry_size;

	/* Write primary GPT */
	le_gpt = gpt_copy(gpt);
	if (!le_gpt) {
		pr_error("Failed to copy GPT\n");
		return -1;
	}
	le_gpt->header.current_lba = 1;
	le_gpt->header.backup_lba = le_gpt->sectors - 1;
	le_gpt->header.pentry_start_lba = 2;
	ret = write_gpt_to_disk(le_gpt);
	gpt_close(le_gpt);
	if (ret) {
		pr_error("Failed to write primary GPT\n");
		return -1;
	}

	/* Write backup GPT */
	le_gpt = gpt_copy(gpt);
	if (!le_gpt) {
		pr_error("Failed to copy GPT\n");
		return -1;
	}
	le_gpt->header.current_lba = le_gpt->sectors - 1;
	le_gpt->header.backup_lba = 1;
	le_gpt->header.pentry_start_lba = le_gpt->header.current_lba -
		(entries_size / le_gpt->lba_size);
	ret = write_gpt_to_disk(le_gpt);
	gpt_close(le_gpt);
	if (ret) {
		pr_error("Failed to write backup GPT\n");
		return -1;
	}

	/* Write protective MBR */
	memset(&mbr, 0, sizeof(mbr));
	mbr.sig = htole16(0xAA55);
	mbr.entries[0].type = 0xEE;
	mbr.entries[0].first_lba = htole32(1);
	mbr.entries[0].lba_count = htole32(min(gpt->sectors - 1, 0xFFFFFFFFULL));
	if (write_mbr(gpt->device, &mbr)) {
		pr_error("Couldn't write protective MBR\n");
		return -1;
	}
	return 0;
}


static int read_gpt_data(int fd, bool primary, struct gpt *gpt)
{
	uint64_t offset;
	size_t entries_size;
	int ret;

	if (primary)
		offset = 1;
	else
		offset = gpt->sectors - 1;

	pr_debug("Reading %s GPT at LBA offset %" PRIu64 "\n", gpt->device, offset);

	if (lseek64(fd, offset * gpt->lba_size, SEEK_SET) == -1) {
		pr_perror("lseek64");
		return -EIO;
	}

	if (robust_read(fd, &gpt->header, sizeof(struct gpt_header), false) < 0) {
		pr_perror("read");
		return -EIO;
	}

	if (strncmp("EFI PART", gpt->header.sig, 8)) {
		pr_error("GPT header sig invalid\n");
		return -EINVAL;
	}

	if (get_header_crc32(gpt) != gpt->header.crc32) {
		pr_error("GPT header CRC failure\n");
		return -EINVAL;
	}
	gpt_header_bytes_to_host(gpt);

	entries_size = gpt->header.num_pentries * gpt->header.pentry_size;
	gpt->entries = malloc(entries_size);
	if (!gpt->entries) {
		pr_perror("malloc");
		return -errno;
	}

	if (lseek64(fd, gpt->header.pentry_start_lba * gpt->lba_size,
				SEEK_SET) == -1) {
		pr_perror("lseek64");
		ret = -EIO;
		goto out_free;
	}

	if (robust_read(fd, gpt->entries, entries_size, false) < 0) {
		pr_perror("read");
		ret = -EIO;
		goto out_free;
	}

	if (get_entries_crc32(gpt) != gpt->header.pentry_crc32) {
		pr_error("GPT entries CRC failure\n");
		ret = -EINVAL;
		goto out_free;
	}

	gpt_entries_bytes_to_host(gpt);
	return 0;
out_free:
	free(gpt->entries);
	gpt->entries = NULL;
	return ret;
}


/* Read the GPT from the specified device node, filling in the fields
 * in the given struct gpt. Must eventually call gpt_close() on it. */
int gpt_read(struct gpt *gpt)
{
	int fd;
	uint8_t type;
	int ret;

	fd = open(gpt->device, O_RDONLY);
	if (fd < 0) {
		pr_perror("open");
		return -EIO;
	}

	if (lseek(fd, 0x1be + 0x4, SEEK_SET) == -1) {
		pr_perror("lseek");
		ret = -EIO;
		goto out_close;
	}

	if (robust_read(fd, &type, sizeof(type), false) < 0) {
		pr_perror("read");
		ret = -EIO;
		goto out_close;
	}

	if (type != 0xee) {
		/* First partition entry in the MBR isn't the protective
		 * entry. Let's get out of here */
		pr_error("Disk %s doesn't seem to have a protective MBR\n",
				gpt->device);
		ret = -EINVAL;
		goto out_close;
	}

	if (read_gpt_data(fd, true, gpt) < 0) {
		pr_error("Primary GPT corrupted, trying backup\n");
		if (read_gpt_data(fd, false, gpt) < 0) {
			pr_error("Backup GPT also corrupt\n");
			ret = -EINVAL;
			goto out_close;
		}
	}
	ret = 0;
out_close:
	close(fd);

	return ret;
}


void gpt_close(struct gpt *gpt)
{
	free(gpt->device);
	free(gpt->entries);
	free(gpt);
}


char *gpt_dump_pentry(uint32_t index, struct gpt_entry *ent)
{
	char *partguidstr, *typeguidstr, *namebuf, *buf;
	int ret;

	namebuf = gpt_entry_get_name(ent);
	typeguidstr = gpt_guid_to_string(&ent->type_guid);
	partguidstr = gpt_guid_to_string(&ent->part_guid);

	ret = asprintf(&buf, "[%02d] %s %s %12" PRIu64 " %12" PRIu64 " 0x%016" PRIx64 " '%s'\n",
			index, typeguidstr, partguidstr, ent->first_lba,
			ent->last_lba, ent->flags, namebuf);
	free(namebuf);
	free(typeguidstr);
	free(partguidstr);

	if (ret < 0)
		return NULL;
	return buf;
}


char *gpt_dump_pentries(struct gpt *gpt)
{
	uint32_t i;
	int ret;
	struct gpt_entry *e;
	char *buf, *old_buf;

	buf = strdup("----------- GPT ENTRIES -------------\n");
	if (!buf)
		return NULL;
	partition_for_each(gpt, i, e) {
		old_buf = buf;
		char *line = gpt_dump_pentry(i, e);
		if (!line) {
			free(old_buf);
			return NULL;
		}
		ret = asprintf(&buf, "%s%s", old_buf, line);
		free(old_buf);
		free(line);
		if (ret < 0)
			return NULL;
	}
	old_buf = buf;
	ret = asprintf(&buf, "%s-------------------------------------\n",
			old_buf);
	free(old_buf);
	if (ret < 0)
		return NULL;
	return buf;
}


char *gpt_dump_header(struct gpt *gpt)
{
	char *buf;
	int ret;
	char sig[9];
	struct gpt_header *hdr = &gpt->header;
	memcpy(sig, hdr->sig, 8);
	sig[8] = 0;
	char *disk_guid = gpt_guid_to_string(&(hdr->disk_guid));

	ret = asprintf(&buf, "Device %s Sectors %" PRIu64 " LBA size %u\n"
		"------------ GPT HEADER -------------\n"
		"             sig: %s\n"
		"             rev: 0x%08X\n"
		"        hdr_size: %u\n"
		"     current_lba: %" PRIu64 "\n"
		"      backup_lba: %" PRIu64 "\n"
		"first_usable_lba: %" PRIu64 "\n"
		" last_usable_lba: %" PRIu64 "\n"
		"       disk_guid: %s\n"
		"pentry_start_lba: %" PRIu64 "\n"
		"    num_pentries: %u\n"
		"     pentry_size: %u\n"
		"-------------------------------------\n",
		gpt->device, gpt->sectors, gpt->lba_size,
		sig, hdr->revision, hdr->header_size,
		hdr->current_lba, hdr->backup_lba,
		hdr->first_usable_lba, hdr->last_usable_lba,
		disk_guid, hdr->pentry_start_lba,
		hdr->num_pentries, hdr->pentry_size);
	free(disk_guid);
	if (ret < 0)
		return NULL;
	return buf;
}


struct ptn_region {
	uint64_t start;
	uint64_t end;
	uint64_t size;
};


/* Comparison function to qsort() struct ptn_regions */
static int regioncmp(const void *a, const void *b)
{
	const struct ptn_region *pa = a;
	const struct ptn_region *pb = b;
	int64_t d = pa->start - pb->start;
	/* Avoid potential overflow by just returning d */
	if (d < 0)
		return -1;
	if (d > 0)
		return 1;
	return 0;
}


/* Examine an empty region and determine whether its size exceeds the
 * largest that we have already seen.
 * largest - data structure to update
 * base - beginning LBA of the empty region
 * start - starting LBA of the next partitioned area */
static void largest_update(struct ptn_region *largest, uint64_t base,
		uint64_t start)
{
	if (start > base) { /* if not, no gap at all */
		uint64_t size = start - base;
		if (size > largest->size) {
			largest->size = size;
			largest->start = base;
			largest->end = start - 1;
		}
	}
}


/* Return the start and end LBAs of the largest block of unpartitioned
 * space on the disk.
 *
 * returns 0 on success and start_lba, end_lba updated. both values inclusive.
 * returns -1 if there are no free regions at all
 */
int gpt_find_contiguous_free_space(struct gpt *gpt, uint64_t *start_lba,
		uint64_t *end_lba)
{
	uint32_t ptn_count = 0;
	uint32_t i, j;
	uint64_t base;
	struct gpt_entry *e;
	struct ptn_region largest;
	struct ptn_region *regions;

	/* Create an array of all the (start, end) partition entries and sort
	 * it ascending by starting location */
	partition_for_each(gpt, i, e)
		ptn_count++;
	regions = calloc(ptn_count, sizeof(struct ptn_region));
	if (!regions) {
		pr_perror("calloc");
		return -errno;
	}
	j = 0;
	partition_for_each(gpt, i, e) {
		regions[j].start = e->first_lba;
		regions[j].end = e->last_lba;
		j++;
	}
	qsort(regions, ptn_count, sizeof(struct ptn_region), regioncmp);

	/* Check for gaps, calculate their size, and update largest if
	 * bigger than already seen */
	base = gpt->header.first_usable_lba;
	largest.size = 0;
	largest.end = 0;
	largest.start = 0;
	for (i = 0; i < ptn_count; i++) {
		largest_update(&largest, base, regions[i].start);
		base = regions[i].end + 1;
	}
	free(regions);

	/* Check space after last partition */
	largest_update(&largest, base, gpt->header.last_usable_lba + 1);

	if (largest.size == 0)
		return -1;
	*start_lba = largest.start;
	*end_lba = largest.end;
	pr_debug("gpt_find_contiguous_free_space: LBA %" PRIu64 " --> %" PRIu64 " (inclusive)\n",
			largest.start, largest.end);
	return 0;
}


char *gpt_entry_get_name(struct gpt_entry *e)
{
	return lechar16_to_ascii(e->name);
}


uint64_t gpt_entry_get_size(struct gpt *gpt, struct gpt_entry *e)
{
	return ((e->last_lba + 1) - e->first_lba) * gpt->lba_size;
}


uint32_t gpt_entry_create(struct gpt *gpt, char *name, enum part_type type,
		uint64_t flags, uint64_t first_lba, uint64_t last_lba)
{
	uint32_t i;
	struct gpt_entry *e;

	i = gpt_next_index(gpt);
	e = gpt_entry_get(i, gpt);
	if (!e)
		return 0;

	e->flags = flags;

	/* TODO check disk bounds and intersection with other ptns */
	e->first_lba = first_lba;
	e->last_lba = last_lba;
	if (gpt_entry_set_name(e, name)) {
		pr_error("Couldn't set partition name to '%s'\n", name);
		return 0;
	}
	gpt_entry_set_type(e, type);
	if (generate_uuid(&e->part_guid)) {
		pr_error("Couldn't generate partition GUID\n");
		return 0;
	}
	return i;
}


int gpt_entry_delete(struct gpt *gpt, uint32_t index)
{
	struct gpt_entry *e;
	e = gpt_entry_get(index, gpt);
	if (!e)
		return -1;
	memset(e, 0, sizeof(struct gpt_entry));
	return 0;
}


int gpt_entry_set_name(struct gpt_entry *e, char *name)
{
	uint32_t i;
	size_t len;

	len = strlen(name);
	if (len > 35) {
		pr_error("Name '%s' is too long\n", name);
		return -1;
	}

	for (i = 0; i < len; i++) {
		uint16_t p = (uint16_t)name[i];
		e->name[i] = htole16(p);
	}
	e->name[i] = 0;
	return 0;
}


void gpt_entry_set_type(struct gpt_entry *e, enum part_type type)
{
	memcpy(&e->type_guid, get_guid_type(type), sizeof(struct guid));
}

/* vim: cindent:noexpandtab:softtabstop=8:shiftwidth=8:noshiftround
 */

