LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := $(call all-java-files-under, src)

LOCAL_JAVA_LIBRARIES := telephony-common

LOCAL_MODULE := phone_dualsim_edvp_stub

include $(BUILD_STATIC_JAVA_LIBRARY)
