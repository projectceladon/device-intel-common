LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := $(call all-java-files-under, base)
LOCAL_SRC_FILES += $(call all-java-files-under, opt)

LOCAL_JAVA_LIBRARIES := ims-common

LOCAL_MODULE := com.intel.ims_stub

include $(BUILD_STATIC_JAVA_LIBRARY)
