LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE:= updater_ab_esp
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := updater_ab_esp.cpp
LOCAL_MODULE_OWNER := intel
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR)/bin
#LOCAL_FORCE_STATIC_EXECUTABLE := true
include $(BUILD_EXECUTABLE)

