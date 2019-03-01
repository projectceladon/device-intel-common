LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE:= updater_ab_esp_vendor
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := updater_ab_esp.cpp
LOCAL_MODULE_OWNER := intel
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE    := updater_ab_esp_static
LOCAL_SRC_FILES := updater_ab_esp.cpp
LOCAL_CXX_STL := libc++_static
LOCAL_MODULE_OWNER := intel
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/vendor/bin
LOCAL_FORCE_STATIC_EXECUTABLE := true
include $(BUILD_EXECUTABLE)
