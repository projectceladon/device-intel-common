LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE:= updater_ab_esp
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := updater_ab_esp.cpp
LOCAL_MODULE_OWNER := intel

ifeq ($(BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED),true)
    LOCAL_PROPRIETARY_MODULE := true
else
    LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/bin
    LOCAL_FORCE_STATIC_EXECUTABLE := true
endif

include $(BUILD_EXECUTABLE)
