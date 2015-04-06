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
PRODUCT_KEYS_DIR  := $(CURDIR)/device/intel/$(TARGET_PROJECT)/security/$(SEC_DIR_PREFIX)_keys
SIGN_SCRIPT_DIR   := $(CURDIR)/device/intel/$(TARGET_PROJECT)/security/$(SEC_DIR_PREFIX)_sign_scripts
ZIP_CERTIFICATE	  := $(CURDIR)/device/intel/$(TARGET_PROJECT)/security/sofia3g_ini.zip

EXTRACT_DIR         := $(SIGN_FLS_DIR)/extract/
PSI_FLASH_SECPACK   := $(EXTRACT_DIR)/psi_flash.fls_ID0_PSI_SecureBlock.bin
SLB_SECPACK         := $(EXTRACT_DIR)/slb.fls_ID0_SLB_SecureBlock.bin
BOOTIMG_SECPACK		:= $(EXTRACT_DIR)/boot.fls_ID0_CUST_SecureBlock.bin
RECOVERY_SECPACK    := $(EXTRACT_DIR)/recovery.fls_ID0_CUST_SecureBlock.bin
MEX_SECPACK		    := $(EXTRACT_DIR)/modem.fls_ID0_CUST_SecureBlock.bin
MOBILEVISOR_SECPACK	:= $(EXTRACT_DIR)/mobilevisor.fls_ID0_CODE_SecureBlock.bin
SPLASH_SECPACK		:= $(EXTRACT_DIR)/splash_img.fls_ID0_CUST_SecureBlock.bin
SECVM_SECPACK		:= $(EXTRACT_DIR)/secvm.fls_ID0_CUST_SecureBlock.bin
MVCONFIG_SECPACK	:= $(EXTRACT_DIR)/mvconfig_smp.fls_ID0_CUST_SecureBlock.bin
UCODE_SECPACK	    := $(EXTRACT_DIR)/ucode_patch.fls_ID0_CUST_SecureBlock.bin
SYSTEM_SECPACK	    := $(EXTRACT_DIR)/system.fls_ID0_CUST_SecureBlock.bin
CACHE_SECPACK	    := $(EXTRACT_DIR)/cache.fls_ID0_CUST_SecureBlock.bin
USERDATA_SECPACK	:= $(EXTRACT_DIR)/userdata.fls_ID0_CUST_SecureBlock.bin

SECPACK_LIST        := $(PSI_FLASH_SECPACK)
SECPACK_LIST        += $(SLB_SECPACK)
SECPACK_LIST        += $(BOOTIMG_SECPACK)
SECPACK_LIST        += $(RECOVERY_SECPACK)
SECPACK_LIST        += $(MEX_SECPACK)
SECPACK_LIST        += $(MOBILEVISOR_SECPACK)
SECPACK_LIST        += $(SPLASH_SECPACK)
SECPACK_LIST        += $(SECVM_SECPACK)
SECPACK_LIST        += $(MVCONFIG_SECPACK)
SECPACK_LIST        += $(UCODE_SECPACK)
SECPACK_LIST        += $(SYSTEM_SECPACK)
SECPACK_LIST        += $(CACHE_SECPACK)
SECPACK_LIST        += $(USERDATA_SECPACK)

## FLS sign
.PHONY: signfls

signfls: create_sign_fls_dir sign_flashloader sign_bootloader sign_system create_vrl_bin

.PHONY: signbs

signbs: create_sign_fls_dir sign_flashloader sign_bootloader

FLASHLOADER_SIGN_SCRIPT := $(SIGN_SCRIPT_DIR)/flashloader.signing_script.txt
PSI_RAM_SIGNED_FLS      := $(CURDIR)/$(PRODUCT_OUT)/flashloader/psi_ram_signed.fls
EBL_SIGNED_FLS          := $(CURDIR)/$(PRODUCT_OUT)/flashloader/ebl_signed.fls
VRL_BIN                 := $(SIGN_FLS_DIR)/vrl.bin

INJECT_SIGNED_FLASHLOADER_FLS  = --psi $(PSI_RAM_SIGNED_FLS) --ebl $(EBL_SIGNED_FLS)

$(PSI_RAM_SIGNED_FLS): $(PSI_RAM_FLS) $(FLASHLOADER_SIGN_SCRIPT) $(FLSTOOL)
	$(FLSTOOL) --sign $(PSI_RAM_FLS) --script $(FLASHLOADER_SIGN_SCRIPT) -o $@ --replace

$(EBL_SIGNED_FLS): $(EBL_FLS) $(FLASHLOADER_SIGN_SCRIPT) $(FLSTOOL) $(PSI_RAM_SIGNED_FLS)
	$(FLSTOOL) --sign $(EBL_FLS) --script $(FLASHLOADER_SIGN_SCRIPT) --psi $(PSI_RAM_SIGNED_FLS) -o $@ --replace

sign_flashloader: create_sign_fls_dir $(PSI_RAM_SIGNED_FLS) $(EBL_SIGNED_FLS)

BOOTLOADER_SIGN_SCRIPT := $(SIGN_SCRIPT_DIR)/bootloader.signing_script.txt
PSI_FLASH_SIGNED_FLS   := $(SIGN_FLS_DIR)/psi_flash_signed.fls
SLB_SIGNED_FLS         := $(SIGN_FLS_DIR)/slb_signed.fls

$(PSI_FLASH_SIGNED_FLS): $(PSI_FLASH_FLS) $(BOOTLOADER_SIGN_SCRIPT) $(FLSTOOL) sign_flashloader
	$(FLSTOOL) --sign $(PSI_FLASH_FLS) --script $(BOOTLOADER_SIGN_SCRIPT) $(INJECT_SIGNED_FLASHLOADER_FLS) --zip $(ZIP_CERTIFICATE) -o $@ --replace
	$(FLSTOOL) -x $@ -o $(EXTRACT_DIR)

$(SLB_SIGNED_FLS): $(SLB_FLS) $(BOOTLOADER_SIGN_SCRIPT) $(FLSTOOL) sign_flashloader
	$(FLSTOOL) --sign $(SLB_FLS) --script $(BOOTLOADER_SIGN_SCRIPT) $(INJECT_SIGNED_FLASHLOADER_FLS) -o $@ --replace
	$(FLSTOOL) -x $@ -o $(EXTRACT_DIR)

sign_bootloader: create_sign_fls_dir sign_flashloader $(PSI_FLASH_SIGNED_FLS) $(SLB_SIGNED_FLS)

SYSTEM_FLS_SIGN_SCRIPT := $(SIGN_SCRIPT_DIR)/system.signing_script.txt

sign_system: create_sign_fls_dir sign_flashloader $(SYSTEM_SIGNED_FLS_LIST)

$(SYSTEM_SIGNED_FLS_LIST): $(SIGN_FLS_DIR)/%_signed.fls: $(FLASHFILES_DIR)/%.fls $(FLSTOOL) $(SYSTEM_FLS_SIGN_SCRIPT) sign_flashloader
	$(FLSTOOL) --sign $< --script $(SYSTEM_FLS_SIGN_SCRIPT) $(INJECT_SIGNED_FLASHLOADER_FLS) -o $@ --replace
	$(FLSTOOL) -x $@ -o $(EXTRACT_DIR)

create_vrl_bin: $(VRL_BIN)

$(VRL_BIN): sign_bootloader sign_system
	cat $(SECPACK_LIST) > $@
