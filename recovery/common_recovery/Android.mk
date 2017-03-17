LOCAL_PATH := $(call my-dir)

# Plug-in library for AOSP updater.
# This library contains Edify functions that are generally
# useful and not specific to particular platform.

include $(CLEAR_VARS)
LOCAL_MODULE := libcommon_recovery
LOCAL_SRC_FILES := common_recovery.cpp
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_C_INCLUDES := bootable/recovery bootable/recovery/updater/include system/core/mkbootimg external/selinux/libselinux/include \
                    system/core/libziparchive
LOCAL_CFLAGS := -Wall -Wno-unused-parameter
LOCAL_STATIC_LIBRARIES += libedify libziparchive
include $(BUILD_STATIC_LIBRARY)
