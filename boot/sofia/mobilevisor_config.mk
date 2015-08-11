# Copyright (C) 2013-2014 Intel Mobile Communications GmbH
# Copyright (C) 2011 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ------------------------------------------------------------------------
ifeq ($(BUILD_VMM_FROM_SRC),true)
#Source Paths configured in Base Android.mk
#Build Output path.
MV_CONFIG_PRODUCT_PATH := $(SOFIA_FW_SRC_BASE)/mobilevisor/products
MV_CONFIG_TEMPLATE_PATH := $(MV_CONFIG_PRODUCT_PATH)/configs
MV_CONFIG_BUILD_OUT     := $(CURDIR)/$(PRODUCT_OUT)/vmm_build/configs
MV_NUM_OF_CPUS ?= 2
MV_CONFIG_PADDR ?= 0x1CC00000

MV_CONFIG_INC_PATH         =
MV_CONFIG_INC_PATH_VARIANT         =

ifneq '$(MV_CONFIG_TYPE)' ''
MV_CONFIG_INC_PATH_VARIANT = $(MV_CONFIG_TYPE)
endif

#################################
# supported MVCONFIG_TYPE
# up, smp, smp_profiling
# modemonly
# 512mb
# smp_64bit
#################################
ifneq '$(MV_CONFIG_TYPE)' ''
MV_CONFIG_DEFAULT_TYPE = $(MV_CONFIG_TYPE)
else
MV_CONFIG_TYPE += up
MV_CONFIG_TYPE += smp
MV_CONFIG_TYPE += smp_profiling
MV_CONFIG_DEFAULT_TYPE = smp
endif

MV_CONFIG_DEFAULT_FLS = $(FLASHFILES_DIR)/mvconfig_$(MV_CONFIG_DEFAULT_TYPE).fls
MV_CONFIG_DEFAULT_BIN = $(MV_CONFIG_BUILD_OUT)/mvconfig_$(MV_CONFIG_DEFAULT_TYPE).bin
MV_CONFIG_DEFAULT_SIGNED_FLS := $(SIGN_FLS_DIR)/mvconfig_$(MV_CONFIG_DEFAULT_TYPE)_signed.fls
SYSTEM_SIGNED_FLS_LIST  += $(MV_CONFIG_DEFAULT_SIGNED_FLS)

SOFIA_PROVDATA_FILES += $(MV_CONFIG_DEFAULT_FLS)

#############################
# create fls, bin, xml list #
#############################
MV_CONFIG_XML_LIST =
MV_CONFIG_BIN_LIST =
MV_CONFIG_FLS_LIST =

MV_CONFIG_FLS_OUTPUT = $(FLASHFILES_DIR)/mvconfigs
$(MV_CONFIG_FLS_OUTPUT) :
	mkdir -p $@

define CREATE_MV_FILE_LIST
MV_CONFIG_XML_LIST      += $(MV_CONFIG_BUILD_OUT)/mvconfig_$(1).xml
MV_CONFIG_BIN_LIST      += $(MV_CONFIG_BUILD_OUT)/mvconfig_$(1).bin
MV_CONFIG_FLS_LIST      += $(MV_CONFIG_FLS_OUTPUT)/mvconfig_$(1).fls
endef

$(foreach t,$(MV_CONFIG_TYPE),$(eval $(call CREATE_MV_FILE_LIST,$(t))))

.SECONDARY: $(MV_CONFIG_BIN_LIST)

###########################
# type build option       #
########################### 
MV_CONFIG_OPTION_common    = -D __MV_NUM_OF_CPUS__=$(MV_NUM_OF_CPUS) -D __MV_PROD_NAME__=$(PRODUCT_NAME) -D __MV_CONFIG_START_PADDR__=$(MV_CONFIG_PADDR)

ifdef TARGET_MVCONFIG_OPTIONS
MV_CONFIG_OPTION_common    += $(TARGET_MVCONFIG_OPTIONS)
endif

ifeq '$(findstring 3gr,${TARGET_BOARD_PLATFORM})' '3gr'
MV_CONFIG_OPTION_common    += -D __MV_SECVM_LOW_PRIO__
endif

ifeq ($(SECURE_PLAYBACK_ENABLE),true)
MV_CONFIG_OPTION_common += -D __MV_SECURE_PLAYBACK__
endif

