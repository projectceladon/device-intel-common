/*
 * Copyright (C) 2012 The Android Open Source Project
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


#ifndef ANDROID_GPT_H
#define ANDROID_GPT_H

#include <stdint.h>

struct guid {
	uint32_t data1;
	uint16_t data2;
	uint16_t data3;
	uint8_t data4[8]; /* Does not get byte-swapped */
} __attribute__((__packed__));

#define getbyte(x, s)		(((x) >> (8 * (s))) & 0xFF)

/* All fields including GUIDs converted back to little-endian when
 * written to the disk */
#define GPT_GUID(a, b, c, d1, d2) \
	((struct guid) \
	 { a, b, c, \
	    { getbyte(d1, 1), getbyte(d1, 0), getbyte(d2, 5), getbyte(d2, 4), \
	       getbyte(d2, 3), getbyte(d2, 2), getbyte(d2, 1), getbyte(d2, 0) } } )

#define partition_for_each(gpt, i, e) \
	for ((i) = 1, (e) = gpt_entry_offset((i), (gpt)); \
			i <= (gpt)->header.num_pentries; \
			e = gpt_entry_offset(++(i), (gpt))) if (!(e)->first_lba) continue; else

/* When written to disk all fields in GPT and entries must be little-endian.
 * Conversion to and from host ordering done in gpt_read/gpt_write functions,
 * don't do any conversion yourself */
struct gpt_header {
	char sig[8];
	uint32_t revision;
	uint32_t header_size;
	uint32_t crc32;
	uint32_t reserved_zero;
	uint64_t current_lba;
	uint64_t backup_lba;
	uint64_t first_usable_lba;
	uint64_t last_usable_lba;
	struct guid disk_guid;
	uint64_t pentry_start_lba;
	uint32_t num_pentries;
	uint32_t pentry_size;
	uint32_t pentry_crc32;
} __attribute__((__packed__));

#define GPT_FLAG_SYSTEM		(1ULL << 0)
#define GPT_FLAG_BOOTABLE	(1ULL << 2)
#define GPT_FLAG_READONLY	(1ULL << 60)
#define GPT_FLAG_HIDDEN		(1ULL << 62)
#define GPT_FLAG_NO_AUTOMOUNT	(1ULL << 63)

struct gpt_entry {
	struct guid type_guid;
	struct guid part_guid;
	uint64_t first_lba;
	uint64_t last_lba;
	uint64_t flags;
	uint16_t name[36]; /* UTF-16LE, not converted.
			    * use gpt_entry_{get|set}_name() */
} __attribute__((__packed__));

struct gpt {
	struct gpt_header header;
	unsigned char *entries;
	uint32_t lba_size;
	uint64_t sectors;
	char *device;
};

/*flush gpt via BLKFLSBUF ioctl*/
int gpt_flush_ptable(const char *device);

/* Tell linux to re-load the partition table for the specified
 * disk block device via BLKRRPART ioctl */
int gpt_sync_ptable(const char *device);

/* Return a string representation of a GUID. Must be freed */
char *gpt_guid_to_string(struct guid *g);

/* Populate a GUID based on some string value. Return -1 on failure */
int gpt_string_to_guid(struct guid *g, const char *s);

/* Return the first index in the partition table that doesn't have an
 * actual partition entry. */
uint32_t gpt_next_index(struct gpt *gpt);

/* Compare two GUIDs for equality */
int guidcmp(const struct guid *a, const struct guid *b);

/* Return the /dev device node for the partition as an allocated string.
 * Return NULL on allocation errors */
char *gpt_get_device_node(uint32_t gpt_index, struct gpt *gpt);

/* Create a struct gpt for a particular device. You would either want
 * to read it from the disk with gpt_read() or initialize an empty one
 * with gpt_new() */
struct gpt* gpt_init(const char *device);

/* Populate the GPT structure with an empty partition table */
int gpt_new(struct gpt *gpt);

/* Read the GPT from the disk */
int gpt_read(struct gpt *gpt);

/* Write the GPT back to the disk */
int gpt_write(struct gpt *gpt);

/* Free heap memory associated with a struct gpt */
void gpt_close(struct gpt *gpt);

/* Make a copy of a GPT structure */
struct gpt *gpt_copy(struct gpt *src);

/* Debug functins, returns a string which must be freed */
char *gpt_dump_pentry(uint32_t index, struct gpt_entry *ent);
char *gpt_dump_pentries(struct gpt *gpt);
char *gpt_dump_header(struct gpt *gpt);

/* Find the largest block of unallocated space in the disk.
 * Populates start_lba and end_lba paramaters. Returns -1
 * if there is no free space */
int gpt_find_contiguous_free_space(struct gpt *gpt, uint64_t *start_lba,
		uint64_t *end_lba);

enum part_type {
	PART_LINUX,
	PART_ANDROID_BOOT,
	PART_ANDROID_RECOVERY,
	PART_ANDROID_TERTIARY,
	PART_ANDROID_MISC,
	PART_ANDROID_METADATA,
	PART_MS_DATA,
	PART_MS_RESERVED,
	PART_ESP,
	PART_LINUX_SWAP
};

/* Fetch a struct guid associated with a particular type. Do not
 * modify or free it */
const struct guid *get_guid_type(enum part_type t);

/* Returns the index of the new partition. last_lba is inclusive! */
uint32_t gpt_entry_create(struct gpt *gpt, char *name, enum part_type type,
		uint64_t flags, uint64_t first_lba, uint64_t last_lba);

/* Zero out a particular index in the entry table */
int gpt_entry_delete(struct gpt *gpt, uint32_t index);

/* gpt_entry Mutators */
void gpt_entry_set_type(struct gpt_entry *e, enum part_type type);

/* Needed as internally is stored as UTF-16le */
int gpt_entry_set_name(struct gpt_entry *e, char *name);

/* Indexes start at 1, to correspond with the disk minor number */
struct gpt_entry *gpt_entry_get(uint32_t entry_index, struct gpt *gpt);

/* Same as gpt_entry_get, used inside a loop with bounds-checking */
struct gpt_entry *gpt_entry_offset(uint32_t entry_index, struct gpt *gpt);

/* Returned string must be freed */
char *gpt_entry_get_name(struct gpt_entry *e);

/* Returns size in bytes */
uint64_t gpt_entry_get_size(struct gpt *gpt, struct gpt_entry *e);


#endif

