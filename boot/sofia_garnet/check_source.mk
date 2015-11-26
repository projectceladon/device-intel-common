
ifneq "$(wildcard $(ANDROID_BUILD_TOP)/../soclib/)" ""
    BUILD_MODEM_FROM_SRC := true
	SOFIA_FW_SRC_BASE := $(CURDIR)/../
else
	SOFIA_FW_SRC_BASE := hardware/intel/garnet-3gr-sofia
endif


ifneq ($(SOFIA_FW_SRC_BASE),)
export SOFIA_FW_SRC_BASE
endif

ifneq ($(BUILD_MODEM_FROM_SRC),)
export BUILD_MODEM_FROM_SRC
endif