ifneq '$(MV_CONFIG_CHIP_VER)' ''
MV_CONFIG_INC_PATH         += -I $(MV_CONFIG_PRODUCT_PATH)/$(TARGET_BOARD_PLATFORM_VAR)/configs/$(MV_CONFIG_CHIP_VER)
endif
MV_CONFIG_INC_PATH         += -I $(MV_CONFIG_PRODUCT_PATH)/$(TARGET_BOARD_PLATFORM_VAR)/configs/$(MV_CONFIG_INC_PATH_VARIANT)
MV_CONFIG_INC_PATH         += -I $(MV_CONFIG_PRODUCT_PATH)/$(TARGET_BOARD_PLATFORM_VAR)/configs
MV_CONFIG_OPTION_common    += -D __MV_PLATFORM_VAR__=$(TARGET_BOARD_PLATFORM_VAR)

ifneq '$(MV_CONFIG_CHIP_VER)' ''
MV_CONFIG_INC_PATH         += -I $(MV_CONFIG_PRODUCT_PATH)/$(TARGET_BOARD_PLATFORM)/configs/$(MV_CONFIG_CHIP_VER)
endif
MV_CONFIG_INC_PATH         += -I $(MV_CONFIG_PRODUCT_PATH)/$(TARGET_BOARD_PLATFORM)/configs/$(MV_CONFIG_INC_PATH_VARIANT)
MV_CONFIG_INC_PATH         += -I $(MV_CONFIG_PRODUCT_PATH)/$(TARGET_BOARD_PLATFORM)/configs

MV_CONFIG_OPTION_common    += -D __MV_PLATFORM__=$(TARGET_BOARD_PLATFORM)

MV_CONFIG_OPTION_up        = 
MV_CONFIG_OPTION_smp       = -D __MV_SMP__
MV_CONFIG_OPTION_smp_64bit     = -D __MV_64BIT_LINUX__ -D __MV_SMP__
MV_CONFIG_OPTION_smp_profiling = -D __MV_PROFILING__ -D __MV_SMP__
MV_CONFIG_OPTION_modemonly = -D __MV_MODEM_ONLY__
MV_CONFIG_OPTION_512mb = -D __MV_SMP__

###########################
# create rules
###########################
.PHONY : force
force: ;

define CREATE_MV_CONFIG_XML_RULES
$(MV_CONFIG_BUILD_OUT)/mvconfig_$(1).xml : force | $(MV_CONFIG_BUILD_OUT)
	icc -E -P \
		$(MV_CONFIG_OPTION_common) \
		$$(MV_CONFIG_OPTION_$(1)) \
		-I- $(MV_CONFIG_INC_PATH) -I $(MV_CONFIG_TEMPLATE_PATH) \
		$(MV_CONFIG_TEMPLATE_PATH)/mvconfig.xml \
		| sed '/^$$$$/d' | xmllint --format - \
		> $(MV_CONFIG_BUILD_OUT)/mvconfig_$(1).xml

mvconfig_$(1).fls : $(MV_CONFIG_FLS_OUTPUT)/mvconfig_$(1).fls
endef

$(foreach t,$(MV_CONFIG_TYPE),$(eval $(call CREATE_MV_CONFIG_XML_RULES,$(t))))

$(MV_CONFIG_BUILD_OUT)/%.bin: $(MV_CONFIG_BUILD_OUT)/%.xml | $(MV_CONFIG_BUILD_OUT)
	@$(MOBILEVISOR_REL_PATH)/tools/mvconfig $< $@

$(MV_CONFIG_FLS_OUTPUT)/mvconfig_%.fls : $(MV_CONFIG_BUILD_OUT)/mvconfig_%.bin $(FLASHLOADER_FLS) | $(MV_CONFIG_FLS_OUTPUT)
	@$(FLSTOOL) --prg $(INTEL_PRG_FILE) \
	           --output $@ \
		   --tag MV_CONFIG \
		   $(INJECT_FLASHLOADER_FLS) \
		   $< \
		   --replace --to-fls2

$(FLASHFILES_DIR)/mvconfig_%.fls: $(MV_CONFIG_FLS_OUTPUT)/mvconfig_%.fls
	$(copy-file-to-new-target)

$(MV_CONFIG_BUILD_OUT):
	@mkdir -p $(MV_CONFIG_BUILD_OUT)

mvconfig_info:
	@echo "---------------------------------------------------------------------"
	@echo "Mobilevisor:"
	@echo "-make mvconfig_up.fls     : Will generate mobilevisor configuration fls file with UP settings."
	@echo "-make mvconfig_smp.fls    : Will generate mobilevisor configuration fls file with SMP settings."	

build_info: mvconfig_info

endif
