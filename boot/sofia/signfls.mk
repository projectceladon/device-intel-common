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
signfls_info:
	@echo "----------------------------------------------------------"
	@echo "-make signfls : Will generate all signed fls files"

build_info: signfls_info

ifeq ($(USE_PROD_KEYS),1)
SEC_DIR_PREFIX := prod
else
SEC_DIR_PREFIX := dev
endif

SIGN_TOOL        := $(SOFIA_FW_SRC_BASE)/modem/dwdtools/FlsSign/Linux/FlsSign_E2_Linux
PRODUCT_KEYS_DIR := $(CURDIR)/device/intel/$(TARGET_PROJECT)/security/$(SEC_DIR_PREFIX)_keys
SIGN_SCRIPT_DIR  := $(CURDIR)/device/intel/$(TARGET_PROJECT)/security/$(SEC_DIR_PREFIX)_sign_scripts
ZIP_CERTIFICATE  := $(CURDIR)/device/intel/$(TARGET_PROJECT)/security/$(TARGET_PROJECT)_ini.zip
FLASHLOADER_SIGN_SCRIPT := $(SIGN_SCRIPT_DIR)/flashloader.signing_script.txt
BOOTLOADER_SIGN_SCRIPT := $(SIGN_SCRIPT_DIR)/bootloader.signing_script.txt
SYSTEM_FLS_SIGN_SCRIPT := $(SIGN_SCRIPT_DIR)/system.signing_script.txt
VRL_SIGN_SCRIPT     := $(SIGN_SCRIPT_DIR)/vrl.signing_script.txt
SECP_EXT := *.fls_ID0_*_SecureBlock.bin
DATA_EXT := *.fls_ID0_*_LoadMap*

ifeq ($(TARGET_PROJECT), sofia_lte)
FWU_PACK_GENERATE_TOOL = $(CURDIR)/hardware/intel/sofia_lte-fls/tools/fwpgen
endif

define signfls_per_variant

ifeq ($$(TARGET_PROJECT), sofia_lte)
    PSI_RAM_FLS.$(1) = $$(CURDIR)/hardware/intel/sofia_lte-fls/$$(TARGET_DEVICE)/psi_ram.fls
    EBL_FLS.$(1) = $$(CURDIR)/hardware/intel/sofia_lte-fls/$$(TARGET_DEVICE)/ebl.fls
    PSI_FLASH_FLS.$(1) = $$(CURDIR)/hardware/intel/sofia_lte-fls/$$(TARGET_DEVICE)/psi_flash.fls
    SLB_FLS.$(1) = $$(CURDIR)/hardware/intel/sofia_lte-fls/$$(TARGET_DEVICE)/slb.fls
    MV_CONFIG_DEFAULT_TYPE.$(1) = smp
    SYSTEM_SIGNED_FLS_LIST.$(1) = $$(SIGN_FLS_DIR.$(1))/ucode_patch_signed.fls
    SYSTEM_SIGNED_FLS_LIST.$(1) += $$(SIGN_FLS_DIR.$(1))/splash_img_signed.fls
    SYSTEM_SIGNED_FLS_LIST.$(1) += $$(SIGN_FLS_DIR.$(1))/mvconfig_$$(MV_CONFIG_DEFAULT_TYPE.$(1))_signed.fls
    SYSTEM_SIGNED_FLS_LIST.$(1) += $$(SIGN_FLS_DIR.$(1))/mobilevisor_signed.fls
    SYSTEM_SIGNED_FLS_LIST.$(1) += $$(SIGN_FLS_DIR.$(1))/secvm_signed.fls
endif

## FLS sign
.PHONY: signfls.$(1)
ifeq ($$(TARGET_BOARD_PLATFORM), sofia_lte)
# The VRL feature is not supported on SoFIA LTE yet
signfls.$(1): signbs.$(1) sign_system.$(1) | createflashfile_dir
else
signfls.$(1): signbs.$(1) sign_system.$(1) sign_vrl.$(1) | createflashfile_dir
endif

