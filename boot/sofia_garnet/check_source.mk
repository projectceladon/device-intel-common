
ifneq "$(wildcard $(ANDROID_BUILD_TOP)/../soclib/)" ""
    BUILD_OS_AGNOSTIC_FROM_SRC := true
	SOFIA_FW_SRC_BASE := $(CURDIR)/../
else
	SOFIA_FW_SRC_BASE := hardware/intel/mrd-3gr-sofia
endif


ifneq ($(SOFIA_FW_SRC_BASE),)
export SOFIA_FW_SRC_BASE
endif

ifneq ($(BUILD_OS_AGNOSTIC_FROM_SRC),)
export BUILD_OS_AGNOSTIC_FROM_SRC
endif