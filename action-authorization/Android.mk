LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := action-authorization
LOCAL_LDLIBS += -ldl
LOCAL_SRC_FILES := action-authorization.c
LOCAL_C_INCLUDES := external/openssl/include/
LOCAL_CFLAGS := -Wall -Wextra -Werror
LOCAL_CXX_STL = libc++_static
LOCAL_STATIC_LIBRARIES := libcrypto_static2

include $(BUILD_HOST_EXECUTABLE)