.PHONY: signbs.$(1)
signbs.$(1): sign_bootloader.$(1) | createflashfile_dir

PSI_RAM_SIGNED_FLS.$(1)      := $$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))/flashloader/psi_ram_signed.fls)
EBL_SIGNED_FLS.$(1)          := $$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))/flashloader/ebl_signed.fls)
EBL_UPLOAD_SIGNED_FLS.$(1)   := $$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))/flashloader/ebl_upload_signed.fls)

ifeq ($$(TARGET_BOARD_PLATFORM), sofia_lte)
INJECT_SIGNED_FLASHLOADER_FLS.$(1)  = --psi $$(PSI_RAM_SIGNED_FLS.$(1)) --ebl $$(EBL_SIGNED_FLS.$(1))
else
INJECT_SIGNED_FLASHLOADER_FLS.$(1)  = --psi $$(PSI_RAM_SIGNED_FLS.$(1)) --ebl-sec $$(EBL_SIGNED_FLS.$(1))
endif

$$(PSI_RAM_SIGNED_FLS.$(1)): $$(PSI_RAM_FLS.$(1)) $$(FLASHLOADER_SIGN_SCRIPT) $$(FLSTOOL)
	$$(FLSTOOL) --sign $$(PSI_RAM_FLS.$(1)) --script $$(FLASHLOADER_SIGN_SCRIPT) -o $$@ --replace

ifeq ($$(TARGET_BOARD_PLATFORM), sofia_lte)
$$(EBL_SIGNED_FLS.$(1)): $$(EBL_FLS.$(1)) $$(FLASHLOADER_SIGN_SCRIPT) $$(FLSTOOL) $$(PSI_RAM_SIGNED_FLS.$(1))
	$$(FLSTOOL) --sign $$(EBL_FLS.$(1)) --script $$(FLASHLOADER_SIGN_SCRIPT) --psi $$(PSI_RAM_SIGNED_FLS.$(1)) -o $$@ --replace
else
$$(EBL_SIGNED_FLS.$(1)): $$(EBL_FLS.$(1)) $$(FLASHLOADER_SIGN_SCRIPT) $$(FLSTOOL) $$(PSI_RAM_SIGNED_FLS.$(1))
	$$(FLSTOOL) --sign $$(EBL_FLS.$(1)) --script $$(FLASHLOADER_SIGN_SCRIPT) -o $$@ --replace

$$(EBL_UPLOAD_SIGNED_FLS.$(1)): $$(EBL_SIGNED_FLS.$(1))
	$$(FLSTOOL) --sign $$(EBL_FLS.$(1)) --script $$(FLASHLOADER_SIGN_SCRIPT) $$(INJECT_SIGNED_FLASHLOADER_FLS.$(1)) -o $$@ --replace
endif

ifeq ($$(TARGET_BOARD_PLATFORM), sofia_lte)
sign_flashloader.$(1): $$(PSI_RAM_SIGNED_FLS.$(1)) $$(EBL_SIGNED_FLS.$(1)) | createflashfile_dir
else
sign_flashloader.$(1): $$(PSI_RAM_SIGNED_FLS.$(1)) $$(EBL_UPLOAD_SIGNED_FLS.$(1)) | createflashfile_dir
endif

PSI_FLASH_SIGNED_FLS.$(1)   := $$(SIGN_FLS_DIR.$(1))/psi_flash_signed.fls
SLB_SIGNED_FLS.$(1)         := $$(SIGN_FLS_DIR.$(1))/slb_signed.fls

$$(PSI_FLASH_SIGNED_FLS.$(1)): $$(PSI_FLASH_FLS.$(1)) $$(BOOTLOADER_SIGN_SCRIPT) $$(FLSTOOL) sign_flashloader.$(1)
	$$(FLSTOOL) --sign $$(PSI_FLASH_FLS.$(1)) --script $$(BOOTLOADER_SIGN_SCRIPT) $$(INJECT_SIGNED_FLASHLOADER_FLS.$(1)) --zip $$(ZIP_CERTIFICATE) -o $$@ --replace

