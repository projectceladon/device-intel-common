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
MV_CONFIG_PRODUCT_PATH  := $(SOFIA_FW_SRC_BASE)/mobilevisor/products
MV_CONFIG_TEMPLATE_PATH := $(MV_CONFIG_PRODUCT_PATH)/configs

define CREATE_MV_FILE_LIST
# $(1) == each SOFIA_FIRMWARE_VARIANT
# $(2) == each MV_CONFIG_TYPE
MV_CONFIG_XML_LIST.$(1)      += $$(MV_CONFIG_BUILD_OUT.$(1))/mvconfig_$(2).xml
MV_CONFIG_BIN_LIST.$(1)      += $$(MV_CONFIG_BUILD_OUT.$(1))/mvconfig_$(2).bin
MV_CONFIG_FLS_LIST.$(1)      += $$(MV_CONFIG_FLS_OUTPUT.$(1))/mvconfig_$(2).fls
endef

define CREATE_MV_CONFIG_XML_RULES
# $(1) == each SOFIA_FIRMWARE_VARIANT
# $(2) == each MV_CONFIG_TYPE
ifeq ($$(GEN_MV_RAM_DEFS_FROM_XML), true)
$$(MV_CONFIG_BUILD_OUT.$(1))/mvconfig_$(2).xml : force | $$(MV_CONFIG_BUILD_OUT.$(1)) $$(MV_CONFIG_RAM_DEFS_DEST_FILE.$(1))
else
$$(MV_CONFIG_BUILD_OUT.$(1))/mvconfig_$(2).xml : force | $$(MV_CONFIG_BUILD_OUT.$(1))
endif
	icc -E -P \
		$$(MV_CONFIG_OPTION_common.$(1)) \
		$$(MV_CONFIG_OPTION_$(2).$(1)) \
		-I- $$(MV_CONFIG_INC_PATH.$(1)) -I $$(MV_CONFIG_TEMPLATE_PATH) \
		$$(MV_CONFIG_TEMPLATE_PATH)/mvconfig.xml \
		| sed '/^$$$$/d' | xmllint --format - \
		> $$(MV_CONFIG_BUILD_OUT.$(1))/mvconfig_$(2).xml

mvconfig_$(2).fls.$(1) : $$(MV_CONFIG_FLS_OUTPUT.$(1))/mvconfig_$(2).fls
endef

define mobilevisor_config_per_variant

MV_CONFIG_BUILD_OUT.$(1)     := $$(SOFIA_FIRMWARE_OUT.$(1))/vmm_build/configs
MV_NUM_OF_CPUS.$(1) ?= $(if $(MV_NUM_OF_CPUS),$(MV_NUM_OF_CPUS),2)
MV_CONFIG_CHIP_VER.$(1) ?= $(MV_CONFIG_CHIP_VER)
MV_CONFIG_PADDR.$(1) ?= $(if $(MV_CONFIG_PADDR),$(MV_CONFIG_PADDR),0x1CC00000)

MV_CONFIG_INC_PATH.$(1)         =
MV_CONFIG_INC_PATH_VARIANT.$(1)         =

ifneq '$$(MV_CONFIG_TYPE.$(1))' ''
MV_CONFIG_INC_PATH_VARIANT.$(1) = $$(MV_CONFIG_TYPE.$(1))
endif

#################################
# supported MVCONFIG_TYPE
# up, smp, smp_profiling
# modemonly
# 512mb
# smp_64bit
#################################
ifneq '$$(MV_CONFIG_TYPE.$(1))' ''
MV_CONFIG_DEFAULT_TYPE.$(1) = $$(MV_CONFIG_TYPE.$(1))
else
MV_CONFIG_TYPE.$(1) += up
MV_CONFIG_TYPE.$(1) += smp
MV_CONFIG_TYPE.$(1) += smp_profiling
MV_CONFIG_DEFAULT_TYPE.$(1) = smp
endif

