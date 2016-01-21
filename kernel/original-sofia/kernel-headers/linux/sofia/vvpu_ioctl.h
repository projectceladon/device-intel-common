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
#ifndef _VVPU_IOCTL_H_
#define _VVPU_IOCTL_H_
#include <linux/types.h>
#include <linux/ioctl.h>
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define VVPU_SECVM_CMD_LEN 128
struct vvpu_secvm_cmd {
 uint32_t payload[VVPU_SECVM_CMD_LEN];
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct pphwc_cmd {
 int release_fence_fd;
 uint32_t sync_value;
 uint64_t instance;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
#define VVPU_IOC_MAGIC 'v'
#define VVPU_IOCT_SECVM_CMD _IOWR(VVPU_IOC_MAGIC, 1,   struct vvpu_secvm_cmd)
#define VVPU_IOCT_PPHWC_START _IOWR(VVPU_IOC_MAGIC, 2,   struct pphwc_cmd)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define VVPU_IOCT_PPHWC_DONE _IOWR(VVPU_IOC_MAGIC, 3,   struct pphwc_cmd)
#define VVPU_IOCT_PPHWC_RELEASE _IOWR(VVPU_IOC_MAGIC, 4,   struct pphwc_cmd)
#define VVPU_IOC_MAXNR 4
enum vvpu_unit_id_t {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 vvpu_unit_g1 = 0x01000000,
 vvpu_unit_h1 = 0x02000000,
 vvpu_unit_nonso = 0x03000000,
 vvpu_unit_g2 = 0x04000000,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 vvpu_unit_h2 = 0x05000000,
 vvpu_unit_mask = 0xff000000,
};
#define MK_VVPU_TYPE(id, type) (id | type)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define VVPU_VTYPE_INIT_HANDSHAKE MK_VVPU_TYPE(vvpu_unit_g1, 0x1000)
#define VVPU_VOP_INIT_HANDSHAKE 0x1000
#define VVPU_CNF_INIT_HANDSHAKE 0xFAB00000
#define VVPU_VTYPE_DEC MK_VVPU_TYPE(vvpu_unit_g1, 0x1001)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define VVPU_VTYPE_ENC MK_VVPU_TYPE(vvpu_unit_h1, 0x1002)
#define VVPU_VTYPE_NONSO MK_VVPU_TYPE(vvpu_unit_nonso, 0x1003)
#define VVPU_VOP_INIT_PROBE 0x2000
#define VVPU_VTYPE_MEM MK_VVPU_TYPE(vvpu_unit_nonso, 0x3000)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define VVPU_VOP_MEM_ALLOC 37
#define VVPU_VOP_MEM_FREE 38
#endif
