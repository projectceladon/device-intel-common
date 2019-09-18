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
#ifndef UAPI_LINUX_INTEL_IPU4_ISYS_H
#define UAPI_LINUX_INTEL_IPU4_ISYS_H
#define V4L2_CID_INTEL_IPU4_BASE (V4L2_CID_USER_BASE + 0x1080)
#define V4L2_CID_INTEL_IPU4_ISA_EN (V4L2_CID_INTEL_IPU4_BASE + 1)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_INTEL_IPU4_ISA_EN_BLC (1 << 0)
#define V4L2_INTEL_IPU4_ISA_EN_LSC (1 << 1)
#define V4L2_INTEL_IPU4_ISA_EN_DPC (1 << 2)
#define V4L2_INTEL_IPU4_ISA_EN_SCALER (1 << 3)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_INTEL_IPU4_ISA_EN_AWB (1 << 4)
#define V4L2_INTEL_IPU4_ISA_EN_AF (1 << 5)
#define V4L2_INTEL_IPU4_ISA_EN_AE (1 << 6)
#define NR_OF_INTEL_IPU4_ISA_CFG 7
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct intel_ipu4_isys_isa_cfg {
  uint32_t type;
  uint32_t size;
  uint32_t reserved[6];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
#define V4L2_FMT_INTEL_IPU4_ISA_CFG v4l2_fourcc('i', 'p', '4', 'c')
#define V4L2_FMT_INTEL_IPU4_ISA_3A v4l2_fourcc('i', 'p', '4', 's')
#endif
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */

