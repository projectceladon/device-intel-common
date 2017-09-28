LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_CPP_EXTENSION := .cc
LOCAL_CPPFLAGS := \
    -Wnon-virtual-dtor \
    -fno-strict-aliasing

LOCAL_LDFLAGS := -Wl,--gc-sections
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES := bootable/recovery \
                    system/core/base/include \
                    $(LOCAL_PATH)/../common_recovery

LOCAL_MODULE := updater_ab
LOCAL_SRC_FILES := updater_ab.cc
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR)/bin

LOCAL_STATIC_LIBRARIES := \
    libbase \
    libcutils \
    libutils \
    liblog

LOCAL_FORCE_STATIC_EXECUTABLE := true
include $(BUILD_EXECUTABLE)
