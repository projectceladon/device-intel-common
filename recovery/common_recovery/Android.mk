LOCAL_PATH := $(call my-dir)

# Plug-in library for AOSP updater.
# This library contains Edify functions that are generally
# useful and not specific to particular platform.

include $(CLEAR_VARS)
LOCAL_MODULE := libcommon_recovery
LOCAL_SRC_FILES := common_recovery.c
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_C_INCLUDES := bootable/recovery system/core/mkbootimg
LOCAL_CFLAGS := -Wall -Werror -Wno-unused-parameter
include $(BUILD_STATIC_LIBRARY)
