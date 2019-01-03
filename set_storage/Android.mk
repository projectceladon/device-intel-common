LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := set_storage
LOCAL_SRC_FILES := set_storage.c
LOCAL_CFLAGS := -Wall -Wextra -Werror

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)

LOCAL_STATIC_LIBRARIES := \
	libcutils \
	libc \
	liblog

include $(BUILD_EXECUTABLE)


include $(CLEAR_VARS)

LOCAL_MODULE := set_storage.vendor
LOCAL_SRC_FILES := set_storage.c
LOCAL_CFLAGS := -Wall -Wextra -Werror

LOCAL_PROPRIETARY_MODULE := true

LOCAL_SHARED_LIBRARIES := \
	libcutils \
	libc \
	liblog

include $(BUILD_EXECUTABLE)
