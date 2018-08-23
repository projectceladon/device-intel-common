# If Makefile is located in vendor/intel directory
# but module is not installed in /vendor partition or /system/vendor
# it is a delinquant code.
# Add it to DELINQUANT_VENDOR_MODULES list to display
# a warning later during build process
ifneq (,$(filter vendor/intel%,$(LOCAL_MODULE_MAKEFILE)))
ifneq (,$(filter $(PRODUCT_OUT)%,$(LOCAL_INSTALLED_MODULE)))
ifeq (,$(filter $(PRODUCT_OUT)/system/vendor/% $(PRODUCT_OUT)/vendor/%,$(LOCAL_INSTALLED_MODULE)))
DELINQUANT_VENDOR_MODULES := $(DELINQUANT_VENDOR_MODULES) $(LOCAL_MODULE):$(LOCAL_INSTALLED_MODULE):$(LOCAL_MODULE_MAKEFILE)
endif
endif
endif

ifneq (,$(filter $(INTEL_PATH_HARDWARE)/% vendor/intel%,$(LOCAL_MODULE_MAKEFILE)))
ifneq (,$(filter user debug eng tests,$(LOCAL_MODULE_TAGS)))
DELINQUANT_TAGS_MODULES := $(DELINQUANT_TAGS_MODULES) $(LOCAL_MODULE):$(LOCAL_MODULE_TAGS):$(LOCAL_MODULE_MAKEFILE)
endif
endif

# Call original makefile from Android build system
include $(BUILD_SYSTEM)/notice_files.mk
