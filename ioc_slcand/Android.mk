LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := ioc_slcand
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES += liblog libcutils libc
LOCAL_SRC_FILES := ioc_slcand.c

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE := ioc_slcand.recovery
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/vendor/bin
LOCAL_MODULE_STEM := ioc_slcand
LOCAL_STATIC_LIBRARIES += liblog libcutils libc
LOCAL_SRC_FILES := ioc_slcand.c
LOCAL_FORCE_STATIC_EXECUTABLE := true

include $(BUILD_EXECUTABLE)
