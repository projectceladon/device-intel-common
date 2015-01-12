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
MV_CONFIG_PRODUCT_PATH := $(CURDIR)/mobilevisor/products
MV_CONFIG_TEMPLATE_PATH := $(MV_CONFIG_PRODUCT_PATH)/configs
MV_CONFIG_BUILD_OUT     := $(CURDIR)/$(PRODUCT_OUT)/vmm_build/configs
MV_NUM_OF_CPUS ?= 2
MV_CONFIG_PADDR ?= 0x30000000

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
ifeq '$(MV_CONFIG_TYPE)' 'modemonly'
MV_CONFIG_DEFAULT_FLS = $(MV_CONFIG_FLS_OUTPUT)/mvconfig_$(MV_CONFIG_TYPE).fls
MV_CONFIG_DEFAULT_BIN = $(MV_CONFIG_BUILD_OUT)/mvconfig_$(MV_CONFIG_TYPE).bin
SYSTEM_SIGNED_FLS_LIST  += $(SIGN_FLS_DIR)/mvconfig_$(MV_CONFIG_TYPE)_signed.fls
else
  ifeq '$(MV_CONFIG_BITNESS)' '64'
MV_CONFIG_TYPE += smp_64bit
MV_CONFIG_DEFAULT_FLS = $(MV_CONFIG_FLS_OUTPUT)/mvconfig_smp_64bit.fls
MV_CONFIG_DEFAULT_BIN = $(MV_CONFIG_BUILD_OUT)/mvconfig_smp_64bit.bin
SYSTEM_SIGNED_FLS_LIST  += $(SIGN_FLS_DIR)/mvconfig_smp_64bit_signed.fls
  else
MV_CONFIG_TYPE += up
MV_CONFIG_TYPE += smp
MV_CONFIG_TYPE += smp_profiling
MV_CONFIG_DEFAULT_FLS = $(MV_CONFIG_FLS_OUTPUT)/mvconfig_smp.fls
MV_CONFIG_DEFAULT_BIN = $(MV_CONFIG_BUILD_OUT)/mvconfig_smp.bin
SYSTEM_SIGNED_FLS_LIST  += $(SIGN_FLS_DIR)/mvconfig_smp_signed.fls
  endif
endif

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
	python $(MOBILEVISOR_REL_PATH)/tools/preprocess.py \
		-s $(MV_CONFIG_OPTION_common) \
		$$(MV_CONFIG_OPTION_$(1)) \
		$(MV_CONFIG_INC_PATH) -I $(MV_CONFIG_TEMPLATE_PATH) \
		$(MV_CONFIG_TEMPLATE_PATH)/mvconfig.xml \
		| xmllint --format - \
		> $(MV_CONFIG_BUILD_OUT)/mvconfig_$(1).xml

mvconfig_$(1).fls : $(FLASHFILES_DIR)/mvconfig_$(1).fls
endef

$(foreach t,$(MV_CONFIG_TYPE),$(eval $(call CREATE_MV_CONFIG_XML_RULES,$(t))))

$(MV_CONFIG_BUILD_OUT)/%.bin: $(MV_CONFIG_BUILD_OUT)/%.xml | $(MV_CONFIG_BUILD_OUT)
	@$(MOBILEVISOR_REL_PATH)/tools/mvconfig $< $@

$(MV_CONFIG_FLS_OUTPUT)/mvconfig_%.fls : $(MV_CONFIG_BUILD_OUT)/mvconfig_%.bin $(FLASHLOADER_FLS) | $(MV_CONFIG_FLS_OUTPUT)
	@$(FLSTOOL) --prg $(BOARD_PRG_FILE) \
	           --output $@ \
		   --tag MV_CONFIG \
		   $(INJECT_FLASHLOADER_FLS) \
		   $< \
		   --replace --to-fls2

# Build VMM images as dependency to default android build target "droidcore"
droidcore: mvconfig_copy_default

mvconfig_copy_default: $(MV_CONFIG_FLS_LIST)
	@cp -f $(MV_CONFIG_DEFAULT_FLS) $(FLASHFILES_DIR)

$(MV_CONFIG_BUILD_OUT):
	@mkdir -p $(MV_CONFIG_BUILD_OUT)

mvconfig_info:
	@echo "---------------------------------------------------------------------"
	@echo "Mobilevisor:"
	@echo "-make mvconfig_up.fls     : Will generate mobilevisor configuration fls file with UP settings."
	@echo "-make mvconfig_smp.fls    : Will generate mobilevisor configuration fls file with SMP settings."	

build_info: mvconfig_info

.PHONY: mvconfig
mvconfig: mvconfig_copy_default
endif
