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

MODEM_BIN_LOAD_PATH := $(TARGET_OUT)/vendor/firmware
MODEM_INSTALL_PATH := $(MODEM_BIN_LOAD_PATH)/modem.fls_ID0_CUST_LoadMap0.bin

FIRMWARE_SYMBOLS_PATH := $(wildcard hardware/intel/$(TARGET_BOARD_PLATFORM)-fls/$(TARGET_DEVICE)/symbols/*.elf)
FIRMWARE_SYMBOLS_FILE := $(TARGET_DEVICE)-symbols_firmware-$(BUILD_NUMBER).zip

define modem_per_variant

ifeq ($(BUILD_MODEM_FROM_SRC),true)

MODEM_MAKEDIR.$(1) := $$(SOFIA_FIRMWARE_OUT.$(1))/modem_build
BUILT_MODEM.$(1)   := $$(MODEM_MAKEDIR.$(1))/$$(MODEM_PROJECTNAME_VAR).ihex

MODEM_BUILD_ARGUMENTS.$(1) ?= $(MODEM_BUILD_ARGUMENTS)
ifeq ($$(USER),tcloud)
ifeq ($$(findstring sofia3g,$$(TARGET_BOARD_PLATFORM)),sofia3g)
MODEM_BUILD_ARGUMENTS.$(1) += SDLROOT=$$(SOFIA_FW_SRC_BASE)/modem/system-build/HW_SIC
else
MODEM_BUILD_ARGUMENTS.$(1) += SDLROOT=$$(SOFIA_FW_SRC_BASE)/modem/system-build/HW_LTE_TDS
endif
else
MODEM_BUILD_ARGUMENTS.$(1) += SDLROOT=$$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))/sdlcode)
endif  #endif $$(USER) = tcloud

$$(BUILT_MODEM.$(1)): build_modem_hex.$(1)

ifeq ($$(BUILD_3GFW_FROM_SRC),true)

GEN_3G_FW_STT_FILE.$(1) :=  $$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))/3gfw/swtdus_swtools/sttdecoder_3gfw/make_sttdecoder/bin/hybrid_image/ming_rel/sttdecoder_3gfw.dll)

3GFW_GEN_PATH.$(1) := $$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))/3gfw/umts_fw_dev/firmware/bin/ram_image/rvds_dbg)

$$(GEN_3G_FW_C_FILE.$(1)): gen_3gfw
$$(GEN_3G_FW_STT_FILE.$(1)): gen_3gfw_stt

.PHONY: gen_3gfw.$(1)
ifeq ($$(findstring sofia3g,$$(TARGET_BOARD_PLATFORM)),sofia3g)
gen_3gfw.$(1):
	$$(MAKE) -C $$(FW3G_SRC_PATH) CFG=RVDS_DBG UBN=0 RBN=030 TARGET_PRODUCT=$$(FW3G_PRODUCT) OUTPUTDIR=$$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))/3gfw) ram_image_nc
else
gen_3gfw.$(1):
	$$(MAKE) -C $$(FW3G_SRC_PATH) CFG=RVDS_DBG UBN=0 RBN=030 TARGET_PRODUCT=$$(FW3G_PRODUCT) OUTPUTDIR=$$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))/3gfw) rom_image
	$$(MAKE) -C $$(FW3G_SRC_PATH) CFG=RVDS_DBG UBN=0 RBN=030 TARGET_PRODUCT=$$(FW3G_PRODUCT) OUTPUTDIR=$$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))/3gfw) ram_image_nc
endif

.PHONY: gen_3gfw_stt.$(1)
gen_3gfw_stt.$(1): gen_3gfw.$(1)
	$$(MAKE) -C $$(FW3G_SRC_PATH) CFG=MING_REL UBN=0 RBN=030 TARGET_PRODUCT=$$(FW3G_PRODUCT) OUTPUTDIR=$$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))/3gfw) stt_decoder


ifeq ($$(TARGET_BUILD_VARIANT),eng)
build_modem_hex.$(1): gen_3gfw_stt.$(1)
else
build_modem_hex.$(1): gen_3gfw.$(1)
endif
endif #endif $$(BUILD_3GFW_FROM_SRC) = true

.PHONY: modem_createdirs.$(1)
modem_createdirs.$(1):
	$$(MAKE) -s -C $$(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$$(MODEM_PROJECTNAME_VAR) PLATFORM=$$(MODEM_PLATFORM) $$(MODEM_BUILD_ARGUMENTS.$(1)) MAKEDIR=$$(MODEM_MAKEDIR.$(1)) createdirs

.PHONY: modem_config.$(1)
modem_config.$(1): modem_createdirs.$(1)
	$$(MAKE) -s -C $$(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$$(MODEM_PROJECTNAME_VAR) PLATFORM=$$(MODEM_PLATFORM) $$(MODEM_BUILD_ARGUMENTS.$(1)) MAKEDIR=$$(MODEM_MAKEDIR.$(1)) config

.PHONY: sdlgeninit.$(1)
sdlgeninit.$(1): modem_config.$(1)
	$$(MAKE) -s -C $$(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$$(MODEM_PROJECTNAME_VAR) PLATFORM=$$(MODEM_PLATFORM) $$(MODEM_BUILD_ARGUMENTS.$(1)) MAKEDIR=$$(MODEM_MAKEDIR.$(1)) runsdlcmd

.PHONY: sdlgencode.$(1)
sdlgencode.$(1): sdlgeninit.$(1)
	$$(MAKE) -s -C $$(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$$(MODEM_PROJECTNAME_VAR) PLATFORM=$$(MODEM_PLATFORM) $$(MODEM_BUILD_ARGUMENTS.$(1)) MAKEDIR=$$(MODEM_MAKEDIR.$(1)) SDLSCR=YES SDLCODEGEN=YES runsdlscr

.PHONY: build_modem_hex.$(1)
ifeq ($$(USER),tcloud)
build_modem_hex.$(1): modem_config.$(1)
	$$(MAKE) -s -C $$(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$$(MODEM_PROJECTNAME_VAR) PLATFORM=$$(MODEM_PLATFORM) $$(MODEM_BUILD_ARGUMENTS.$(1)) 3GFW_GEN_PATH=$$(3GFW_GEN_PATH.$(1)) MAKEDIR=$$(MODEM_MAKEDIR.$(1))
else
build_modem_hex.$(1): sdlgencode.$(1)
	$$(MAKE) -s -C $$(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$$(MODEM_PROJECTNAME_VAR) PLATFORM=$$(MODEM_PLATFORM) $$(MODEM_BUILD_ARGUMENTS.$(1)) 3GFW_GEN_PATH=$$(3GFW_GEN_PATH.$(1)) MAKEDIR=$$(MODEM_MAKEDIR.$(1))
endif

modem_info:
	@echo "-----------------------------------------------------"
	@echo "Modem:"
	@echo "-make modem.fls : Will build the Virtualized Modem configuration and generate fls file"
	@echo "-make sdlgencode : Will generate Protocol Stack SDL Code"

build_info: modem_info

endif #endif $$(BUILD_MODEM_FROM_SRC) = true

BUILT_MODEM.$(1) ?= $(BUILT_MODEM)

MODEM_FLS.$(1)  := $$(FLASHFILES_DIR.$(1))/modem.fls
SOFIA_PROVDATA_FILES.$(1) += $$(MODEM_FLS.$(1))

PSI_FLASH_FLS.$(1) ?= $$(FLASHFILES_DIR.$(1))/psi_flash.fls
SLB_FLS.$(1) ?= $$(FLASHFILES_DIR.$(1))/slb.fls
MOBILEVISOR_FLS.$(1) ?= $$(FLASHFILES_DIR.$(1))/mobilevisor.fls
SECVM_FLS.$(1) ?= $$(FLASHFILES_DIR.$(1))/secvm.fls
SPLASH_IMG_FLS.$(1) ?= $$(FLASHFILES_DIR.$(1))/splash_img.fls
UCODE_PATCH_FLS.$(1) ?= $$(FLASHFILES_DIR.$(1))/ucode_patch.fls
SOFIA_PROVDATA_FILES.$(1) += $$(PSI_FLASH_FLS.$(1)) $$(SLB_FLS.$(1)) $$(MOBILEVISOR_FLS.$(1)) $$(SECVM_FLS.$(1)) $$(SPLASH_IMG_FLS.$(1)) $$(UCODE_PATCH_FLS.$(1))

#ifeq ($$(TARGET_BOARD_PLATFORM),sofia_lte)
#DSP_IMAGE_FLS.$(1) := $$(FLASHFILES_DIR.$(1))/dsp_image.fls
#LTE_FLS.$(1) := $$(FLASHFILES_DIR.$(1))/lte.fls
#IMC_FW_BLOCK_1.$(1) := $$(FLASHFILES_DIR.$(1))/imc_fw_block_1.fls
#IMC_FW_BLOCK_2.$(1) := $$(FLASHFILES_DIR.$(1))/imc_fw_block_2.fls
#IMC_BOOTLOADER_A.$(1) := $$(FLASHFILES_DIR.$(1))/imc_bootloader_a.fls
#IMC_BOOTLOADER_B.$(1) := $$(FLASHFILES_DIR.$(1))/imc_bootloader_b.fls
#SOFIA_PROVDATA_FILES.$(1) += $$(DSP_IMAGE_FLS.$(1)) $$(LTE_FLS.$(1)) $$(IMC_FW_BLOCK_1.$(1)) $$(IMC_FW_BLOCK_2.$(1)) $$(IMC_BOOTLOADER_A.$(1)) $$(IMC_BOOTLOADER_B.$(1))
#endif

MODEM_FLS.$(1)  := $$(FLASHFILES_DIR.$(1))/modem.fls
ANDROID_SIGNED_FLS_LIST.$(1) += $$(SIGN_FLS_DIR.$(1))/modem_signed.fls
#ifeq ($$(TARGET_BOARD_PLATFORM),sofia_lte)
#ANDROID_SIGNED_FLS_LIST.$(1) += $$(SIGN_FLS_DIR.$(1))/dsp_image_signed.fls
#ANDROID_SIGNED_FLS_LIST.$(1) += $$(SIGN_FLS_DIR.$(1))/lte_signed.fls
#ANDROID_SIGNED_FLS_LIST.$(1) += $$(SIGN_FLS_DIR.$(1))/imc_fw_block_1_signed.fls
#ANDROID_SIGNED_FLS_LIST.$(1) += $$(SIGN_FLS_DIR.$(1))/imc_fw_block_2_signed.fls
#ANDROID_SIGNED_FLS_LIST.$(1) += $$(SIGN_FLS_DIR.$(1))/imc_bootloader_a_signed.fls
#ANDROID_SIGNED_FLS_LIST.$(1) += $$(SIGN_FLS_DIR.$(1))/imc_bootloader_b_signed.fls
#endif

ifeq ($$(findstring sofia3g,$$(TARGET_BOARD_PLATFORM)),sofia3g)
.INTERMEDIATE: $$(MODEM_FLS.$(1))
.INTERMEDIATE: $$(SIGN_FLS_DIR.$(1))/modem_signed.fls

ifneq ($$(BOARD_USE_FLS_PREBUILTS),$$(TARGET_DEVICE))
$$(MODEM_FLS.$(1)): $$(BUILT_MODEM.$(1)) $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(FLASHLOADER_FLS.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$@ --tag MODEM_IMG $$(INJECT_FLASHLOADER_FLS.$(1)) $$(BUILT_MODEM.$(1)) --replace --to-fls2
endif # BOARD_USE_FLS_PREBUILTS != true

BUILT_MODEM_DATA_EXT.$(1) := $$(EXTRACT_TEMP.$(1))/modem/modem.fls_ID0_CUST_LoadMap0.bin

$$(BUILT_MODEM_DATA_EXT.$(1)) : $$(EXTRACT_TEMP.$(1))/modem

.PHONY : force
force: ;

$$(EXTRACT_TEMP.$(1))/modem : $$(MODEM_FLS.$(1)) force
	$$(FLSTOOL) -o $$(EXTRACT_TEMP.$(1))/modem -x $$(MODEM_FLS.$(1))

else

ifneq ($$(BOARD_USE_FLS_PREBUILTS),$$(TARGET_DEVICE))
.PHONY: modem.fls
$$(MODEM_FLS.$(1)): $$(BUILT_MODEM.$(1)) $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(FLASHLOADER_FLS.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$@ --tag MODEM_IMG $$(INJECT_FLASHLOADER_FLS.$(1)) $$(BUILT_MODEM.$(1)) --replace --to-fls2
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$(FLASHFILES_DIR.$(1))/dsp_image.fls --tag DSP_IMAGE $$(INJECT_FLASHLOADER_FLS.$(1)) $$(BUILT_MODEM.$(1)) --replace --to-fls2
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$(FLASHFILES_DIR.$(1))/lte.fls --tag LTE $$(INJECT_FLASHLOADER_FLS.$(1)) $$(LTE_BIN.$(1)) --replace --to-fls2
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$(FLASHFILES_DIR.$(1))/imc_fw_block_1.fls --tag LC_FW1 $$(INJECT_FLASHLOADER_FLS.$(1)) $$(LC_FW1_BIN.$(1))  --replace --to-fls2
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$(FLASHFILES_DIR.$(1))/imc_fw_block_2.fls --tag LC_FW2 $$(INJECT_FLASHLOADER_FLS.$(1)) $$(LC_FW2_BIN.$(1)) --replace --to-fls2
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$(FLASHFILES_DIR.$(1))/imc_bootloader_a.fls --tag MINI_BL_1 $$(INJECT_FLASHLOADER_FLS.$(1)) $$(MINI_BL1_BIN.$(1)) --replace --to-fls2
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$(FLASHFILES_DIR.$(1))/imc_bootloader_b.fls --tag MINI_BL_2 $$(INJECT_FLASHLOADER_FLS.$(1)) $$(MINI_BL2_BIN.$(1)) --replace --to-fls2
else
#modem.fls.$(1): $$(FLASHFILES_DIR.$(1))/dsp_image.fls $$(FLASHFILES_DIR.$(1))/lte.fls $$(FLASHFILES_DIR.$(1))/imc_fw_block_1.fls \
	            $$(FLASHFILES_DIR.$(1))/imc_fw_block_2.fls $$(FLASHFILES_DIR.$(1))/imc_bootloader_a.fls $$(FLASHFILES_DIR.$(1))/imc_bootloader_b.fls
.PHONY: force
force: ;
endif# BOARD_USE_FLS_PREBUILTS != true

ifneq (,$$(BOARD_USE_FLS_PREBUILTS)))
# Generation of txt file containing various convenient information
# about embedded OS agnostic software
OS_AGNOSTIC_FLS.$(1)  := $$(FLASHFILES_DIR.$(1))/modem.fls
OS_AGNOSTIC_INFO.$(1) := $$(FLASHFILES_DIR.$(1))/os_agnostic_info.txt
SOFIA_PROVDATA_FILES.$(1) += $$(OS_AGNOSTIC_INFO.$(1))
$$(OS_AGNOSTIC_INFO.$(1)): $$(OS_AGNOSTIC_FLS.$(1))
	echo -n "OS-agnostic tag: " > $$@
	@strings $$(OS_AGNOSTIC_FLS.$(1)) | grep ^SOFIA_LTE_ >> $$@
	@echo "" >> $$@
	@echo "       1A <-> OC6" >> $$@
	@echo "sltsvbV12 <-> SfLTE_l_fddcat4_v2 (AOSP_LPOP_SVB_V1_2-USERDEBUG)" >> $$@
	@echo "sltsvbV34 <-> SfLTE_l_psvon_v2 (AOSP_LPOP_SVB_V3_4-USERDEBUG)" >> $$@
	@echo "sltmrdV12 <-> SfLTE_l_mrd6p1v12 (AOSP_LPOP_MRD_V12-USERDEBUG)" >> $$@
	@echo "sltmrdV34 <-> SfLTE_l_mrd6_p1 (AOSP_LPOP_MRD_GMS-USERDEBUG)" >> $$@
endif

modem.fls.$(1): $$(MODEM_FLS.$(1))

endif

endef

$(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),\
       $(eval $(call modem_per_variant,$(variant))))

ifeq ($(findstring sofia3g,$(TARGET_BOARD_PLATFORM)),sofia3g)

.PHONY: install_modem
install_modem: $(BUILT_MODEM_DATA_EXT.$(firstword $(SOFIA_FIRMWARE_VARIANTS))) | $(ACP)
	@echo "Installing Modem Data Extract Binary to System Image.."
	$(hide) mkdir -p $(MODEM_BIN_LOAD_PATH)
	$(ACP) $< $(MODEM_INSTALL_PATH)

ifeq ($(TARGET_LOAD_MODEM_DATA_EXTRACT),true)
$(PRODUCT_OUT)/obj/PACKAGING/systemimage_intermediates/system.img: install_modem
endif

.PHONY: modem
modem: $(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),$(BUILT_MODEM_DATA_EXT.$(variant)))

droidcore: modem

else

.PHONY: modem.fls
modem.fls: $(addprefix modem.fls.,$(SOFIA_FIRMWARE_VARIANTS))

droidcore: modem.fls

endif