$$(SLB_SIGNED_FLS.$(1)): $$(SLB_FLS.$(1)) $$(BOOTLOADER_SIGN_SCRIPT) $$(FLSTOOL) sign_flashloader.$(1)
	$$(FLSTOOL) --sign $$(SLB_FLS.$(1)) --script $$(BOOTLOADER_SIGN_SCRIPT) $$(INJECT_SIGNED_FLASHLOADER_FLS.$(1)) -o $$@ --replace

sign_bootloader.$(1): sign_flashloader.$(1) $$(PSI_FLASH_SIGNED_FLS.$(1)) $$(SLB_SIGNED_FLS.$(1)) | createflashfile_dir

sign_system.$(1): sign_flashloader.$(1) $$(SYSTEM_SIGNED_FLS_LIST.$(1)) $$(ANDROID_SIGNED_FLS_LIST.$(1)) $$(MV_CONFIG_SIGNED_FLS_LIST.$(1)) | createflashfile_dir

$$(SYSTEM_SIGNED_FLS_LIST.$(1)): $$(SIGN_FLS_DIR.$(1))/%_signed.fls: $$(FLASHFILES_DIR.$(1))/%.fls $$(FLSTOOL) $$(SYSTEM_FLS_SIGN_SCRIPT) sign_flashloader.$(1)
	$$(FLSTOOL) --sign $$< --script $$(SYSTEM_FLS_SIGN_SCRIPT) $$(INJECT_SIGNED_FLASHLOADER_FLS.$(1)) -o $$@ --replace

$$(ANDROID_SIGNED_FLS_LIST.$(1)): $$(SIGN_FLS_DIR.$(1))/%_signed.fls: $$(FLASHFILES_DIR.$(1))/%.fls $$(FLSTOOL) $$(SYSTEM_FLS_SIGN_SCRIPT) sign_flashloader.$(1)
	$$(FLSTOOL) --sign $$< --script $$(SYSTEM_FLS_SIGN_SCRIPT) $$(INJECT_SIGNED_FLASHLOADER_FLS.$(1)) -o $$@ --replace

$$(MV_CONFIG_SIGNED_FLS_LIST.$(1)): $$(SIGN_FLS_DIR.$(1))/%_signed.fls: $$(FLASHFILES_DIR.$(1))/%.fls $$(FLSTOOL) $$(SYSTEM_FLS_SIGN_SCRIPT) sign_flashloader.$(1)
	$$(FLSTOOL) --sign $$< --script $$(SYSTEM_FLS_SIGN_SCRIPT) $$(INJECT_SIGNED_FLASHLOADER_FLS.$(1)) -o $$@ --replace

SOFIA_PROVDATA_FILES.$(1) += $$(PSI_RAM_SIGNED_FLS.$(1)) $$(EBL_SIGNED_FLS.$(1))  $$(PSI_FLASH_SIGNED_FLS.$(1)) $$(SLB_SIGNED_FLS.$(1))  $$(SYSTEM_SIGNED_FLS_LIST.$(1)) $$(ANDROID_SIGNED_FLS_LIST.$(1))

## Firmware update
FWU_IMAGE_BIN.$(1)       := $$(FWU_IMG_DIR.$(1))/fwu_image.bin
FWU_IMAGE_FLS.$(1)       := $$(FLASHFILES_DIR.$(1))/fwu_image.fls
FWU_IMAGE_SIGNED_FLS.$(1):= $$(SIGN_FLS_DIR.$(1))/fwu_image_signed.fls
VRL_BIN.$(1)             := $$(FASTBOOT_IMG_DIR.$(1))/vrl.bin
VRL_FLS.$(1)             := $$(FLASHFILES_DIR.$(1))/vrl.fls
VRL_SIGNED_FLS.$(1)      := $$(SIGN_FLS_DIR.$(1))/vrl_signed.fls

.INTERMEDIATE: $$(VRL_FLS.$(1))

