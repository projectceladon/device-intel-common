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
#ifndef _IIO_EVENTS_H_
#define _IIO_EVENTS_H_
#include <linux/iio/types.h>
#include <uapi/linux/iio/events.h>
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define IIO_EVENT_CODE(chan_type,diff,modifier,direction,type,chan,chan1,chan2) (((u64) type << 56) | ((u64) diff << 55) | ((u64) direction << 48) | ((u64) modifier << 40) | ((u64) chan_type << 32) | (((u16) chan2) << 16) | ((u16) chan1) | ((u16) chan))
#define IIO_MOD_EVENT_CODE(chan_type,number,modifier,type,direction) IIO_EVENT_CODE(chan_type, 0, modifier, direction, type, number, 0, 0)
#define IIO_UNMOD_EVENT_CODE(chan_type,number,type,direction) IIO_EVENT_CODE(chan_type, 0, 0, direction, type, number, 0, 0)
#endif
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
