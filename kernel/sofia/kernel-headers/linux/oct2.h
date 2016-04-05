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
#ifndef OCT_DEV_H
#define OCT_DEV_H
#define OCT_EXT_RING_BUFF_SIZE 0x400000
#define DEFAULT_OCT_MODE OCT_MODE_STALL
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define DEFAULT_OCT_PATH OCT_PATH_USB
#define DEFAULT_OCT_FCS_SIZE OCT_FCS_SIZE_32
#define OCT2_PG_TIMEOUT_RUN 1000
#define OCT2_PG_TIMEOUT_SLEEP 10000
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define OFFLOG_PATH_LEN 128
#define OCT_FILE_SIZE_MIN_SIZE 0x200000
#define DEFAULT_OCT_OFFLOG_SIZE 0x400000
#define DEFAULT_OCT_OFFLOG_NUMBER 5
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define DEFAULT_OFFLOG_PATH "/data/logs/"
#define DEFAULT_OFFLOG_NAME "bplog"
enum e_oct_ioctl {
  OCT_IOCTL_SET_PATH = 10,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  OCT_IOCTL_SET_MODE,
  OCT_IOCTL_CONF_TRIG_CYCLE,
  OCT_IOCTL_ENTER_CD,
  OCT_IOCTL_FLUSH,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  OCT_IOCTL_GET_PATH,
  OCT_IOCTL_GET_INFO,
  OCT_IOCTL_OPEN_FILE,
  OCT_IOCTL_CLOSE_FILE
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
enum e_oct_mode {
  OCT_MODE_OFF = 0,
  OCT_MODE_STALL,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  OCT_MODE_OW
};
enum e_oct_path {
  OCT_PATH_NONE = 0,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  OCT_PATH_READ_IF,
  OCT_PATH_LDISC,
  OCT_PATH_FILE,
  OCT_PATH_USB,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct s_oct_info {
  unsigned int rd_ptr;
  unsigned int wr_ptr;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  unsigned char is_full;
  unsigned char irq_stat;
};
struct s_oct_file_path {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  char * file_name;
  unsigned char file_path_length;
  unsigned int file_size;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#endif
