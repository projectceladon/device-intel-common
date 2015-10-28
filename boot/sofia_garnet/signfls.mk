# Copyright (C) 2013-2015 Intel Mobile Communications GmbH
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
#ifneq ($(BOARD_USE_FLS_PREBUILTS),$(TARGET_DEVICE))
signfls_info:
	@echo "----------------------------------------------------------"
	@echo "-make signfls : Will generate all signed fls files"

build_info: signfls_info

ifeq ($(USE_PROD_KEYS),1)
SEC_DIR_PREFIX := prod
else
SEC_DIR_PREFIX := dev
endif

PKCS_COMPLIANT_PSI ?= false

SIGN_TOOL        := $(SOFIA_FW_SRC_BASE)/modem/dwdtools/FlsSign/Linux/FlsSign_E2_Linux
PRODUCT_KEYS_DIR := $(CURDIR)/device/intel/sofia3gr/$(TARGET_DEVICE)/security/$(SEC_DIR_PREFIX)_keys
SIGN_SCRIPT_DIR  := $(CURDIR)/device/intel/sofia3gr/$(TARGET_DEVICE)/security/$(SEC_DIR_PREFIX)_sign_scripts
ZIP_CERTIFICATE  := $(CURDIR)/device/intel/sofia3gr/$(TARGET_DEVICE)/security/$(TARGET_PROJECT)_ini.zip

## FLS sign
.PHONY: signfls
ifeq ($(TARGET_BOARD_PLATFORM), sofia_lte)
# The VRL feature is not supported on SoFIA LTE yet
signfls: signbs sign_system | createflashfile_dir
else
signfls: signbs sign_system sign_vrl | createflashfile_dir
endif

.PHONY: signbs
signbs: sign_bootloader | createflashfile_dir

ifneq ($(PKCS_COMPLIANT_PSI), true)
FLASHLOADER_SIGN_SCRIPT := $(SIGN_SCRIPT_DIR)/flashloader.signing_script.txt
else
FLASHLOADER_SIGN_SCRIPT := $(SIGN_SCRIPT_DIR)/flashloader.signing_script_pkcs_psi.txt
endif

PSI_RAM_SIGNED_FLS      := $(CURDIR)/$(PRODUCT_OUT)/flashloader/psi_ram_signed.fls
EBL_SIGNED_FLS          := $(CURDIR)/$(PRODUCT_OUT)/flashloader/ebl_signed.fls

INJECT_SIGNED_FLASHLOADER_FLS  = --psi $(PSI_RAM_SIGNED_FLS) --ebl $(EBL_SIGNED_FLS)

$(PSI_RAM_SIGNED_FLS): $(PSI_RAM_FLS) $(FLASHLOADER_SIGN_SCRIPT) $(FLSTOOL)
	$(FLSTOOL) --sign $(PSI_RAM_FLS) --script $(FLASHLOADER_SIGN_SCRIPT) -o $@ --replace

$(EBL_SIGNED_FLS): $(EBL_FLS) $(FLASHLOADER_SIGN_SCRIPT) $(FLSTOOL) $(PSI_RAM_SIGNED_FLS)
	$(FLSTOOL) --sign $(EBL_FLS) --script $(FLASHLOADER_SIGN_SCRIPT) --psi $(PSI_RAM_SIGNED_FLS) -o $@ --replace

sign_flashloader: $(PSI_RAM_SIGNED_FLS) $(EBL_SIGNED_FLS) | createflashfile_dir

ifneq ($(PKCS_COMPLIANT_PSI), true)
BOOTLOADER_SIGN_SCRIPT := $(SIGN_SCRIPT_DIR)/bootloader.signing_script.txt
else
BOOTLOADER_SIGN_SCRIPT := $(SIGN_SCRIPT_DIR)/bootloader.signing_script_pkcs_psi.txt
endif

PSI_FLASH_SIGNED_FLS   := $(SIGN_FLS_DIR)/psi_flash_signed.fls
SLB_SIGNED_FLS         := $(SIGN_FLS_DIR)/slb_signed.fls

