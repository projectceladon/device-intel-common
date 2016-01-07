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

ifeq ($(BUILD_BOOTCORE_FROM_SRC),true)

SIGN_TOOL       := $(SOFIA_FW_SRC_BASE)/modem/dwdtools/FlsSign/Linux/FlsSign_E2_Linux
KEYSTORE_SIGNER := $(ANDROID_BUILD_TOP)/$(HOST_OUT_EXECUTABLES)/keystore_signer
DTC             := $(LOCAL_KERNEL_PATH)/dtc

ifeq ($(BUILD_REL10_BOOTCORE), true)
UCODE_PATCH_PRG_TAG=UCODE_PATCH
else
UCODE_PATCH_PRG_TAG=UC_PATCH
endif

define bootcore_per_variant

ifneq (1,$(words $(SOFIA_FIRMWARE_VARIANTS)))
BOOTCORE_FEATURES.$(1) += FEAT_DTB_FROM_BLOBSTORE
BLOBSTORE_FINGERPRINT.$(1) := $$(shell python $$(BOARD_DEVICE_MAPPING) $(1) ${TARGET_PRODUCT_FISHNAME})
endif

BOOTLDR_TMP_DIR.$(1)       := $$(SOFIA_FIRMWARE_OUT.$(1))/bootloader_tmp

ifeq '$$(findstring $$(MODEM_PROJECTNAME),$${MODEM_PLATFORM})' '$$(MODEM_PROJECTNAME)'
  BOOTLOADER_BIN_PATH.$(1) := $${SOFIA_FIRMWARE_OUT.$(1)}/bootloader/$${MODEM_PLATFORM}
else
  BOOTLOADER_BIN_PATH.$(1) := $${SOFIA_FIRMWARE_OUT.$(1)}/bootloader/$$(MODEM_PROJECTNAME)_$$(MODEM_PLATFORM)
endif

BOOTLOADER_BIN_PATH := $$(BOOTLOADER_BIN_PATH.$(1))

ifeq ($$(BUILD_REL10_BOOTCORE), true)
  BUILT_PSI_RAM_HEX.$(1)     := $$(BOOTLOADER_BIN_PATH.$(1))/target_psi_ram/psi_ram.hex
  BUILT_PSI_RAM_XOR.$(1)     := $$(BOOTLOADER_BIN_PATH.$(1))/scripts/psi_ram.xor_script.txt
  BUILT_PSI_RAM_VER.$(1)     := $$(BOOTLOADER_BIN_PATH.$(1))/project.cfg.log
  BUILT_PSI_RAM_ELF.$(1)     := $$(BOOTLOADER_BIN_PATH.$(1))/target_psi_ram/psi_ram.elf
  BUILT_PSI_FLASH_HEX.$(1)   := $$(BOOTLOADER_BIN_PATH.$(1))/target_psi_flash/psi_flash.hex
  BUILT_PSI_FLASH_XOR.$(1)   := $$(BOOTLOADER_BIN_PATH.$(1))/scripts/psi_flash.xor_script.txt
  BUILT_PSI_FLASH_VER.$(1)   := $$(BOOTLOADER_BIN_PATH.$(1))/project.cfg.log
  BUILT_PSI_FLASH_ELF.$(1)   := $$(BOOTLOADER_BIN_PATH.$(1))/target_psi_flash/psi_flash.elf
  BUILT_EBL_HEX.$(1)         := $$(BOOTLOADER_BIN_PATH.$(1))/target_ebl/ebl.hex
  BUILT_EBL_VER.$(1)         := $$(BOOTLOADER_BIN_PATH.$(1))/project.cfg.log
  BUILT_SLB_HEX.$(1)         := $$(BOOTLOADER_BIN_PATH.$(1))/target_slb/slb.hex
  BUILT_SLB_VER.$(1)         := $$(BOOTLOADER_BIN_PATH.$(1))/project.cfg.log
