LOCAL_PATH := $(my-dir)

##################################################

include $(CLEAR_VARS)

LOCAL_MODULE := bt_vendor.default.conf
LOCAL_SRC_FILES := bt_vendor.conf
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT)/etc/bluetooth
LOCAL_MODULE_STEM := $(LOCAL_SRC_FILES)

include $(BUILD_PREBUILT)
##################################################
