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
#ifndef _HSI_DLP_H
#define _HSI_DLP_H
#include <linux/ioctl.h>
enum {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 DLP_MODEM_HU_TIMEOUT = 1,
 DLP_MODEM_HU_RESET = 2,
 DLP_MODEM_HU_COREDUMP = 4,
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct hsi_dlp_stats {
 unsigned long long data_sz;
 unsigned int pdus_cnt;
 unsigned int overflow_cnt;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
#define HSI_DLP_MAGIC 0x77
#define HSI_DLP_RESET_TX _IO(HSI_DLP_MAGIC, 0)
#define HSI_DLP_RESET_RX _IO(HSI_DLP_MAGIC, 1)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define HSI_DLP_GET_TX_STATE _IOR(HSI_DLP_MAGIC, 2, unsigned int)
#define HSI_DLP_GET_RX_STATE _IOR(HSI_DLP_MAGIC, 3, unsigned int)
#define HSI_DLP_MODEM_RESET _IO(HSI_DLP_MAGIC, 4)
#define HSI_DLP_MODEM_STATE _IOR(HSI_DLP_MAGIC, 5, int)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define HSI_DLP_GET_HANGUP_REASON _IOR(HSI_DLP_MAGIC, 6, int)
#define HSI_DLP_SET_TX_WAIT_MAX _IOW(HSI_DLP_MAGIC, 8, unsigned int)
#define HSI_DLP_GET_TX_WAIT_MAX _IOR(HSI_DLP_MAGIC, 8, unsigned int)
#define HSI_DLP_SET_RX_WAIT_MAX _IOW(HSI_DLP_MAGIC, 9, unsigned int)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define HSI_DLP_GET_RX_WAIT_MAX _IOR(HSI_DLP_MAGIC, 9, unsigned int)
#define HSI_DLP_SET_TX_CTRL_MAX _IOW(HSI_DLP_MAGIC, 10, unsigned int)
#define HSI_DLP_GET_TX_CTRL_MAX _IOR(HSI_DLP_MAGIC, 10, unsigned int)
#define HSI_DLP_SET_RX_CTRL_MAX _IOW(HSI_DLP_MAGIC, 11, unsigned int)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define HSI_DLP_GET_RX_CTRL_MAX _IOR(HSI_DLP_MAGIC, 11, unsigned int)
#define HSI_DLP_SET_TX_DELAY _IOW(HSI_DLP_MAGIC, 12, unsigned int)
#define HSI_DLP_GET_TX_DELAY _IOR(HSI_DLP_MAGIC, 12, unsigned int)
#define HSI_DLP_SET_RX_DELAY _IOW(HSI_DLP_MAGIC, 13, unsigned int)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define HSI_DLP_GET_RX_DELAY _IOR(HSI_DLP_MAGIC, 13, unsigned int)
#define HSI_DLP_SET_TX_FLOW _IOW(HSI_DLP_MAGIC, 16, unsigned int)
#define HSI_DLP_GET_TX_FLOW _IOR(HSI_DLP_MAGIC, 16, unsigned int)
#define HSI_DLP_SET_RX_FLOW _IOW(HSI_DLP_MAGIC, 17, unsigned int)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define HSI_DLP_GET_RX_FLOW _IOR(HSI_DLP_MAGIC, 17, unsigned int)
#define HSI_DLP_SET_TX_MODE _IOW(HSI_DLP_MAGIC, 18, unsigned int)
#define HSI_DLP_GET_TX_MODE _IOR(HSI_DLP_MAGIC, 18, unsigned int)
#define HSI_DLP_SET_RX_MODE _IOW(HSI_DLP_MAGIC, 19, unsigned int)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define HSI_DLP_GET_RX_MODE _IOR(HSI_DLP_MAGIC, 19, unsigned int)
#define HSI_DLP_SET_TX_PDU_LEN _IOW(HSI_DLP_MAGIC, 24, unsigned int)
#define HSI_DLP_GET_TX_PDU_LEN _IOR(HSI_DLP_MAGIC, 24, unsigned int)
#define HSI_DLP_SET_RX_PDU_LEN _IOW(HSI_DLP_MAGIC, 25, unsigned int)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define HSI_DLP_GET_RX_PDU_LEN _IOR(HSI_DLP_MAGIC, 25, unsigned int)
#define HSI_DLP_SET_TX_ARB_MODE _IOW(HSI_DLP_MAGIC, 28, unsigned int)
#define HSI_DLP_GET_TX_ARB_MODE _IOR(HSI_DLP_MAGIC, 28, unsigned int)
#define HSI_DLP_SET_TX_FREQUENCY _IOW(HSI_DLP_MAGIC, 30, unsigned int)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define HSI_DLP_GET_TX_FREQUENCY _IOR(HSI_DLP_MAGIC, 30, unsigned int)
#define HSI_DLP_RESET_TX_STATS _IO(HSI_DLP_MAGIC, 32)
#define HSI_DLP_GET_TX_STATS _IOR(HSI_DLP_MAGIC, 32,   struct hsi_dlp_stats)
#define HSI_DLP_RESET_RX_STATS _IO(HSI_DLP_MAGIC, 33)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define HSI_DLP_GET_RX_STATS _IOR(HSI_DLP_MAGIC, 33,   struct hsi_dlp_stats)
#define HSI_DLP_NET_RESET_RX_STATS _IOW(HSI_DLP_MAGIC, 40, unsigned int)
#define HSI_DLP_NET_RESET_TX_STATS _IOW(HSI_DLP_MAGIC, 41, unsigned int)
#define HSI_DLP_SET_FLASHING_MODE _IOW(HSI_DLP_MAGIC, 42, unsigned int)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#endif