else
  BUILT_PSI_RAM_HEX.$(1)     := $$(BOOTLOADER_BIN_PATH.$(1))/psi_ram/psi_ram.hex
  BUILT_PSI_RAM_XOR.$(1)     := $$(BOOTLOADER_BIN_PATH.$(1))/psi_ram/scripts/psi_ram.xor_script.txt
  BUILT_PSI_RAM_VER.$(1)     := $$(BOOTLOADER_BIN_PATH.$(1))/psi_ram/psi_ram.version.txt
  BUILT_PSI_RAM_ELF.$(1)     := $$(BOOTLOADER_BIN_PATH.$(1))/psi_ram/psi_ram.elf
  BUILT_PSI_FLASH_HEX.$(1)   := $$(BOOTLOADER_BIN_PATH.$(1))/psi_flash/psi_flash.hex
  BUILT_PSI_FLASH_XOR.$(1)   := $$(BOOTLOADER_BIN_PATH.$(1))/psi_flash/scripts/psi_flash.xor_script.txt
  BUILT_PSI_FLASH_VER.$(1)   := $$(BOOTLOADER_BIN_PATH.$(1))/psi_flash/psi_flash.version.txt
  BUILT_PSI_FLASH_ELF.$(1)   := $$(BOOTLOADER_BIN_PATH.$(1))/psi_flash/psi_flash.elf
  BUILT_EBL_HEX.$(1)         := $$(BOOTLOADER_BIN_PATH.$(1))/ebl/ebl.hex
  BUILT_EBL_VER.$(1)         := $$(BOOTLOADER_BIN_PATH.$(1))/ebl/ebl.version.txt
  BUILT_SLB_HEX.$(1)         := $$(BOOTLOADER_BIN_PATH.$(1))/slb/slb.hex
  BUILT_SLB_VER.$(1)         := $$(BOOTLOADER_BIN_PATH.$(1))/slb/slb.version.txt
endif

BOOTLOADER_BINARIES.$(1)    = $$(BUILT_PSI_RAM_HEX.$(1))
BOOTLOADER_BINARIES.$(1)   += $$(BUILT_PSI_RAM_XOR.$(1))
BOOTLOADER_BINARIES.$(1)   += $$(BUILT_PSI_RAM_VER.$(1))
BOOTLOADER_BINARIES.$(1)   += $$(BUILT_PSI_RAM_ELF.$(1))
BOOTLOADER_BINARIES.$(1)   += $$(BUILT_PSI_FLASH_HEX.$(1))
BOOTLOADER_BINARIES.$(1)   += $$(BUILT_PSI_FLASH_XOR.$(1))
BOOTLOADER_BINARIES.$(1)   += $$(BUILT_PSI_FLASH_VER.$(1))
BOOTLOADER_BINARIES.$(1)   += $$(BUILT_PSI_FLASH_ELF.$(1))
BOOTLOADER_BINARIES.$(1)   += $$(BUILT_EBL_HEX.$(1))
BOOTLOADER_BINARIES.$(1)   += $$(BUILT_EBL_VER.$(1))
BOOTLOADER_BINARIES.$(1)   += $$(BUILT_SLB_HEX.$(1))
BOOTLOADER_BINARIES.$(1)   += $$(BUILT_SLB_VER.$(1))

PSI_RAM_BEFORE_DDR_INJECT_FLS.$(1)    := $$(BOOTLDR_TMP_DIR.$(1))/psi_ram.before.ddrinject.fls
PSI_FLASH_BEFORE_DDR_INJECT_FLS.$(1)  := $$(BOOTLDR_TMP_DIR.$(1))/psi_flash.before.ddrinject.fls

PSI_RAM_FLS.$(1)            := $$(abspath $$(SOFIA_FIRMWARE_OUT.$(1)))/flashloader/psi_ram.fls
EBL_FLS.$(1)                := $$(abspath $$(SOFIA_FIRMWARE_OUT.$(1)))/flashloader/ebl.fls
EBL_UPLOAD_FLS.$(1)         := $$(abspath $$(SOFIA_FIRMWARE_OUT.$(1)))/flashloader/ebl_upload.fls

