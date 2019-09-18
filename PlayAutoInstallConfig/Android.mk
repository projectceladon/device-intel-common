LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

apk_variant :=
APK_VERSION := 1
include $(LOCAL_PATH)/build_apk.mk

include $(CLEAR_VARS)

apk_variant := intel
APK_VERSION := 1000
include $(LOCAL_PATH)/build_apk.mk