SOFIA_PROVDATA_FILES.$(1) += $$(FWU_IMAGE_BIN.$(1))
SOFIA_PROVDATA_FILES.$(1) += $$(FWU_IMAGE_SIGNED_FLS.$(1))

define GEN_FIRMWARE_UPDATE_PACK_RULES
$$(EXTRACT_TEMP.$(1))/$$(1): force $$(SIGN_FLS_DIR.$(1))/$$(1).fls | createflashfile_dir
	$$(FLSTOOL) -o $$(EXTRACT_TEMP.$(1))/$$(1) -x $$(SIGN_FLS_DIR.$(1))/$$(1).fls
endef

FWU_PACKAGE_LIST.$(1)  = $$(basename $$(notdir $$(PSI_FLASH_SIGNED_FLS.$(1))))
FWU_PACKAGE_LIST.$(1) += $$(basename $$(notdir $$(SLB_SIGNED_FLS.$(1))))
FWU_PACKAGE_LIST.$(1) += $$(basename $$(notdir $$(SYSTEM_SIGNED_FLS_LIST.$(1))))

#remove boot/recovery and mv configs other than the default one from the fwu_image
#boot_signed and recovery_signed images will remain in the out/../fls/signed_fls build output, same as the non default mv configuration files.
FWU_PACKAGE_BIN_LIST.$(1) := $$(filter-out boot_signed recovery_signed, $$(FWU_PACKAGE_LIST.$(1)))
MV_CONFIG_NOT_DEFAULT := $$(addprefix mvconfig_,$$(addsuffix _signed,$$(filter-out $$(MV_CONFIG_DEFAULT_TYPE),$$(MV_CONFIG_TYPE))))
FWU_PACKAGE_BIN_LIST.$(1) := $$(filter-out $$(MV_CONFIG_NOT_DEFAULT), $$(FWU_PACKAGE_BIN_LIST.$(1)))

FWU_PACKAGE_SECPACK_ONLY_LIST.$(1) += $$(basename $$(notdir $$(ANDROID_SIGNED_FLS_LIST.$(1))))

FWU_DEP_LIST.$(1) := $$(addprefix $$(EXTRACT_TEMP.$(1))/,$$(FWU_PACKAGE_LIST.$(1)))
$$(foreach t,$$(FWU_PACKAGE_LIST.$(1)),$$(eval $$(call GEN_FIRMWARE_UPDATE_PACK_RULES,$$(t))))

FWU_DEP_SECPACK_ONLY_LIST.$(1) := $$(addprefix $$(EXTRACT_TEMP.$(1))/,$$(FWU_PACKAGE_SECPACK_ONLY_LIST.$(1)))
$$(foreach t,$$(FWU_PACKAGE_SECPACK_ONLY_LIST.$(1)),$$(eval $$(call GEN_FIRMWARE_UPDATE_PACK_RULES,$$(t))))

FWU_DEP_BIN_LIST.$(1) := $$(addprefix $$(EXTRACT_TEMP.$(1))/,$$(FWU_PACKAGE_BIN_LIST.$(1)))

FWU_COMMAND.$(1) = $$(foreach a, $$(FWU_DEP_BIN_LIST.$(1)), $$(FWU_PACK_GENERATE_TOOL) --input $$(FWU_IMAGE_BIN.$(1)) --output $$(FWU_IMAGE_BIN.$(1))_temp --secpack $$(a)/$$(SECP_EXT) --data $$(a)/$$(DATA_EXT); cp $$(FWU_IMAGE_BIN.$(1))_temp $$(FWU_IMAGE_BIN.$(1));)
FWU_ADDI_COMMAND.$(1) = $$(foreach a, $$(FWU_DEP_SECPACK_ONLY_LIST.$(1)), $$(FWU_PACK_GENERATE_TOOL) --input $$(FWU_IMAGE_BIN.$(1)) --output $$(FWU_IMAGE_BIN.$(1))_temp --secpack $$(a)/$$(SECP_EXT) ; cp $$(FWU_IMAGE_BIN.$(1))_temp $$(FWU_IMAGE_BIN.$(1));)

