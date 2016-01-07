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
#ifndef _PN544_H_
#define _PN544_H_
#include <linux/i2c.h>
#define PN544_SET_PWR _IOW(PN544_MAGIC, 0x01, unsigned int)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PN544_MAGIC 0xe9
enum {
 NFC_GPIO_ENABLE,
 NFC_GPIO_FW_RESET,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 NFC_GPIO_IRQ,
};
struct pn544_nfc_platform_data {
 int (*request_resources) (struct i2c_client *client);
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 void (*free_resources) (void);
 void (*enable) (int fw);
 int (*test) (void);
 void (*disable) (void);
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 int (*get_gpio)(int type);
};
#endif
