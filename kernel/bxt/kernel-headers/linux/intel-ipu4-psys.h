/****************************************************************************
 ****************************************************************************
 ***
 ***   This header was automatically generated from a Linux kernel header
 ***   of the same name, to make information necessary for userspace to
 ***   call into the kernel available to libc.  It contains only constants,
 ***   structures, and macros generated from the original header, and thus,
 ***   contains no copyrightable information.
 ***
 ***   To edit the content of this header, modify the corresponding
 ***   source file (e.g. under external/kernel-headers/original/) then
 ***   run bionic/libc/kernel/tools/update_all.py
 ***
 ***   Any manual change here will be lost the next time this script will
 ***   be run. You've been warned!
 ***
 ****************************************************************************
 ****************************************************************************/
#ifndef _UAPI_INTEL_IPU4_PSYS_H
#define _UAPI_INTEL_IPU4_PSYS_H
#include <linux/types.h>
struct intel_ipu4_psys_capability {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t version;
  uint8_t driver[20];
  uint32_t pg_count;
  uint8_t dev_model[32];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t reserved[17];
} __attribute__((packed));
struct intel_ipu4_psys_event {
  uint32_t type;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t id;
  uint64_t issue_id;
  uint32_t buffer_idx;
  uint32_t error;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  int32_t reserved[2];
} __attribute__((packed));
#define INTEL_IPU4_PSYS_EVENT_TYPE_CMD_COMPLETE 1
#define INTEL_IPU4_PSYS_EVENT_TYPE_BUFFER_COMPLETE 2
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct intel_ipu4_psys_dma_buf {
  int fd;
  uint32_t data_offset;
  uint32_t bytes_used;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t flags;
  uint32_t reserved;
} __attribute__((packed));
struct intel_ipu4_psys_buffer {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint64_t len;
  void __user * userptr;
  int fd;
  uint32_t flags;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t reserved[2];
} __attribute__((packed));
#define INTEL_IPU4_BUFFER_FLAG_INPUT (1 << 0)
#define INTEL_IPU4_BUFFER_FLAG_OUTPUT (1 << 1)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define INTEL_IPU4_BUFFER_FLAG_MAPPED (1 << 2)
#define INTEL_IPU4_BUFFER_FLAG_NO_FLUSH (1 << 3)
#define INTEL_IPU4_PSYS_CMD_PRIORITY_HIGH 0
#define INTEL_IPU4_PSYS_CMD_PRIORITY_MED 1
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define INTEL_IPU4_PSYS_CMD_PRIORITY_LOW 2
#define INTEL_IPU4_PSYS_CMD_PRIORITY_NUM 3
struct intel_ipu4_psys_command {
  uint64_t issue_id;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t id;
  uint32_t priority;
  void __user * pg_manifest;
  struct intel_ipu4_psys_dma_buf __user * buffers;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  int pg;
  uint32_t pg_manifest_size;
  uint32_t bufcount;
  uint32_t min_psys_freq;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t reserved[2];
} __attribute__((packed));
struct intel_ipu4_psys_manifest {
  uint32_t index;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t size;
  void __user * manifest;
  uint32_t reserved[5];
} __attribute__((packed));
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define INTEL_IPU4_IOC_QUERYCAP _IOR('A', 1, struct intel_ipu4_psys_capability)
#define INTEL_IPU4_IOC_MAPBUF _IOWR('A', 2, int)
#define INTEL_IPU4_IOC_UNMAPBUF _IOWR('A', 3, int)
#define INTEL_IPU4_IOC_GETBUF _IOWR('A', 4, struct intel_ipu4_psys_buffer)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define INTEL_IPU4_IOC_PUTBUF _IOWR('A', 5, struct intel_ipu4_psys_buffer)
#define INTEL_IPU4_IOC_QCMD _IOWR('A', 6, struct intel_ipu4_psys_command)
#define INTEL_IPU4_IOC_DQEVENT _IOWR('A', 7, struct intel_ipu4_psys_event)
#define INTEL_IPU4_IOC_CMD_CANCEL _IOWR('A', 8, struct intel_ipu4_psys_command)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define INTEL_IPU4_IOC_GET_MANIFEST _IOWR('A', 9, struct intel_ipu4_psys_manifest)
#endif