MV_CONFIG_DEFAULT_FLS.$(1) = $$(FLASHFILES_DIR.$(1))/mvconfig_$$(MV_CONFIG_DEFAULT_TYPE.$(1)).fls
MV_CONFIG_DEFAULT_BIN.$(1) = $$(MV_CONFIG_BUILD_OUT.$(1))/mvconfig_$$(MV_CONFIG_DEFAULT_TYPE.$(1)).bin
MV_CONFIG_DEFAULT_SIGNED_FLS.$(1) := $$(SIGN_FLS_DIR.$(1))/mvconfig_$$(MV_CONFIG_DEFAULT_TYPE.$(1))_signed.fls
SYSTEM_SIGNED_FLS_LIST.$(1) += $$(MV_CONFIG_DEFAULT_SIGNED_FLS.$(1))

#############################
# create fls, bin, xml list #
#############################
MV_CONFIG_XML_LIST.$(1) =
MV_CONFIG_BIN_LIST.$(1) =
MV_CONFIG_FLS_LIST.$(1) =

MV_CONFIG_FLS_OUTPUT.$(1) = $$(FLASHFILES_DIR.$(1))/mvconfigs
$$(MV_CONFIG_FLS_OUTPUT.$(1)):
	mkdir -p $$@

$$(foreach t,$$(MV_CONFIG_TYPE.$(1)),$$(eval $$(call CREATE_MV_FILE_LIST,$(1),$$(t))))

.SECONDARY: $$(MV_CONFIG_BIN_LIST.$(1))

###########################
# type build option       #
########################### 
MV_CONFIG_OPTION_common.$(1)    = -D __MV_NUM_OF_CPUS__=$$(MV_NUM_OF_CPUS.$(1)) -D __MV_PROD_NAME__=$$(PRODUCT_NAME) -D __MV_CONFIG_START_PADDR__=$$(MV_CONFIG_PADDR.$(1)) -D __SILENTLAKE_ENABLED__

ifdef TARGET_MVCONFIG_OPTIONS.$(1)
MV_CONFIG_OPTION_common.$(1)    += $$(TARGET_MVCONFIG_OPTIONS.$(1))
endif

ifeq ($$(SECURE_PLAYBACK_ENABLE),true)
MV_CONFIG_OPTION_common.$(1) += -D __MV_SECURE_PLAYBACK__
endif

MV_CONFIG_INC_PATH.$(1) += -I $$(abspath $$(MV_CONFIG_BUILD_OUT.$(1)))
ifneq '$$(MV_CONFIG_CHIP_VER.$(1))' ''
MV_CONFIG_INC_PATH.$(1)         += -I $$(MV_CONFIG_PRODUCT_PATH)/$$(TARGET_BOARD_PLATFORM_VAR)/configs/$$(MV_CONFIG_CHIP_VER.$(1)) $$(MV_CONFIG_BUILD_OUT.$(1))
endif
MV_CONFIG_INC_PATH.$(1)         += -I $$(MV_CONFIG_PRODUCT_PATH)/$$(TARGET_BOARD_PLATFORM_VAR)/configs/$$(MV_CONFIG_INC_PATH_VARIANT.$(1))
MV_CONFIG_INC_PATH.$(1)         += -I $$(MV_CONFIG_PRODUCT_PATH)/$$(TARGET_BOARD_PLATFORM_VAR)/configs
MV_CONFIG_OPTION_common.$(1)    += -D __MV_PLATFORM_VAR__=$$(TARGET_BOARD_PLATFORM_VAR)

MV_CONFIG_OPTION_common.$(1)    += -D __MV_PLATFORM__=$$(TARGET_BOARD_PLATFORM)

ifeq '$$(findstring sofia3gr_garnet,${TARGET_BOARD_PLATFORM_VAR})' 'sofia3gr_garnet'
MV_CONFIG_OPTION_common.$(1)    += -D __MV_PLATFORM_SOFIA3GR_GARNET__
endif
ifeq '$$(findstring sofia3gr_mrd,${TARGET_BOARD_PLATFORM_VAR})' 'sofia3gr_mrd'
MV_CONFIG_OPTION_common.$(1)    += -D __MV_PLATFORM_SOFIA3GR_MRD__
endif

