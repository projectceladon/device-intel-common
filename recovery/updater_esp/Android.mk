LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := updater_esp.cpp
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES := bootable/recovery \
		    bootable/userfastboot/libgpt/include \
		    $(LOCAL_PATH)/../common_recovery
LOCAL_MODULE := libupdater_esp
LOCAL_CFLAGS := -Wall  -DUEFI_ARCH=\"$(TARGET_UEFI_ARCH)\"

ifeq ($(TARGET_SUPPORT_BOOT_OPTION),true)
    LOCAL_STATIC_LIBRARIES := libefivar
    LOCAL_C_INCLUDES += external/efivar/src
    LOCAL_CFLAGS += -DSUPPORT_BOOT_OPTION
endif

include $(BUILD_STATIC_LIBRARY)

