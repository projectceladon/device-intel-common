LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := efiprop
LOCAL_SRC_FILES := efiprop.c
LOCAL_CFLAGS := -Wall -Wextra -Werror

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)

LOCAL_STATIC_LIBRARIES := \
	libefivar \
	libcutils \
	libc \
	liblog

LOCAL_C_INCLUDES += external/efivar/src

include $(BUILD_EXECUTABLE)
