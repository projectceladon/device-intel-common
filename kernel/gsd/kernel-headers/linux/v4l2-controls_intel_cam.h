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
#ifndef _UAPI_V4L2_CONTROLS_INTEL_CAM_H
#define _UAPI_V4L2_CONTROLS_INTEL_CAM_H
#include <linux/videodev2.h>
struct isp_supplemental_sensor_mode_data {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t coarse_integration_time_min;
  uint32_t coarse_integration_time_max_margin;
  uint32_t fine_integration_time_min;
  uint32_t fine_integration_time_max_margin;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t frame_length_lines;
  uint32_t line_length_pck;
  uint32_t vt_pix_clk_freq_hz;
  uint32_t crop_horizontal_start;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t crop_vertical_start;
  uint32_t crop_horizontal_end;
  uint32_t crop_vertical_end;
  uint32_t sensor_output_width;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t sensor_output_height;
  uint8_t binning_factor_x;
  uint8_t binning_factor_y;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#ifdef FIXME_SENSOR_OTP
struct isp_supplemental_sensor_otp_data {
  uint32_t size;
  void __user * data;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t reserved[2];
};
#endif
enum intel_subdev_state {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  INTEL_SUBDEV_STATE_OFF = 0,
  INTEL_SUBDEV_STATE_STNDBY = 1,
  INTEL_SUBDEV_STATE_STREAMING = 2
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_CID_USER_INTEL_CAM_BASE (V4L2_CID_USER_BASE + 0x1090)
#define INTEL_VIDIOC_SENSOR_MODE_DATA _IOR('v', BASE_VIDIOC_PRIVATE, struct isp_supplemental_sensor_mode_data)
#define INTEL_VIDIOC_SUBDEV_S_STATE _IOW('v', BASE_VIDIOC_PRIVATE + 1, uint32_t)
#ifdef FIXME_SENSOR_OTP
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define INTEL_VIDIOC_G_SENSOR_OTP _IOWR('v', BASE_VIDIOC_PRIVATE + 2, struct isp_supplemental_sensor_otp_data)
#endif
#define INTEL_VIDIOC_CAM_UAPI_LAST (BASE_VIDIOC_PRIVATE + 10)
#define INTEL_V4L2_CID_AUTO_FPS (V4L2_CID_USER_INTEL_CAM_BASE)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define INTEL_V4L2_CID_TESTMODE (V4L2_CID_USER_INTEL_CAM_BASE + 1)
#endif
