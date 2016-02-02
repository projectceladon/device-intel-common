LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ifeq ($(HOST_OS),windows)
  LOCAL_LDLIBS += -lws2_32 -lgdi32
endif

ifeq ($(HOST_OS),linux)
  LOCAL_LDLIBS += -lrt -ldl -lpthread
  LOCAL_CXX_STL := libc++_static
endif

LOCAL_MODULE := action-authorization
LOCAL_SRC_FILES := action-authorization.c
LOCAL_C_INCLUDES := vendor/intel/external/openssl/include/
LOCAL_CFLAGS := -Wall -Wextra -Werror
LOCAL_STATIC_LIBRARIES := libcrypto_static2

include $(BUILD_HOST_EXECUTABLE)
