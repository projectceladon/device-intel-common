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
#ifndef _CAM_IPC_TYPES_H_
#define _CAM_IPC_TYPES_H_
#define IPC_EVENT_TIMEOUT 1000
#define FRAME_SIZE_720P (96 * 1024)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define LVR_FRAME_RATE 30
#define LVR_LENGTH 20
#define AOH_FD_IMAGE_BUFFER_OFFSET 0
#define AOH_FD_IMAGE_BUFFER_LENGTH (400 * 300)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define AOH_LVR_IMAGE_BUFFER_OFFSET 0x100000
#define AOH_LVR_IMAGE_BUFFER_LENGTH (FRAME_SIZE_720P * LVR_FRAME_RATE * LVR_LENGTH)
enum cmd_id {
  CAM_IPC_CMD_ACK = 0,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  CAM_IPC_CMD_GET_STATUS = 1,
  CAM_IPC_CMD_SUSPEND = 2,
  CAM_IPC_CMD_RESUME = 3,
  CAM_IPC_CMD_CONFIG_DPHY = 4,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  CAM_IPC_CMD_GET_METERING_DATA = 5,
  CAM_IPC_CMD_PUT_METERING_DATA = 6,
  CAM_IPC_CMD_PUT_FD_IMAGE = 7,
  CAM_IPC_CMD_FD_FREQ_UPDATE = 8,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  CAM_IPC_CMD_START_LVR = 9,
  CAM_IPC_CMD_STOP_LVR = 10,
  CAM_IPC_CMD_I2C_READ = 11,
  CAM_IPC_CMD_I2C_WRITE = 12,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  CAM_IPC_CMD_GET_SENSOR_CFG = 13,
  CAM_IPC_CMD_SENSOR_POWER_CTRL = 14,
};
enum cmd_status {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  CS_SUCCESS = 0,
  CS_TIMEOUT,
  CS_ERROR_UNKNOWN,
  CS_ERROR_MEM,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  CS_ERROR_PARAM,
  CS_ERROR_STATE,
};
struct aoh_cam_status {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t lvr_active : 1;
  uint8_t fd_active : 1;
  uint8_t mtring_active : 1;
  uint8_t lpisp0_active : 1;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t lpisp1_active : 1;
  uint8_t sensor0_inuse : 1;
  uint8_t sensor1_inuse : 1;
  uint8_t reserved : 1;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cmd_suspend_responses_msg {
  uint8_t fd_freq;
  uint8_t mtring_freq;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cmd_msg_suspend {
  uint64_t truncate_timestamp;
  uint32_t sensor_status;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct cmd_suspend_responses_msg suspend_responses;
} __packed;
struct cmd_msg_config_dphy {
  uint32_t csi_port_id;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t csi_lane_number;
  uint32_t mipi_freq;
};
struct cmd_get_mtring_data_responses_msg {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t accurate_r_per_g;
  uint32_t accurate_b_per_g;
  uint32_t final_r_per_g;
  uint32_t final_b_per_g;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t cct_estimate;
  uint32_t distance_from_convergence;
  uint32_t exposure_time_us;
  uint32_t iso;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cmd_msg_put_mtring_data {
  uint32_t ts_sec;
  uint32_t ts_nsec;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t lux_level;
} __packed;
struct cmd_msg_put_fd_image {
  uint32_t ts_sec;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t ts_nsec;
  uint32_t buffer_addr;
} __packed;
struct cmd_msg_start_lvr {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t buffer_addr;
  uint32_t buffer_size;
};
struct cmd_stop_lvr_responses_msg {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t head_offset;
  uint32_t tail_offset;
  uint32_t num_frames;
  uint64_t truncate_time;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
} __packed;
struct cmd_i2c_msg {
  uint32_t reg_addr;
  uint32_t reg_val;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cmd_get_sensor_cfg_responses_msg {
  uint16_t coarse_integration_time_min;
  uint16_t coarse_integration_time_max_margin;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t fine_integration_time_min;
  uint16_t fine_integration_time_max_margin;
  uint16_t fine_integration_time_def;
  uint16_t frame_length_lines;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t line_length_pck;
  uint32_t vt_pix_clk_freq_hz;
  uint16_t crop_horizontal_start;
  uint16_t crop_vertical_start;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t crop_horizontal_end;
  uint16_t crop_vertical_end;
  uint16_t output_width;
  uint16_t output_height;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t binning_factor;
  uint8_t sensor_format;
  uint8_t bit_depth;
  uint8_t csi_input_port;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t horizontal_scaling_numerator;
  uint16_t horizontal_scaling_denominator;
  uint16_t vertical_scaling_numerator;
  uint16_t vertical_scaling_denominator;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t isp_input_horizontal_start;
  uint16_t isp_input_vertical_start;
  uint16_t isp_input_width;
  uint16_t isp_input_height;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
#define CAM_IPC_IOCTL 0xfe
#define CAM_IPC_IOC_GET_STATUS _IOR(CAM_IPC_IOCTL, 1, struct aoh_cam_status)
#define CAM_IPC_IOC_SUSPEND _IOR(CAM_IPC_IOCTL, 2, struct cmd_msg_suspend)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define CAM_IPC_IOC_RESUME _IO(CAM_IPC_IOCTL, 3)
#define CAM_IPC_IOC_CONFIG_DPHY _IOWR(CAM_IPC_IOCTL, 4, struct cmd_msg_config_dphy)
#define CAM_IPC_IOC_GET_METERING_DATA _IOR(CAM_IPC_IOCTL, 5, struct cmd_msg_put_mtring_data)
#define CAM_IPC_IOC_PUT_METERING_DATA _IOW(CAM_IPC_IOCTL, 6, struct cmd_msg_put_fd_image)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define CAM_IPC_IOC_PUT_FD_IMAGE _IOW(CAM_IPC_IOCTL, 7, struct cmd_msg_put_fd_image)
#define CAM_IPC_IOC_FREQ_UPDATE _IOR(CAM_IPC_IOCTL, 8, unsigned int)
#define CAM_IPC_IOC_START_LVR _IOR(CAM_IPC_IOCTL, 9, unsigned int)
#define CAM_IPC_IOC_STOP_LVR _IOR(CAM_IPC_IOCTL, 10, struct cmd_stop_lvr_responses_msg)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define CAM_IPC_IOC_I2C_WRITE _IOW(CAM_IPC_IOCTL, 11, struct cmd_i2c_msg)
#define CAM_IPC_IOC_I2C_READ _IOWR(CAM_IPC_IOCTL, 12, struct cmd_i2c_msg)
#define CAM_IPC_IOC_GET_SENSOR_CFG _IOR(CAM_IPC_IOCTL, 13, struct cmd_get_sensor_cfg_responses_msg)
#define CAM_IPC_IOC_SENSOR_POWER_CTRL _IOW(CAM_IPC_IOCTL, 14, unsigned int)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#endif
