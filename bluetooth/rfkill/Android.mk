LOCAL_PATH := $(my-dir)

##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := rfkill_bt.sh
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SCRIPT
LOCAL_MODULE_PATH := $(TARGET_OUT_EXECUTABLES)
LOCAL_SRC_FILES := rfkill_bt.sh
include $(BUILD_PREBUILT)

##################################################