$(PSI_FLASH_SIGNED_FLS): $(PSI_FLASH_FLS) $(BOOTLOADER_SIGN_SCRIPT) $(FLSTOOL) sign_flashloader
	$(FLSTOOL) --sign $(PSI_FLASH_FLS) --script $(BOOTLOADER_SIGN_SCRIPT) $(INJECT_SIGNED_FLASHLOADER_FLS) --zip $(ZIP_CERTIFICATE) -o $@ --replace

$(SLB_SIGNED_FLS): $(SLB_FLS) $(BOOTLOADER_SIGN_SCRIPT) $(FLSTOOL) sign_flashloader
	$(FLSTOOL) --sign $(SLB_FLS) --script $(BOOTLOADER_SIGN_SCRIPT) $(INJECT_SIGNED_FLASHLOADER_FLS) -o $@ --replace

sign_bootloader: sign_flashloader $(PSI_FLASH_SIGNED_FLS) $(SLB_SIGNED_FLS) | createflashfile_dir

SYSTEM_FLS_SIGN_SCRIPT := $(SIGN_SCRIPT_DIR)/system.signing_script.txt

sign_system: sign_flashloader $(SYSTEM_SIGNED_FLS_LIST) $(ANDROID_SIGNED_FLS_LIST) $(MV_CONFIG_SIGNED_FLS_LIST) | createflashfile_dir

$(SYSTEM_SIGNED_FLS_LIST): $(SIGN_FLS_DIR)/%_signed.fls: $(FLASHFILES_DIR)/%.fls $(FLSTOOL) $(SYSTEM_FLS_SIGN_SCRIPT) sign_flashloader
	$(FLSTOOL) --sign $< --script $(SYSTEM_FLS_SIGN_SCRIPT) $(INJECT_SIGNED_FLASHLOADER_FLS) -o $@ --replace

$(ANDROID_SIGNED_FLS_LIST): $(SIGN_FLS_DIR)/%_signed.fls: $(FLASHFILES_DIR)/%.fls $(FLSTOOL) $(SYSTEM_FLS_SIGN_SCRIPT) sign_flashloader
	$(FLSTOOL) --sign $< --script $(SYSTEM_FLS_SIGN_SCRIPT) $(INJECT_SIGNED_FLASHLOADER_FLS) -o $@ --replace

$(MV_CONFIG_SIGNED_FLS_LIST): $(SIGN_FLS_DIR)/%_signed.fls: $(FLASHFILES_DIR)/%.fls $(FLSTOOL) $(SYSTEM_FLS_SIGN_SCRIPT) sign_flashloader
	$(FLSTOOL) --sign $< --script $(SYSTEM_FLS_SIGN_SCRIPT) $(INJECT_SIGNED_FLASHLOADER_FLS) -o $@ --replace

SOFIA_PROVDATA_FILES += $(PSI_RAM_SIGNED_FLS) $(EBL_SIGNED_FLS)  $(PSI_FLASH_SIGNED_FLS) $(SLB_SIGNED_FLS)  $(SYSTEM_SIGNED_FLS_LIST) $(ANDROID_SIGNED_FLS_LIST) $(SYSTEM_FLS_SIGN_SCRIPT)

## Firmware update
VRL_SIGN_SCRIPT     := $(SIGN_SCRIPT_DIR)/vrl.signing_script.txt
FWU_IMAGE_BIN       := $(FWU_IMG_DIR)/fwu_image.bin
VRL_BIN             := $(FASTBOOT_IMG_DIR)/vrl.bin
VRL_FLS             := $(FLASHFILES_DIR)/vrl.fls
VRL_SIGNED_FLS      := $(SIGN_FLS_DIR)/vrl_signed.fls

.INTERMEDIATE: $(VRL_FLS)

SOFIA_PROVDATA_FILES += $(FWU_IMAGE_BIN)

INSTALLED_RADIOIMAGE_TARGET += $(FWU_IMAGE_BIN)

SECP_EXT := *.fls_ID0_*_SecureBlock.bin
DATA_EXT := *.fls_ID0_*_LoadMap*

define GEN_FIRMWARE_UPDATE_PACK_RULES
$(EXTRACT_TEMP)/$(1): force $(SIGN_FLS_DIR)/$(1).fls | createflashfile_dir
	$(FLSTOOL) -o $(EXTRACT_TEMP)/$(1) -x $(SIGN_FLS_DIR)/$(1).fls
