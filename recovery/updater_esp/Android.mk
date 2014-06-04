LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := updater_esp.c
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES := bootable/recovery \
		    bootable/userfastboot/libgpt/include \
		    $(LOCAL_PATH)/../common_recovery

LOCAL_MODULE := libupdater_esp
LOCAL_CFLAGS := -Wall -Werror -DUEFI_ARCH=\"$(TARGET_UEFI_ARCH)\"
include $(BUILD_STATIC_LIBRARY)

