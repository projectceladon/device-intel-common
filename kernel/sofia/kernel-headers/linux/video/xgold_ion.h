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
#ifndef _LINUX_XGOLD_ION_H
#define _LINUX_XGOLD_ION_H
#include <linux/ion.h>
#include <linux/compat.h>
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct xgold_ion_get_params_data {
  int handle;
  size_t size;
  unsigned long addr;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
enum {
  XGOLD_ION_GET_PARAM = 0,
  XGOLD_ION_ALLOC_SECURE,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  XGOLD_ION_FREE_SECURE,
};
enum {
  XGOLD_ION_HEAP_ID_SYSTEM,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  XGOLD_ION_HEAP_ID_SYSTEM_CONTIG,
  XGOLD_ION_HEAP_ID_CARVEOUT,
  XGOLD_ION_HEAP_ID_CHUNK,
  XGOLD_ION_HEAP_ID_CMA,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  XGOLD_ION_HEAP_ID_VIDEO,
  XGOLD_ION_HEAP_ID_PROTECTED,
};
#define XGOLD_ION_HEAP_ID_SYSTEM_MASK (1 << XGOLD_ION_HEAP_ID_SYSTEM)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define XGOLD_ION_HEAP_ID_CARVEOUT_MASK (1 << XGOLD_ION_HEAP_ID_CARVEOUT)
#define XGOLD_ION_HEAP_ID_CMA_MASK (1 << XGOLD_ION_HEAP_ID_CMA)
#define XGOLD_ION_HEAP_ID_VIDEO_MASK (1 << XGOLD_ION_HEAP_ID_VIDEO)
#define XGOLD_ION_HEAP_ID_PROTECTED_MASK (1 << XGOLD_ION_HEAP_ID_PROTECTED)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
enum {
  ION_HEAP_TYPE_SECURE = XGOLD_ION_HEAP_ID_VIDEO,
};
struct ion_flush_data {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  ion_user_handle_t handle;
  int fd;
  void * vaddr;
  unsigned int offset;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  unsigned int length;
};
struct ion_phys_data {
  ion_user_handle_t handle;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  unsigned long phys;
  unsigned long size;
};
struct ion_share_id_data {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  int fd;
  unsigned int id;
};
#define ION_HEAP_TYPE_SECURE_MASK (1 << ION_HEAP_TYPE_SECURE)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ION_IOC_SOFIA_MAGIC 'R'
#define ION_IOC_CLEAN_CACHES _IOWR(ION_IOC_SOFIA_MAGIC, 0, struct ion_flush_data)
#define ION_IOC_INV_CACHES _IOWR(ION_IOC_SOFIA_MAGIC, 1, struct ion_flush_data)
#define ION_IOC_CLEAN_INV_CACHES _IOWR(ION_IOC_SOFIA_MAGIC, 2, struct ion_flush_data)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ION_IOC_GET_PHYS _IOWR(ION_IOC_SOFIA_MAGIC, 3, struct ion_phys_data)
#define ION_IOC_GET_SHARE_ID _IOWR(ION_IOC_SOFIA_MAGIC, 4, struct ion_share_id_data)
#define ION_IOC_SHARE_BY_ID _IOWR(ION_IOC_SOFIA_MAGIC, 5, struct ion_share_id_data)
#endif
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
