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
 ION_HEAP_TYPE_SECURE = ION_HEAP_TYPE_CUSTOM,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ion_flush_data {
 ion_user_handle_t handle;
 int fd;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 void *vaddr;
 unsigned int offset;
 unsigned int length;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct ion_phys_data {
 ion_user_handle_t handle;
 unsigned long phys;
 unsigned long size;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ion_share_id_data {
 int fd;
 unsigned int id;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
#define ION_HEAP_TYPE_SECURE_MASK (1 << ION_HEAP_TYPE_SECURE)
#define ION_IOC_SOFIA_MAGIC 'R'
#define ION_IOC_CLEAN_CACHES _IOWR(ION_IOC_SOFIA_MAGIC, 0,   struct ion_flush_data)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ION_IOC_INV_CACHES _IOWR(ION_IOC_SOFIA_MAGIC, 1,   struct ion_flush_data)
#define ION_IOC_CLEAN_INV_CACHES _IOWR(ION_IOC_SOFIA_MAGIC, 2,   struct ion_flush_data)
#define ION_IOC_GET_PHYS _IOWR(ION_IOC_SOFIA_MAGIC, 3,   struct ion_phys_data)
#define ION_IOC_GET_SHARE_ID _IOWR(ION_IOC_SOFIA_MAGIC, 4,   struct ion_share_id_data)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ION_IOC_SHARE_BY_ID _IOWR(ION_IOC_SOFIA_MAGIC, 5,   struct ion_share_id_data)
#endif