SOFIA_PROVDATA_FILES.$(1) += $$(PSI_RAM_FLS.$(1)) $$(EBL_FLS.$(1))

ifeq ($$(BUILD_REL10_BOOTCORE), true)
FLASHLOADER_FLS.$(1)        := $$(PSI_RAM_FLS.$(1)) $$(EBL_FLS.$(1))
INJECT_FLASHLOADER_FLS.$(1) := --psi $$(PSI_RAM_FLS.$(1)) --ebl $$(EBL_FLS.$(1))
else
FLASHLOADER_FLS.$(1)        := $$(PSI_RAM_FLS.$(1)) $$(EBL_UPLOAD_FLS.$(1))
INJECT_FLASHLOADER_FLS.$(1) := --psi $$(PSI_RAM_FLS.$(1)) --ebl-sec $$(EBL_FLS.$(1))
endif

PSI_FLASH_FLS.$(1)          := $$(FLASHFILES_DIR.$(1))/psi_flash.fls
SLB_FLS.$(1)                := $$(FLASHFILES_DIR.$(1))/slb.fls

#This must be included here for ddrinject makefile to take over the variables here and define additional ones used below
include $$(LOCAL_PATH)/ddrinject.mk

.PHONY: bootcore.$(1) bootcore_fls.$(1) bootcore_clean.$(1) bootcore_rebuild.$(1)

ifeq ($$(BUILD_REL10_BOOTCORE), true)
bootcore.$(1):
	$$(MAKE) -C $$(SOFIA_FW_SRC_BASE)/modem/system-build/make PLATFORM=$$(MODEM_PLATFORM) PROJECTNAME=$$(MODEM_PROJECTNAME_VAR) MAKEDIR=$$(BOOTLOADER_BIN_PATH.$(1)) $$(MODEM_BUILD_ARGUMENTS) INT_STAGE=BOOTSYSTEM ADD_FEATURE+=FEAT_BOOTSYSTEM_DRV_DISPLAY ADD_FEATURE+=FEAT_BOOTSYSTEM_PROXY_INFO_TO_MOBILEVISOR ADD_FEATURE+=FEAT_BOOTSYSTEM_VMM_ENABLED bootsystem
else
bootcore.$(1): $$(BUILT_LIBSOC_TARGET.$(1)) keystore_signer libssl_static2 libcrypto_static2
	$$(if BOOTCORE_FEATURES.$(1), FEATURE="$$(BOOTCORE_FEATURES.$(1))") BLOBSTORE_DTB_KEY="$$(BLOBSTORE_DTB_KEY.$(1))" BLOBSTORE_FINGERPRINT="$$(BLOBSTORE_FINGERPRINT.$(1))" HAL_AUTODETECT="$$(HAL_AUTODETECT)" HAL_AUTODETECT_PROPERTIES_DISABLED="$$(HAL_AUTODETECT_PROPERTIES_DISABLED)" \
	$$(MAKE) -C $$(SOFIA_FW_SRC_BASE)/bootsystems/make PLATFORM=$$(MODEM_PLATFORM) PROJECTNAME=$$(MODEM_PROJECTNAME_VAR) VARIANT=$(1) BL_OUTPUT_DIR=$$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))) SOC_LIB=$$(abspath $$(BUILT_LIBSOC_TARGET.$(1))) KEYSTORE_SIGNER=$$(KEYSTORE_SIGNER) all
endif

$$(BOOTLOADER_BINARIES.$(1)): bootcore

bootcore_clean.$(1):
	rm -rf $$(BOOTLOADER_BIN_PATH.$(1)) $$(BOOTLDR_TMP_DIR.$(1))

bootcore_rebuild.$(1): bootcore_clean bootcore_fls

createflashloader_dir.$(1):
	mkdir -p $$(SOFIA_FIRMWARE_OUT.$(1))/flashloader

$$(BOOTLDR_TMP_DIR.$(1)):
	mkdir -p $$@