MV_CONFIG_OPTION_up.$(1)        = 
MV_CONFIG_OPTION_smp.$(1)       = -D __MV_SMP__
MV_CONFIG_OPTION_smp_64bit.$(1)     = -D __MV_64BIT_LINUX__ -D __MV_SMP__
MV_CONFIG_OPTION_smp_profiling.$(1) = -D __MV_PROFILING__ -D __MV_SMP__
MV_CONFIG_OPTION_modemonly.$(1) = -D __MV_MODEM_ONLY__
MV_CONFIG_OPTION_512mb.$(1) = -D __MV_SMP__

ifeq ($$(GEN_MV_RAM_DEFS_FROM_XML), true)
MV_CONFIG_OPTION_common.$(1)    += -D __MV_RAM_LAYOUT_DEFS_FROM_XML__
MV_RAM_DEFS_FILE.$(1) := $$(SOFIA_FIRMWARE_OUT.$(1))/ram_layout.h
MV_CONFIG_RAM_DEFS_DEST_FILE.$(1) := $$(MV_CONFIG_BUILD_OUT.$(1))/ram_layout.h
endif


###########################
# create rules
###########################
.PHONY : force
force: ;

ifeq ($$(GEN_MV_RAM_DEFS_FROM_XML), true)
$$(MV_CONFIG_RAM_DEFS_DEST_FILE.$(1)) : force | $$(MV_CONFIG_BUILD_OUT.$(1)) prg
	if [ -a $$(MV_RAM_DEFS_FILE.$(1)) ]; \
	then diff  $$(MV_RAM_DEFS_FILE.$(1)) $$(MV_CONFIG_RAM_DEFS_DEST_FILE.$(1)) || cp -f $$(MV_RAM_DEFS_FILE.$(1)) $$(MV_CONFIG_RAM_DEFS_DEST_FILE.$(1)); \
	else echo "Error: Required ram layout file $$(MV_RAM_DEFS_FILE.$(1)) was not found!"; exit 1; \
	fi
endif


$$(foreach t,$$(MV_CONFIG_TYPE.$(1)),$$(eval $$(call CREATE_MV_CONFIG_XML_RULES,$(1),$$(t))))

$$(MV_CONFIG_BUILD_OUT.$(1))/%.bin: $$(MV_CONFIG_BUILD_OUT.$(1))/%.xml | $$(MV_CONFIG_BUILD_OUT.$(1))
	@$$(MOBILEVISOR_REL_PATH)/tools/mvconfig $$< $$@

$$(MV_CONFIG_FLS_OUTPUT.$(1))/mvconfig_%.fls : $$(MV_CONFIG_BUILD_OUT.$(1))/mvconfig_%.bin $$(FLASHLOADER_FLS.$(1)) | $$(MV_CONFIG_FLS_OUTPUT.$(1))
	@$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) \
	           --output $$@ \
		   --tag MV_CONFIG \
		   $$(INJECT_FLASHLOADER_FLS.$(1)) \
		   $$< \
		   --replace --to-fls2

$$(FLASHFILES_DIR.$(1))/mvconfig_%.fls: $$(MV_CONFIG_FLS_OUTPUT.$(1))/mvconfig_%.fls
	$$(copy-file-to-new-target)

$$(MV_CONFIG_BUILD_OUT.$(1)):
	@mkdir -p $$(MV_CONFIG_BUILD_OUT.$(1))

endef

$(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),\
	$(eval $(call mobilevisor_config_per_variant,$(variant))))

$(foreach mvvariant,$(MV_CONFIG_TYPE.$(firstword $(SOFIA_FIRMWARE_VARIANTS))),\
	$(eval .PHONY: mvconfig_$(mvvariant).fls)\
	$(eval mvconfig_$(mvvariant).fls: $(addprefix mvconfig_$(mvvariant).fls.,$(SOFIA_FIRMWARE_VARIANTS))))

mvconfig_info:
	@echo "---------------------------------------------------------------------"
	@echo "Mobilevisor:"
	@echo "-make mvconfig_up.fls     : Will generate mobilevisor configuration fls file with UP settings."
	@echo "-make mvconfig_smp.fls    : Will generate mobilevisor configuration fls file with SMP settings."	

build_info: mvconfig_info

endif
