LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_LDLIBS_windows := -lws2_32 -lgdi32
LOCAL_LDLIBS_linux := -lrt -ldl -lpthread
LOCAL_CXX_STL := libc++_static

LOCAL_MODULE := action-authorization
#LOCAL_MODULE_HOST_OS := linux windows
LOCAL_SRC_FILES := action-authorization.c
LOCAL_C_INCLUDES := $(INTEL_PATH_VENDOR)/external/openssl/include/
LOCAL_CFLAGS := -Wall -Wextra -Werror
LOCAL_STATIC_LIBRARIES := libcrypto_static2

include $(BUILD_HOST_EXECUTABLE)
