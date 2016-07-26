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
#ifndef _UAPI_V4L2_CONTROLS_INTEL_CIF_ISP_H
#define _UAPI_V4L2_CONTROLS_INTEL_CIF_ISP_H
#include <linux/videodev2.h>
struct cifisp_ext_control {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t id;
  uint32_t value;
};
struct cifisp_ext_controls {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t ctrl_class;
  uint32_t count;
  struct cifisp_ext_control * controls;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_delayed_sensor_ctrls {
  uint16_t delay;
  struct cifisp_ext_controls ext_ctrl;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_frame_config {
  uint32_t id;
  uint8_t dma;
  uint32_t sensor_ctrls_count;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct cifisp_delayed_sensor_ctrls __user * sensor_ctrls;
  struct cifisp_bpc_config __user * bpc;
  struct cifisp_bls_config __user * bls;
  struct cifisp_sdg_config __user * sdg;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct cifisp_lsc_config __user * lsc;
  struct cifisp_awb_meas_config __user * awb_meas;
  struct cifisp_flt_config __user * flt;
  struct cifisp_ctk_config __user * ctk;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct cifisp_goc_config __user * gcc;
  struct cifisp_hist_config __user * hist;
  struct cifisp_aem_config __user * aem;
  struct cifisp_awb_gain_config __user * awb_gain;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct cifisp_cproc_config __user * cproc;
  struct cifisp_macc_config __user * macc;
  struct cifisp_tmap_config __user * tmap;
  struct cifisp_ycflt_config __user * ycflt;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct cifisp_afm_config __user * afm;
  struct cifisp_ie_config __user * ie;
  struct cifisp_bnr_config __user * bnr;
  struct cifisp_crop_config __user * crop;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct intel_v4l2_buffer {
  uint32_t id;
  uint32_t index;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t length;
  uint32_t memory;
  union {
    void * userptr;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
    int32_t fd;
  };
};
#define INTEL_VIDIOC_QBUF _IOW('v', BASE_VIDIOC_PRIVATE, struct intel_v4l2_buffer)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define INTEL_VIDIOC_FRAME_CONF _IOWR('v', BASE_VIDIOC_PRIVATE + 1, struct cifisp_frame_config)
#define INTEL_VIDIOC_CIF_ISP3_UAPI_LAST (BASE_VIDIOC_PRIVATE + 10)
#endif