ifneq ($$(INTEL_DDR_CTL_PARAMS_FILE.$(1)),)
# If DDR parameter header file is specified then create intermediate PSI FLS
# files and postprocess with FlsSign to inject the Denali settings
$$(PSI_RAM_FLS.$(1)): createflashloader_dir.$(1) $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(BUILT_PSI_RAM_XOR.$(1)) $$(BUILT_PSI_RAM_HEX.$(1)) $$(BUILT_PSI_RAM_VER.$(1)) $$(SIGN_TOOL) $$(PSI_RAM_DDRINJECT_SCRIPT.$(1)) $$(BOOTLDR_TMP_DIR.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$(PSI_RAM_BEFORE_DDR_INJECT_FLS.$(1)) --script $$(BUILT_PSI_RAM_XOR.$(1)) --meta $$(BUILT_PSI_RAM_VER.$(1)) --tag PSI_RAM $$(BUILT_PSI_RAM_HEX.$(1)) --replace --to-fls2
	@echo Injecting custom DDR parameters to $$@...
	$$(SIGN_TOOL) $$(PSI_RAM_BEFORE_DDR_INJECT_FLS.$(1)) -s $$(PSI_RAM_DDRINJECT_SCRIPT.$(1)) -o $$@

$$(PSI_FLASH_FLS.$(1)): createflashfile_dir $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(BUILT_PSI_FLASH_XOR.$(1)) $$(BUILT_PSI_FLASH_HEX.$(1)) $$(BUILT_PSI_FLASH_VER.$(1)) $$(FLASHLOADER_FLS.$(1)) $$(SIGN_TOOL) $$(PSI_FLASH_DDRINJECT_SCRIPT.$(1)) $$(BOOTLDR_TMP_DIR.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$(PSI_FLASH_BEFORE_DDR_INJECT_FLS.$(1)) --script $$(BUILT_PSI_FLASH_XOR.$(1)) --meta $$(BUILT_PSI_FLASH_VER.$(1)) --tag PSI_FLASH $$(BUILT_PSI_FLASH_HEX.$(1)) $$(INJECT_FLASHLOADER_FLS.$(1)) --replace --to-fls2
	@echo Injecting custom DDR parameters to $$@...
	$$(SIGN_TOOL) $$(PSI_FLASH_BEFORE_DDR_INJECT_FLS.$(1)) --noinjremove -s $$(PSI_FLASH_DDRINJECT_SCRIPT.$(1)) -o $$@
else
$$(PSI_RAM_FLS.$(1)): createflashloader_dir.$(1) $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(BUILT_PSI_RAM_XOR.$(1)) $$(BUILT_PSI_RAM_HEX.$(1)) $$(BUILT_PSI_RAM_VER.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$@ --script $$(BUILT_PSI_RAM_XOR.$(1)) --meta $$(BUILT_PSI_RAM_VER.$(1)) --tag PSI_RAM $$(BUILT_PSI_RAM_HEX.$(1)) --replace --to-fls2

$$(EBL_FLS.$(1)): createflashloader_dir.$(1) $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(BUILT_EBL_HEX.$(1)) $$(BUILT_EBL_VER.$(1)) $$(PSI_RAM_FLS.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$@ --meta $$(BUILT_EBL_VER.$(1)) --tag EBL $$(BUILT_EBL_HEX.$(1)) --replace --to-fls2

$$(EBL_UPLOAD_FLS.$(1)): $$(EBL_FLS.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$@ --meta $$(BUILT_EBL_VER.$(1)) --tag EBL $$(BUILT_EBL_HEX.$(1)) $$(INJECT_FLASHLOADER_FLS.$(1)) --replace --to-fls2

$$(PSI_FLASH_FLS.$(1)): createflashfile_dir $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(BUILT_PSI_FLASH_XOR.$(1)) $$(BUILT_PSI_FLASH_HEX.$(1)) $$(BUILT_PSI_FLASH_VER.$(1)) $$(FLASHLOADER_FLS.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$@ --script $$(BUILT_PSI_FLASH_XOR.$(1)) --meta $$(BUILT_PSI_FLASH_VER.$(1)) --tag PSI_FLASH $$(BUILT_PSI_FLASH_HEX.$(1)) $$(INJECT_FLASHLOADER_FLS.$(1)) --replace --to-fls2

$$(SLB_FLS.$(1)): createflashfile_dir $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(BUILT_SLB_HEX.$(1)) $$(BUILT_SLB_VER.$(1)) $$(FLASHLOADER_FLS.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$@ --meta $$(BUILT_SLB_VER.$(1)) --tag SLB $$(BUILT_SLB_HEX.$(1)) $$(INJECT_FLASHLOADER_FLS.$(1)) --replace --to-fls2
endif # ifneq ($$(INTEL_DDR_CTL_PARAMS_FILE.$(1)),)

bootcore_fls.$(1): $$(PSI_FLASH_FLS.$(1)) $$(SLB_FLS.$(1))


UCODE_PATCH_FLS.$(1) := $$(FLASHFILES_DIR.$(1))/ucode_patch.fls
UCODE_PATCH_SIGNED_FLS.$(1) := $$(SIGN_FLS_DIR.$(1))/ucode_patch_signed.fls
SYSTEM_SIGNED_FLS_LIST.$(1) += $$(UCODE_PATCH_SIGNED_FLS.$(1))

$$(UCODE_PATCH_FLS.$(1)): ucode_patch.fls.$(1)

.PHONY: ucode_patch.fls.$(1)
ucode_patch.fls.$(1): createflashfile_dir $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(FLASHLOADER_FLS.$(1))
	make -C $$(SOCLIB_SRC_PATH) -f ucode_patch/Makefile \
  PROJECTNAME=$$(shell echo $$(TARGET_BOARD_PLATFORM_VAR) | tr a-z A-Z) \
  PLATFORM=$$(MODEM_PLATFORM) FLSTOOL=$$(FLSTOOL) INTEL_PRG_FILE=$$(INTEL_PRG_FILE.$(1)) \
  UCODE_PATCH_PRG_TAG=$$(UCODE_PATCH_PRG_TAG) INJECT="$$(INJECT_FLASHLOADER_FLS.$(1))" \
  UCODE_PATCH_FLS=$$(abspath $$(UCODE_PATCH_FLS.$(1)))

.PHONY: splash_img.fls.$(1)

SPLASH_IMG_BIN_PATH.$(1)        := $$(SOFIA_FIRMWARE_OUT.$(1))/splash_image
SPLASH_IMG_FILE_1.$(1)          ?= $$(TARGET_DEVICE_DIR)/splash_image/splash_screen.jpg
SPLASH_IMG_FILE_2.$(1)          ?= $$(TARGET_DEVICE_DIR)/splash_image/fastboot.png
SPLASH_DISPLAY_DTS.$(1)         := $$(SPLASH_IMG_BIN_PATH.$(1))/splash_display_config.dts
SPLASH_IMG_DISPLAY_CONFIG.$(1)  := $$(SPLASH_IMG_BIN_PATH.$(1))/vbt.bin
SPLASH_IMG_HEADER.$(1)          := $$(SPLASH_IMG_BIN_PATH.$(1))/splash_hdr.bin
SPLASH_IMG_BIN_FONT.$(1)        := $$(SPLASH_IMG_BIN_PATH.$(1))/slbfont.bin
SPLASH_IMG_FONT_CONFIG.$(1)     ?= $$(TARGET_DEVICE_DIR)/splash_image/slbfont.cfg
SPLASH_IMG_FILE_FONT.$(1)       ?= $$(TARGET_DEVICE_DIR)/splash_image/slbfont.png
SPLASH_IMG_BIN_0.$(1)           := $$(SPLASH_IMG_BIN_PATH.$(1))/splash_config.bin
SPLASH_IMG_BIN_1.$(1)           := $$(SPLASH_IMG_BIN_PATH.$(1))/splash_screen.bin
SPLASH_IMG_BIN_2.$(1)           := $$(SPLASH_IMG_BIN_PATH.$(1))/fastboot.bin
DISPLAY_BIN.$(1)                := $$(SPLASH_IMG_BIN_PATH.$(1))/display.bin
SPLASH_IMG_FLS.$(1)             := $$(FLASHFILES_DIR.$(1))/splash_img.fls
SPLASH_IMG_SIGNED_FLS.$(1)      := $$(SIGN_FLS_DIR.$(1))/splash_img_signed.fls
SYSTEM_SIGNED_FLS_LIST.$(1)     += $$(SPLASH_IMG_SIGNED_FLS.$(1))
ifdef BOARD_DTB.$(1)
LOCAL_DTB_PATH.$(1)             ?= $$(BOARD_DTB.$(1))
else ifneq (,$$(wildcard $$(TARGET_DEVICE_DIR)/dtbs/$(1)/board.dtb))
LOCAL_DTB_PATH.$(1)             ?= $$(TARGET_DEVICE_DIR)/dtbs/$(1)/board.dtb
else
LOCAL_DTB_PATH.$(1)             ?= $$(LOCAL_KERNEL_PATH)/$$(BOARD_DTB_FILE)
endif

ifneq ("$$(wildcard $$(SPLASH_IMG_FILE_1.$(1)))","")
  ifneq ("$$(wildcard $$(SPLASH_IMG_FILE_2.$(1)))","")
    splash_img.fls.$(1): $$(SPLASH_IMG_FLS.$(1))
  else
    splash_img.fls.$(1):
  endif
else
splash_img.fls.$(1):
endif

$$(SPLASH_IMG_BIN_PATH.$(1)):
	mkdir -p $$@

$$(SPLASH_IMG_BIN_FONT.$(1)): $$(SPLASH_IMG_FILE_FONT.$(1)) | $$(SPLASH_IMG_BIN_PATH.$(1))
	convert $$(SPLASH_IMG_FILE_FONT.$(1)) -depth 8 rgba:$$(SPLASH_IMG_BIN_FONT.$(1))

$(DTC): $(LOCAL_KERNEL)
$$(SPLASH_IMG_BIN_0.$(1)): $$(LOCAL_DTB_PATH.$(1)) $$(SPLASH_IMG_FONT_CONFIG.$(1)) $(DTC) | $$(SPLASH_IMG_BIN_PATH.$(1))
	$$(DTC) -I dtb -O dts -o $$(SPLASH_DISPLAY_DTS.$(1)) $$(LOCAL_DTB_PATH.$(1))
	$$(VBT_GENERATE_TOOL) -i $$(SPLASH_DISPLAY_DTS.$(1)) -o $$(SPLASH_IMG_DISPLAY_CONFIG.$(1)) -splash $$(SPLASH_IMG_HEADER.$(1)) -font_config $$(SPLASH_IMG_FONT_CONFIG.$(1))
	cat $$(SPLASH_IMG_HEADER.$(1)) $$(SPLASH_IMG_DISPLAY_CONFIG.$(1)) > $$(SPLASH_IMG_BIN_0.$(1))

$$(SPLASH_IMG_BIN_1.$(1)): $$(SPLASH_IMG_FILE_1.$(1)) | $$(SPLASH_IMG_BIN_PATH.$(1))
	convert $$(SPLASH_IMG_FILE_1.$(1)) -depth 8 rgba:$$(SPLASH_IMG_BIN_1.$(1))
$$(SPLASH_IMG_BIN_2.$(1)): $$(SPLASH_IMG_FILE_2.$(1)) | $$(SPLASH_IMG_BIN_PATH.$(1))
	convert $$(SPLASH_IMG_FILE_2.$(1)) -depth 8 rgba:$$(SPLASH_IMG_BIN_2.$(1))

$$(DISPLAY_BIN.$(1)) : $$(SPLASH_IMG_BIN_0.$(1)) $$(SPLASH_IMG_BIN_1.$(1)) $$(SPLASH_IMG_BIN_2.$(1)) $$(SPLASH_IMG_BIN_FONT.$(1)) $$(BINARY_MERGE_TOOL)
	$$(BINARY_MERGE_TOOL) -o $$@ -b 512  -p 0 $$(SPLASH_IMG_BIN_0.$(1)) $$(SPLASH_IMG_BIN_1.$(1)) $$(SPLASH_IMG_BIN_2.$(1)) $$(SPLASH_IMG_BIN_FONT.$(1))

$$(SPLASH_IMG_FLS.$(1)): createflashfile_dir $$(INTEL_PRG_FILE.$(1)) $$(FLSTOOL) $$(DISPLAY_BIN.$(1)) $$(FLASHLOADER_FLS.$(1))
	echo "$$(FLSTOOL)"
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$@ --tag SPLASH_SCRN $$(DISPLAY_BIN.$(1)) $$(INJECT_FLASHLOADER_FLS.$(1)) --replace --to-fls2

BOOTROM_PATCH_BIN.$(1) ?= $$(TARGET_DEVICE_DIR)/bootrom_patch/bootrom_patch.bin
BOOTROM_PATCH_FLS.$(1) := $$(FLASHFILES_DIR.$(1))/bootrom_patch.fls

$$(BOOTROM_PATCH_FLS.$(1)): createflashfile_dir $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(BOOTROM_PATCH_BIN.$(1)) $$(FLASHLOADER_FLS.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$@ --tag BM_PATCH $$(BOOTROM_PATCH_BIN.$(1)) $$(INJECT_FLASHLOADER_FLS.$(1)) --replace --to-fls2

.PHONY: bootrom_patch.fls.$(1)
ifeq ("$$(wildcard $$(BOOTROM_PATCH_BIN.$(1)))","")
bootrom_patch.fls.$(1):
	@echo "*** Boot ROM patch does not exist, skip generation ***"
	@echo "*** Boot ROM patch file path: $$(BOOTROM_PATCH_BIN.$(1))"
else
bootrom_patch.fls.$(1): $$(BOOTROM_PATCH_FLS.$(1))
endif

endef

$(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),\
       $(eval $(call bootcore_per_variant,$(variant))))

PSI_RAM_FLS := $(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),$(PSI_RAM_FLS.$(variant)))
EBL_FLS := $(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),$(EBL_FLS.$(variant)))

.PHONY: bootcore
bootcore: $(addprefix bootcore.,$(SOFIA_FIRMWARE_VARIANTS))

.PHONY: bootcore_fls
bootcore_fls: $(addprefix bootcore_fls.,$(SOFIA_FIRMWARE_VARIANTS))

.PHONY: bootcore_rebuild
bootcore_rebuild: $(addprefix bootcore_rebuild.,$(SOFIA_FIRMWARE_VARIANTS))

.PHONY: bootrom_patch.fls
bootrom_patch.fls: $(addprefix bootrom_patch.fls.,$(SOFIA_FIRMWARE_VARIANTS))

.PHONY: ucode_patch.fls
ucode_patch.fls: $(addprefix ucode_patch.fls.,$(SOFIA_FIRMWARE_VARIANTS))

.PHONY: splash_img.fls
splash_img.fls: $(addprefix splash_img.fls.,$(SOFIA_FIRMWARE_VARIANTS))

createboothexinfo:
	@echo "----------------------------------------------------------"
	@echo "-make bootcore         : Will generate all boot-core hex files"
	@echo "-make bootcore_fls     : Will generate all boot-core FLS files"
	@echo "-make bootcore_rebuild : Will rebuild all boot-core hex and FLS files"
	@echo "-make bootrom_patch.fls: Will generate boot ROM patch FLS file"
	@echo "-make ucode_patch.fls  : Will generate microcode patch FLS file"
	@echo "-make splash_img.fls   : Will generate splash screen FLS file"

build_info: createboothexinfo

droidcore: bootcore_fls ucode_patch.fls splash_img.fls

endif # ifeq ($(BUILD_BOOTCORE_FROM_SRC),true)
