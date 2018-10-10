LOCAL_PATH := $(call my-dir)

# Static version for recovery console plug-ins;
# we'll want to emit debugs to stdout instead of liblog
include $(CLEAR_VARS)
LOCAL_SRC_FILES := gpt.c
LOCAL_MODULE := libgpt_static
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS := -Wall  -DDEBUG_STDOUT=1
LOCAL_C_INCLUDES := $(LOCAL_PATH)/include \
		    external/zlib \

LOCAL_STATIC_LIBRARIES := libz libcutils
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := gpt.c
LOCAL_MODULE := libgpt
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS := -Wall
LOCAL_C_INCLUDES := $(LOCAL_PATH)/include \
		    external/zlib \

LOCAL_SHARED_LIBRARIES := libz libcutils liblog
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := gptdump.c
LOCAL_MODULE := gptdump
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS := -Wall
LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_SHARED_LIBRARIES := libgpt
include $(BUILD_EXECUTABLE)

