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

signfls_info:
	@echo "----------------------------------------------------------"
	@echo "-make signfls : Will generate all signed fls files"


build_info: signfls_info

ifeq ($(USE_PROD_KEYS),1)
SEC_DIR_PREFIX		:= prod
else
SEC_DIR_PREFIX		:= dev
endif

SIGN_TOOL         := $(CURDIR)/modem/dwdtools/FlsSign/Linux/FlsSign_E2_Linux
PRODUCT_KEYS_DIR  := $(CURDIR)/device/intel/$(TARGET_BOARD_PLATFORM)/security/$(SEC_DIR_PREFIX)_keys
SIGN_SCRIPT_DIR   := $(CURDIR)/device/intel/$(TARGET_BOARD_PLATFORM)/security/$(SEC_DIR_PREFIX)_sign_scripts
ZIP_CERTIFICATE	  := $(CURDIR)/device/intel/$(TARGET_BOARD_PLATFORM)/security/$(TARGET_BOARD_PLATFORM)_ini.zip

## FLS sign
.PHONY: signfls

signfls: create_sign_fls_dir sign_flashloader sign_bootloader sign_system

FLASHLOADER_SIGN_SCRIPT := $(SIGN_SCRIPT_DIR)/flashloader.signing_script.txt
PSI_RAM_SIGNED_FLS      := $(CURDIR)/$(PRODUCT_OUT)/flashloader/psi_ram_signed.fls
EBL_SIGNED_FLS          := $(CURDIR)/$(PRODUCT_OUT)/flashloader/ebl_signed.fls

INJECT_SIGNED_FLASHLOADER_FLS  = --psi $(PSI_RAM_SIGNED_FLS) --ebl $(EBL_SIGNED_FLS)

$(PSI_RAM_SIGNED_FLS): $(PSI_RAM_FLS) $(FLASHLOADER_SIGN_SCRIPT) $(SIGN_TOOL)
	$(SIGN_TOOL) $(PSI_RAM_FLS) -s $(FLASHLOADER_SIGN_SCRIPT) -o $@

$(EBL_SIGNED_FLS): $(EBL_FLS) $(FLASHLOADER_SIGN_SCRIPT) $(SIGN_TOOL) $(PSI_RAM_SIGNED_FLS)
	$(SIGN_TOOL) $(EBL_FLS) -s $(FLASHLOADER_SIGN_SCRIPT) --psi $(PSI_RAM_SIGNED_FLS) -o $@

sign_flashloader: create_sign_fls_dir $(PSI_RAM_SIGNED_FLS) $(EBL_SIGNED_FLS)

BOOTLOADER_SIGN_SCRIPT := $(SIGN_SCRIPT_DIR)/bootloader.signing_script.txt
PSI_FLASH_SIGNED_FLS   := $(SIGN_FLS_DIR)/psi_flash_signed.fls
SLB_SIGNED_FLS         := $(SIGN_FLS_DIR)/slb_signed.fls

$(PSI_FLASH_SIGNED_FLS): $(PSI_FLASH_FLS) $(BOOTLOADER_SIGN_SCRIPT) $(SIGN_TOOL)
	$(SIGN_TOOL) $(PSI_FLASH_FLS) -s $(BOOTLOADER_SIGN_SCRIPT) $(INJECT_SIGNED_FLASHLOADER_FLS) --zip $(ZIP_CERTIFICATE) -o $@

$(SLB_SIGNED_FLS): $(SLB_FLS) $(BOOTLOADER_SIGN_SCRIPT) $(SIGN_TOOL)
	$(SIGN_TOOL) $(SLB_FLS) -s $(BOOTLOADER_SIGN_SCRIPT) $(INJECT_SIGNED_FLASHLOADER_FLS) -o $@

sign_bootloader: create_sign_fls_dir sign_flashloader $(PSI_FLASH_SIGNED_FLS) $(SLB_SIGNED_FLS)

SYSTEM_FLS_SIGN_SCRIPT := $(SIGN_SCRIPT_DIR)/system.signing_script.txt

sign_system: create_sign_fls_dir sign_flashloader $(SYSTEM_SIGNED_FLS_LIST)

$(SYSTEM_SIGNED_FLS_LIST): $(SIGN_FLS_DIR)/%_signed.fls: $(FLASHFILES_DIR)/%.fls $(SIGN_TOOL) $(SYSTEM_FLS_SIGN_SCRIPT) sign_flashloader
	$(SIGN_TOOL) $< -s $(SYSTEM_FLS_SIGN_SCRIPT) $(INJECT_SIGNED_FLASHLOADER_FLS) -o $@
