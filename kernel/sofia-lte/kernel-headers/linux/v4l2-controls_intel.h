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
#ifndef _V4L2_CONTROLS_INTEL_H
#define _V4L2_CONTROLS_INTEL_H
#include <linux/videodev2.h>
struct isp_supplemental_sensor_mode_data {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int coarse_integration_time_min;
 unsigned int coarse_integration_time_max_margin;
 unsigned int fine_integration_time_min;
 unsigned int fine_integration_time_max_margin;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int frame_length_lines;
 unsigned int line_length_pck;
 unsigned int vt_pix_clk_freq_hz;
 unsigned int crop_horizontal_start;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int crop_vertical_start;
 unsigned int crop_horizontal_end;
 unsigned int crop_vertical_end;
 unsigned int sensor_output_width;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int sensor_output_height;
 unsigned int isp_input_horizontal_start;
 unsigned int isp_input_vertical_start;
 unsigned int isp_input_width;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int isp_input_height;
 unsigned char binning_factor_x;
 unsigned char binning_factor_y;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct isp_supplemental_sensor_otp_data {
 unsigned int size;
 void __user *data;
 unsigned int reserved[2];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
#define V4L2_CID_USER_INTEL_BASE (V4L2_CID_USER_BASE + 0x1090)
#define INTEL_VIDIOC_SENSOR_MODE_DATA  _IOR('v', BASE_VIDIOC_PRIVATE, struct isp_supplemental_sensor_mode_data)
#define INTEL_VIDIOC_G_SENSOR_OTP  _IOWR('v', BASE_VIDIOC_PRIVATE+1, struct isp_supplemental_sensor_otp_data)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define INTEL_V4L2_CID_AUTO_FPS (V4L2_CID_USER_INTEL_BASE+0)
#define INTEL_V4L2_CID_VBLANKING (V4L2_CID_USER_INTEL_BASE+1)
#endif
