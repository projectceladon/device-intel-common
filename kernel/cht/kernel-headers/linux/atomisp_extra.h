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
#ifndef ATOMISP_EXTRA_H_
#define ATOMISP_EXTRA_H_
enum atomisp_camera_port {
 ATOMISP_CAMERA_PORT_SECONDARY,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 ATOMISP_CAMERA_PORT_PRIMARY,
 ATOMISP_CAMERA_PORT_TERTIARY,
 ATOMISP_CAMERA_NR_PORTS
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#ifdef CSS15
struct atomisp_sensor_mode_data {
 unsigned int coarse_integration_time_min;
 unsigned int coarse_integration_time_max_margin;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int fine_integration_time_min;
 unsigned int fine_integration_time_max_margin;
 unsigned int fine_integration_time_def;
 unsigned int frame_length_lines;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int line_length_pck;
 unsigned int read_mode;
 unsigned int vt_pix_clk_freq_mhz;
 unsigned int crop_horizontal_start;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int crop_vertical_start;
 unsigned int crop_horizontal_end;
 unsigned int crop_vertical_end;
 unsigned int output_width;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int output_height;
 uint8_t binning_factor_x;
 uint8_t binning_factor_y;
 uint8_t reserved[2];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
#else
struct atomisp_sensor_mode_data {
 unsigned int coarse_integration_time_min;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int coarse_integration_time_max_margin;
 unsigned int fine_integration_time_min;
 unsigned int fine_integration_time_max_margin;
 unsigned int fine_integration_time_def;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int frame_length_lines;
 unsigned int line_length_pck;
 unsigned int read_mode;
 unsigned int vt_pix_clk_freq_mhz;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int crop_horizontal_start;
 unsigned int crop_vertical_start;
 unsigned int crop_horizontal_end;
 unsigned int crop_vertical_end;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int output_width;
 unsigned int output_height;
 uint8_t binning_factor_x;
 uint8_t binning_factor_y;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 uint16_t hts;
};
#endif
#endif
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