endef

FWU_PACKAGE_LIST  = $(basename $(notdir $(PSI_FLASH_SIGNED_FLS)))
FWU_PACKAGE_LIST += $(basename $(notdir $(SLB_SIGNED_FLS)))
FWU_PACKAGE_LIST += $(basename $(notdir $(SYSTEM_SIGNED_FLS_LIST)))

FWU_PACKAGE_SECPACK_ONLY_LIST += $(basename $(notdir $(ANDROID_SIGNED_FLS_LIST)))

FWU_DEP_LIST := $(addprefix $(EXTRACT_TEMP)/,$(FWU_PACKAGE_LIST))
$(foreach t,$(FWU_PACKAGE_LIST),$(eval $(call GEN_FIRMWARE_UPDATE_PACK_RULES,$(t))))

FWU_DEP_SECPACK_ONLY_LIST := $(addprefix $(EXTRACT_TEMP)/,$(FWU_PACKAGE_SECPACK_ONLY_LIST))
$(foreach t,$(FWU_PACKAGE_SECPACK_ONLY_LIST),$(eval $(call GEN_FIRMWARE_UPDATE_PACK_RULES,$(t))))


FWU_COMMAND = $(foreach a, $(FWU_DEP_LIST), $(FWU_PACK_GENERATE_TOOL) --input $(FWU_IMAGE_BIN) --output $(FWU_IMAGE_BIN)_temp --secpack $(a)/$(SECP_EXT) --data $(a)/$(DATA_EXT); cp $(FWU_IMAGE_BIN)_temp $(FWU_IMAGE_BIN);)
FWU_ADDI_COMMAND = $(foreach a, $(FWU_DEP_SECPACK_ONLY_LIST), $(FWU_PACK_GENERATE_TOOL) --input $(FWU_IMAGE_BIN) --output $(FWU_IMAGE_BIN)_temp --secpack $(a)/$(SECP_EXT) ; cp $(FWU_IMAGE_BIN)_temp $(FWU_IMAGE_BIN);)

.PHONY: fwu_image
fwu_image: $(FWU_DEP_LIST) $(FWU_DEP_SECPACK_ONLY_LIST) fastboot_img | createflashfile_dir
	rm -rf $(FWU_IMAGE_BIN)
	@echo "---------- Generate fwu_image --------------------"
	$(FWU_COMMAND)
	$(FWU_ADDI_COMMAND)
	cp $(EXTRACT_TEMP)/$(basename $(notdir $(PSI_FLASH_SIGNED_FLS)))/$(DATA_EXT) $(FASTBOOT_IMG_DIR)/$(basename $(notdir $(PSI_FLASH_FLS))).bin
	cp $(EXTRACT_TEMP)/$(basename $(notdir $(SLB_SIGNED_FLS)))/$(DATA_EXT) $(FASTBOOT_IMG_DIR)/$(basename $(notdir $(SLB_FLS))).bin
	@rm $(FWU_IMAGE_BIN)_temp
	@echo "---------- Generate fwu_image Done ---------------"

$(FWU_IMAGE_BIN) : fwu_image

#create_vrl_bin: $(VRL_BIN)

#create_vrl_fls: $(VRL_FLS) | create_vrl_bin

sign_vrl: $(VRL_SIGNED_FLS)

$(VRL_BIN): $(FWU_IMAGE_BIN) force | createflashfile_dir
	@echo "---------- Extract VRL Binary --------------------"
	$(FWU_PACK_GENERATE_TOOL) -x $(FWU_IMAGE_BIN) -v $(VRL_BIN)

$(VRL_FLS) : createflashfile_dir $(VRL_BIN) $(FLSTOOL) $(INTEL_PRG_FILE) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag VRL $(VRL_BIN) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2

$(VRL_SIGNED_FLS) :  $(VRL_FLS) $(VRL_SIGN_SCRIPT) $(FLSTOOL) sign_flashloader
	$(FLSTOOL) --sign $(VRL_FLS) --script $(VRL_SIGN_SCRIPT) $(INJECT_SIGNED_FLASHLOADER_FLS) -o $@ --replace
#endif
