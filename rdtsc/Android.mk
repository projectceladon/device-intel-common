LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_CFLAGS := -Wall -Wextra -Werror
LOCAL_SRC_FILES := rdtsc.c
LOCAL_SHARED_LIBRARIES := libutils liblog
LOCAL_MODULE := rdtsc
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := intel
LOCAL_PROPRIETARY_MODULE := true
LOCAL_C_INCLUDES := $(TOP)/system/core/libutils
include $(BUILD_EXECUTABLE)

