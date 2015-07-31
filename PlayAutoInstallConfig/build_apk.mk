LOCAL_MODULE_TAGS := optional
LOCAL_SDK_VERSION := current

ifeq ($(apk_variant),)
  LOCAL_PACKAGE_NAME := PlayAutoInstallConfig
  LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res
  LOCAL_FULL_MANIFEST_FILE := $(LOCAL_PATH)/stub/AndroidManifest.xml
  LOCAL_OVERRIDES_PACKAGES := $(GMS_PAI_OVERRIDE_APPS)
else
  LOCAL_PACKAGE_NAME := PlayAutoInstallConfig-$(apk_variant)
  LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res-$(apk_variant)
  LOCAL_DEX_PREOPT := false
endif

# We don't have other java source files.
LOCAL_SOURCE_FILES_ALL_GENERATED := true
LOCAL_PROGUARD_ENABLED := disabled
LOCAL_CERTIFICATE := platform

LOCAL_AAPT_FLAGS += --version-name $(APK_VERSION) --version-code $(APK_VERSION)
include $(BUILD_PACKAGE)
