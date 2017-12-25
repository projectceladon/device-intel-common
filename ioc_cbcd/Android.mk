LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := ioc_cbcd
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES += liblog libcutils libc
LOCAL_SRC_FILES := ioc_cbcd.c

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE := ioc_cbcd.recovery
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/vendor/bin
LOCAL_MODULE_STEM := ioc_cbcd
LOCAL_STATIC_LIBRARIES += liblog libcutils libc
LOCAL_SRC_FILES := ioc_cbcd.c
LOCAL_FORCE_STATIC_EXECUTABLE := true

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE := cbc_reboot
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES += liblog libcutils libc
LOCAL_SRC_FILES := cbc_reboot.cpp

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE := cbc_reboot.recovery
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/vendor/bin
LOCAL_MODULE_STEM := cbc_reboot
LOCAL_STATIC_LIBRARIES += liblog libcutils libc
LOCAL_SRC_FILES := cbc_reboot.cpp
LOCAL_FORCE_STATIC_EXECUTABLE := true

include $(BUILD_EXECUTABLE)

