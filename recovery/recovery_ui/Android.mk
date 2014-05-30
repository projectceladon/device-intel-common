LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := gmin_recovery_ui.cpp
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES := bootable/recovery
LOCAL_MODULE := libgmin_recovery_ui
LOCAL_CFLAGS := -Wall -Wno-unused-parameter -Werror
ifeq ($(RECOVERY_HAVE_SD_CARD),true)
LOCAL_CFLAGS += -DHAVE_SD_CARD=1
endif
include $(BUILD_STATIC_LIBRARY)