$$(FWU_IMAGE_BIN.$(1)): $$(FWU_DEP_LIST.$(1)) $$(FWU_DEP_SECPACK_ONLY_LIST.$(1)) fastboot_img.$(1) | createflashfile_dir
	@echo "---------- Generate fwu_image --------------------"
	$$(FWU_COMMAND.$(1))
	$$(FWU_ADDI_COMMAND.$(1))
	cp $$(EXTRACT_TEMP.$(1))/$$(basename $$(notdir $$(PSI_FLASH_SIGNED_FLS.$(1))))/$$(DATA_EXT) $$(FASTBOOT_IMG_DIR.$(1))/$$(basename $$(notdir $$(PSI_FLASH_FLS.$(1)))).bin
	cp $$(EXTRACT_TEMP.$(1))/$$(basename $$(notdir $$(SLB_SIGNED_FLS.$(1))))/$$(DATA_EXT) $$(FASTBOOT_IMG_DIR.$(1))/$$(basename $$(notdir $$(SLB_FLS.$(1)))).bin
	@rm $$(FWU_IMAGE_BIN.$(1))_temp
	@echo "---------- Generate fwu_image Done ---------------"

.PHONY: fwu_image.$(1)
fwu_image.$(1): $$(FWU_IMAGE_BIN.$(1))

$$(FWU_IMAGE_FLS.$(1)):  createflashfile_dir $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(FWU_IMAGE_BIN.$(1)) $$(FLASHLOADER_FLS.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$@ --tag FW_UPDATE $$(INJECT_FLASHLOADER_FLS.$(1)) $$(FWU_IMAGE_BIN.$(1)) --replace --to-fls2

SOFIA_PROVDATA_FILES.$(1) += $$(FWU_IMAGE_FLS.$(1))

#create_vrl_bin: $$(VRL_BIN)

#create_vrl_fls: $$(VRL_FLS) | create_vrl_bin

sign_vrl.$(1): $$(VRL_SIGNED_FLS.$(1))

$$(VRL_BIN.$(1)): $$(FWU_IMAGE_BIN.$(1)) force | createflashfile_dir
	@echo "---------- Extract VRL Binary --------------------"
	$$(FWU_PACK_GENERATE_TOOL) -x $$(FWU_IMAGE_BIN.$(1)) -v $$(VRL_BIN.$(1))

$$(VRL_FLS.$(1)) : createflashfile_dir $$(VRL_BIN.$(1)) $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(FLASHLOADER_FLS.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$@ --tag VRL $$(VRL_BIN.$(1)) $$(INJECT_FLASHLOADER_FLS.$(1)) --replace --to-fls2

$$(VRL_SIGNED_FLS.$(1)) :  $$(VRL_FLS.$(1)) $$(VRL_SIGN_SCRIPT) $$(FLSTOOL) sign_flashloader.$(1)
	$$(FLSTOOL) --sign $$(VRL_FLS.$(1)) --script $$(VRL_SIGN_SCRIPT) $$(INJECT_SIGNED_FLASHLOADER_FLS.$(1)) -o $$@ --replace

$$(FWU_IMAGE_SIGNED_FLS.$(1)) :  $$(FWU_IMAGE_FLS.$(1)) $$(SYSTEM_FLS_SIGN_SCRIPT) $$(FLSTOOL) sign_flashloader.$(1)
	$$(FLSTOOL) --sign $$< --script $$(SYSTEM_FLS_SIGN_SCRIPT) $$(INJECT_SIGNED_FLASHLOADER_FLS.$(1)) -o $$@ --replace

endef

$(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),\
       $(eval $(call signfls_per_variant,$(variant))))

PSI_RAM_SIGNED_FLS := $(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),$(PSI_RAM_SIGNED_FLS.$(variant)))
EBL_SIGNED_FLS := $(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),$(EBL_SIGNED_FLS.$(variant)))

.PHONY: 
signfls: $(addprefix signfls.,$(SOFIA_FIRMWARE_VARIANTS))
