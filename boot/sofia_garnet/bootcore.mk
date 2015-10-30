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

ifeq ($(BUILD_BOOTCORE_FROM_SRC),true)
BL_OUTPUT_DIR         := $(CURDIR)/$(PRODUCT_OUT)

BOOTLDR_TMP_DIR       := $(PRODUCT_OUT)/bootloader_tmp

SIGN_TOOL             := $(SOFIA_FW_SRC_BASE)/modem/dwdtools/FlsSign/Linux/FlsSign_E2_Linux

ifeq '$(findstring $(MODEM_PROJECTNAME),${MODEM_PLATFORM})' '$(MODEM_PROJECTNAME)'
  BOOTLOADER_BIN_PATH := ${BL_OUTPUT_DIR}/bootloader/${MODEM_PLATFORM}
else
  BOOTLOADER_BIN_PATH := ${BL_OUTPUT_DIR}/bootloader/$(MODEM_PROJECTNAME)_$(MODEM_PLATFORM)
endif

ifeq ($(BUILD_REL10_BOOTCORE), true)
  BUILT_PSI_RAM_HEX     := $(BOOTLOADER_BIN_PATH)/target_psi_ram/psi_ram.hex
  BUILT_PSI_RAM_XOR     := $(BOOTLOADER_BIN_PATH)/scripts/psi_ram.xor_script.txt
  BUILT_PSI_RAM_ELF     := $(BOOTLOADER_BIN_PATH)/target_psi_ram/psi_ram.elf
  BUILT_PSI_FLASH_HEX   := $(BOOTLOADER_BIN_PATH)/target_psi_flash/psi_flash.hex
  BUILT_PSI_FLASH_XOR   := $(BOOTLOADER_BIN_PATH)/scripts/psi_flash.xor_script.txt
  BUILT_PSI_FLASH_ELF   := $(BOOTLOADER_BIN_PATH)/target_psi_flash/psi_flash.elf
  BUILT_EBL_HEX         := $(BOOTLOADER_BIN_PATH)/target_ebl/ebl.hex
  BUILT_SLB_HEX         := $(BOOTLOADER_BIN_PATH)/target_slb/slb.hex

  BOOTLOADER_BINARIES    = $(BUILT_PSI_RAM_HEX)
  BOOTLOADER_BINARIES   += $(BUILT_PSI_RAM_XOR)
  BOOTLOADER_BINARIES   += $(BUILT_PSI_RAM_ELF)
  BOOTLOADER_BINARIES   += $(BUILT_PSI_FLASH_HEX)
  BOOTLOADER_BINARIES   += $(BUILT_PSI_FLASH_XOR)
  BOOTLOADER_BINARIES   += $(BUILT_PSI_FLASH_ELF)
  BOOTLOADER_BINARIES   += $(BUILT_EBL_HEX)
  BOOTLOADER_BINARIES   += $(BUILT_SLB_HEX)
else
  BUILT_PSI_RAM_HEX     := $(BOOTLOADER_BIN_PATH)/psi_ram/psi_ram.hex
  BUILT_PSI_RAM_XOR     := $(BOOTLOADER_BIN_PATH)/psi_ram/scripts/psi_ram.xor_script.txt
  BUILT_PSI_RAM_VER     := $(BOOTLOADER_BIN_PATH)/psi_ram/psi_ram.version.txt
  BUILT_PSI_RAM_ELF     := $(BOOTLOADER_BIN_PATH)/psi_ram/psi_ram.elf
  BUILT_PSI_FLASH_HEX   := $(BOOTLOADER_BIN_PATH)/psi_flash/psi_flash.hex
  BUILT_PSI_FLASH_XOR   := $(BOOTLOADER_BIN_PATH)/psi_flash/scripts/psi_flash.xor_script.txt
  BUILT_PSI_FLASH_VER   := $(BOOTLOADER_BIN_PATH)/psi_flash/psi_flash.version.txt
  BUILT_PSI_FLASH_ELF   := $(BOOTLOADER_BIN_PATH)/psi_flash/psi_flash.elf
  BUILT_EBL_HEX         := $(BOOTLOADER_BIN_PATH)/ebl/ebl.hex
  BUILT_EBL_VER         := $(BOOTLOADER_BIN_PATH)/ebl/ebl.version.txt
  BUILT_SLB_HEX         := $(BOOTLOADER_BIN_PATH)/slb/slb.hex
  BUILT_SLB_VER         := $(BOOTLOADER_BIN_PATH)/slb/slb.version.txt

  BOOTLOADER_BINARIES    = $(BUILT_PSI_RAM_HEX)
  BOOTLOADER_BINARIES   += $(BUILT_PSI_RAM_XOR)
  BOOTLOADER_BINARIES   += $(BUILT_PSI_RAM_VER)
  BOOTLOADER_BINARIES   += $(BUILT_PSI_RAM_ELF)
  BOOTLOADER_BINARIES   += $(BUILT_PSI_FLASH_HEX)
  BOOTLOADER_BINARIES   += $(BUILT_PSI_FLASH_XOR)
  BOOTLOADER_BINARIES   += $(BUILT_PSI_FLASH_VER)
  BOOTLOADER_BINARIES   += $(BUILT_PSI_FLASH_ELF)
  BOOTLOADER_BINARIES   += $(BUILT_EBL_HEX)
  BOOTLOADER_BINARIES   += $(BUILT_EBL_VER)
  BOOTLOADER_BINARIES   += $(BUILT_SLB_HEX)
  BOOTLOADER_BINARIES   += $(BUILT_SLB_VER)
endif

PSI_RAM_BEFORE_DDR_INJECT_FLS    := $(BOOTLDR_TMP_DIR)/psi_ram.before.ddrinject.fls
PSI_FLASH_BEFORE_DDR_INJECT_FLS  := $(BOOTLDR_TMP_DIR)/psi_flash.before.ddrinject.fls

ifneq ($(BOARD_USE_FLS_PREBUILTS),$(TARGET_DEVICE))
PSI_RAM_FLS            := $(CURDIR)/$(PRODUCT_OUT)/flashloader/psi_ram.fls
EBL_FLS                := $(CURDIR)/$(PRODUCT_OUT)/flashloader/ebl.fls
else
PSI_RAM_FLS            := $(CURDIR)/device/intel/sofia3gr/$(TARGET_DEVICE)/flashloader/psi_ram.fls
EBL_FLS                := $(CURDIR)/device/intel/sofia3gr/$(TARGET_DEVICE)/flashloader/ebl.fls
endif


FLASHLOADER_FLS         = $(PSI_RAM_FLS) $(EBL_FLS)
INJECT_FLASHLOADER_FLS  = --psi $(PSI_RAM_FLS) --ebl $(EBL_FLS)

PSI_FLASH_FLS          := $(FLASHFILES_DIR)/psi_flash.fls
SLB_FLS                := $(FLASHFILES_DIR)/slb.fls


#This must be included here for ddrinject makefile to take over the variables here and define additional ones used below
include $(LOCAL_PATH)/ddrinject.mk

MODEM_PROJECTNAME_VAR ?= $(MODEM_PROJECTNAME)

.PHONY: bootcore bootcore_fls bootcore_clean bootcore_rebuild

ifneq ($(BOARD_USE_FLS_PREBUILTS),$(TARGET_DEVICE))
ifeq ($(BUILD_REL10_BOOTCORE), true)
bootcore:
	$(MAKE) -C $(SOFIA_FW_SRC_BASE)/modem/system-build/make PLATFORM=$(MODEM_PLATFORM) PROJECTNAME=$(MODEM_PROJECTNAME_VAR) MAKEDIR=$(BOOTLOADER_BIN_PATH) $(MODEM_BUILD_ARGUMENTS) INT_STAGE=BOOTSYSTEM ADD_FEATURE+=FEAT_BOOTSYSTEM_DRV_DISPLAY ADD_FEATURE+=FEAT_BOOTSYSTEM_PROXY_INFO_TO_MOBILEVISOR bootsystem
else
bootcore: $(BUILT_LIBSOC_TARGET)
	$(MAKE) -C $(SOFIA_FW_SRC_BASE)/bootsystems/make PLATFORM=$(MODEM_PLATFORM) PROJECTNAME=$(MODEM_PROJECTNAME_VAR) BL_OUTPUT_DIR=$(BL_OUTPUT_DIR) SOC_LIB=$(BUILT_LIBSOC_TARGET)
endif

$(BOOTLOADER_BINARIES): bootcore
else
bootcore:

endif

bootcore_clean:
	rm -rf $(BOOTLOADER_BIN_PATH) $(BOOTLDR_TMP_DIR)

bootcore_rebuild: bootcore_clean bootcore_fls

createflashloader_dir:
	mkdir -p $(PRODUCT_OUT)/flashloader

$(BOOTLDR_TMP_DIR):
	mkdir -p $@

ifneq ($(BOARD_USE_FLS_PREBUILTS),$(TARGET_DEVICE))
#If DDR parameter file is specified, create intermediate PSI FLS file and then postprocess with FlsSign to inject the denali settings
ifneq ($(INTEL_DDR_CTL_PARAMS_FILE),)
  ifeq ($(BUILD_REL10_BOOTCORE), true)
$(PSI_RAM_FLS): createflashloader_dir $(FLSTOOL) $(INTEL_PRG_FILE) $(BUILT_PSI_RAM_HEX) $(BUILT_PSI_RAM_XOR) $(SIGN_TOOL) $(PSI_RAM_DDRINJECT_SCRIPT) $(BOOTLDR_TMP_DIR)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(PSI_RAM_BEFORE_DDR_INJECT_FLS) --script $(BUILT_PSI_RAM_XOR) --tag PSI_RAM $(BUILT_PSI_RAM_HEX) --replace --to-fls2
	echo Injecting custom DDR parameters to $@
	$(SIGN_TOOL) $(PSI_RAM_BEFORE_DDR_INJECT_FLS) -s $(PSI_RAM_DDRINJECT_SCRIPT) -o $@
else
$(PSI_RAM_FLS): createflashloader_dir $(FLSTOOL) $(INTEL_PRG_FILE) $(BUILT_PSI_RAM_HEX) $(BUILT_PSI_RAM_XOR) $(BUILT_PSI_RAM_VER) $(SIGN_TOOL) $(PSI_RAM_DDRINJECT_SCRIPT) $(BOOTLDR_TMP_DIR)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(PSI_RAM_BEFORE_DDR_INJECT_FLS) --script $(BUILT_PSI_RAM_XOR) --meta $(BUILT_PSI_RAM_VER) --tag PSI_RAM $(BUILT_PSI_RAM_HEX) --replace --to-fls2
	echo Injecting custom DDR parameters to $@
	$(SIGN_TOOL) $(PSI_RAM_BEFORE_DDR_INJECT_FLS) -s $(PSI_RAM_DDRINJECT_SCRIPT) -o $@
endif # REL10_BOOTCORE
else
   ifeq ($(BUILD_REL10_BOOTCORE), true)
$(PSI_RAM_FLS): createflashloader_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(BUILT_PSI_RAM_XOR) $(BUILT_PSI_RAM_HEX)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --script $(BUILT_PSI_RAM_XOR) --tag PSI_RAM $(BUILT_PSI_RAM_HEX) --replace --to-fls2
$(EBL_FLS): createflashloader_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(BUILT_EBL_HEX)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag EBL $(BUILT_EBL_HEX) --replace --to-fls2
else
$(PSI_RAM_FLS): createflashloader_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(BUILT_PSI_RAM_XOR) $(BUILT_PSI_RAM_HEX) $(BUILT_PSI_RAM_VER)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --script $(BUILT_PSI_RAM_XOR) --meta $(BUILT_PSI_RAM_VER) --tag PSI_RAM $(BUILT_PSI_RAM_HEX) --replace --to-fls2
$(EBL_FLS): createflashloader_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(BUILT_EBL_HEX) $(BUILT_EBL_VER) $(PSI_RAM_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --meta $(BUILT_EBL_VER) --tag EBL $(BUILT_EBL_HEX) --replace --to-fls2 --psi $(PSI_RAM_FLS)
endif # REL10_BOOTCORE
endif
endif


ifneq ($(BOARD_USE_FLS_PREBUILTS),$(TARGET_DEVICE))
#If DDR parameter file is specified, create intermediate PSI FLS file and then postprocess with FlsSign to inject the denali settings
ifneq ($(INTEL_DDR_CTL_PARAMS_FILE),)
  ifeq ($(BUILD_REL10_BOOTCORE), true)
$(PSI_FLASH_FLS): createflashfile_dir $(FLSTOOL) $(INTEL_PRG_FILE) $(BUILT_PSI_FLASH_HEX) $(BUILT_PSI_FLASH_XOR) $(FLASHLOADER_FLS) $(SIGN_TOOL) $(PSI_FLASH_DDRINJECT_SCRIPT) $(BOOTLDR_TMP_DIR)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(PSI_FLASH_BEFORE_DDR_INJECT_FLS) --script $(BUILT_PSI_FLASH_XOR) --tag PSI_FLASH $(BUILT_PSI_FLASH_HEX) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2
	echo Injecting custom DDR parameters to $@
	$(SIGN_TOOL) $(PSI_FLASH_BEFORE_DDR_INJECT_FLS) --noinjremove -s $(PSI_FLASH_DDRINJECT_SCRIPT) -o $@
else
$(PSI_FLASH_FLS): createflashfile_dir $(FLSTOOL) $(INTEL_PRG_FILE) $(BUILT_PSI_FLASH_HEX) $(BUILT_PSI_FLASH_XOR) $(BUILT_PSI_FLASH_VER) $(FLASHLOADER_FLS) $(SIGN_TOOL) $(PSI_FLASH_DDRINJECT_SCRIPT) $(BOOTLDR_TMP_DIR)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(PSI_FLASH_BEFORE_DDR_INJECT_FLS) --script $(BUILT_PSI_FLASH_XOR) --meta $(BUILT_PSI_FLASH_VER) --tag PSI_FLASH $(BUILT_PSI_FLASH_HEX) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2
	echo Injecting custom DDR parameters to $@
	$(SIGN_TOOL) $(PSI_FLASH_BEFORE_DDR_INJECT_FLS) --noinjremove -s $(PSI_FLASH_DDRINJECT_SCRIPT) -o $@
endif # REL10_BOOTCORE
else
   ifeq ($(BUILD_REL10_BOOTCORE), true)
$(PSI_FLASH_FLS): createflashfile_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(BUILT_PSI_FLASH_HEX) $(BUILT_PSI_FLASH_XOR) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --script $(BUILT_PSI_FLASH_XOR) --tag PSI_FLASH $(BUILT_PSI_FLASH_HEX) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2

$(SLB_FLS): createflashfile_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(BUILT_SLB_HEX) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag SLB $(BUILT_SLB_HEX) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2
else
$(PSI_FLASH_FLS): createflashfile_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(BUILT_PSI_FLASH_HEX) $(BUILT_PSI_FLASH_XOR) $(BUILT_PSI_FLASH_VER) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --script $(BUILT_PSI_FLASH_XOR) --meta $(BUILT_PSI_FLASH_VER) --tag PSI_FLASH $(BUILT_PSI_FLASH_HEX) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2

$(SLB_FLS): createflashfile_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(BUILT_SLB_HEX) $(BUILT_SLB_VER) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --meta $(BUILT_SLB_VER) --tag SLB $(BUILT_SLB_HEX) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2
endif # REL10_BOOTCORE
endif # DDR_CTRL
else
PREBUILT_PSI_FLASH := $(CURDIR)/device/intel/sofia3gr/$(TARGET_DEVICE)/prebuilt-fls/psi_flash.fls
PREBUILT_SLB_FLASH := $(CURDIR)/device/intel/sofia3gr/$(TARGET_DEVICE)/prebuilt-fls/slb.fls

$(PSI_FLASH_FLS): createflashfile_dir | $(ACP)
	$(ACP) $(PREBUILT_PSI_FLASH) $@

$(SLB_FLS): createflashfile_dir | $(ACP)
	$(ACP) $(PREBUILT_SLB_FLASH) $@
endif

bootcore_fls: $(PSI_FLASH_FLS) $(SLB_FLS)

createboothexinfo:
	@echo "----------------------------------------------------------"
	@echo "-make bootcore : Will generate all bootcore hex files"
	@echo "-make bootcore_fls : Will generate all bootcore fls files"
	@echo "-make bootcore_rebuild: Will rebuild the bootcore hex files"
	@echo "-make bootrom_patch.fls: Will generate bootrom patch fls file"
	@echo "-make ucode_patch.fls: Will generate ucode patch fls file"
	@echo "-make splash_img.fls: Will generate splash screen fls file"


build_info: createboothexinfo

droidcore: bootcore_fls ucode_patch.fls splash_img.fls

.PHONY: ucode_patch.fls
UCODE_PATCH_BIN        := $(CURDIR)/device/intel/sofia3gr/$(TARGET_DEVICE)/ucode_patch/ucode_patch.bin
UCODE_PATCH_FLS        := $(FLASHFILES_DIR)/ucode_patch.fls

ucode_patch.fls: $(UCODE_PATCH_FLS)

ifeq ("$(wildcard $(UCODE_PATCH_BIN))","")
$(UCODE_PATCH_FLS):
else
SYSTEM_SIGNED_FLS_LIST += $(SIGN_FLS_DIR)/ucode_patch_signed.fls
ifeq ($(BUILD_REL10_BOOTCORE), true)
$(UCODE_PATCH_FLS): createflashfile_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(UCODE_PATCH_BIN) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag UCODE_PATCH $(UCODE_PATCH_BIN) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2
else
$(UCODE_PATCH_FLS): createflashfile_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(UCODE_PATCH_BIN) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag UC_PATCH $(UCODE_PATCH_BIN) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2
endif
endif

.PHONY: splash_img.fls

SPLASH_IMG_OUTPUT_DIR           := $(CURDIR)/$(PRODUCT_OUT)
SPLASH_IMG_BIN_PATH             := $(BL_OUTPUT_DIR)/splash_image
DTC                             := $(PRODUCT_KERNEL_OUTPUT)/scripts/dtc/dtc

SPLASH_IMG_FILE_1               := $(CURDIR)/device/intel/sofia3gr/$(TARGET_DEVICE)/splash_image/splash_screen.jpg
SPLASH_IMG_FILE_2               := $(CURDIR)/device/intel/sofia3gr/$(TARGET_DEVICE)/splash_image/fastboot.jpg

SPLASH_DISPLAY_DTS              := $(SPLASH_IMG_BIN_PATH)/splash_display_config.dts
SPLASH_DISPLAY_DTS_STATIC       ?= $(SPLASH_DISPLAY_DTS)
SPLASH_IMG_DISPLAY_CONFIG       :=

SPLASH_IMG_HEADER               := $(SPLASH_IMG_BIN_PATH)/splash_hdr.bin
SPLASH_IMG_BIN_1                := $(SPLASH_IMG_BIN_PATH)/splash_screen.bin
SPLASH_IMG_BIN_2                := $(SPLASH_IMG_BIN_PATH)/fastboot.bin
DISPLAY_BIN                     := $(SPLASH_IMG_BIN_PATH)/display.bin

SPLASH_IMG_FLS                  := $(FLASHFILES_DIR)/splash_img.fls
SYSTEM_SIGNED_FLS_LIST          += $(SIGN_FLS_DIR)/splash_img_signed.fls

splash_img.fls:

ifneq ("$(wildcard $(SPLASH_IMG_FILE_1))","")
  splash_img.fls: $(SPLASH_IMG_FLS)
endif

ifneq ("$(wildcard $(SPLASH_IMG_FILE_2))","")
  splash_img.fls: $(SPLASH_IMG_FLS)
endif

createsplashimg_dir:
	@mkdir -p $(SPLASH_IMG_BIN_PATH)

ifneq ($(BOARD_USE_FLS_PREBUILTS),$(TARGET_DEVICE))
$(SPLASH_IMG_HEADER)  : $(SPLASH_IMG_DISPLAY_CONFIG) ;

define GENERATE_DISPLAY_CONFIG
$(SPLASH_IMG_BIN_PATH)/$(basename $(notdir $(1))).bin: $(1) | createsplashimg_dir
	$(VBT_GENERATE_TOOL) -i $(1) -o $(SPLASH_IMG_BIN_PATH)/$(basename $(notdir $(1))).bin -splash $(SPLASH_IMG_HEADER) $(SPLASH_VBT_GEN_ADDITIONAL_OPTION)

SPLASH_IMG_DISPLAY_CONFIG += $(SPLASH_IMG_BIN_PATH)/$(basename $(notdir $(1))).bin
endef

$(foreach config, $(SPLASH_DISPLAY_DTS_STATIC), $(eval $(call GENERATE_DISPLAY_CONFIG,$(config))))

$(SPLASH_DISPLAY_DTS) : $(built_dtb_target) kernel_dtb | createsplashimg_dir
	$(DTC) -I dtb -O dts -o $(SPLASH_DISPLAY_DTS) $(built_dtb_target)

$(SPLASH_IMG_FLS): $(INTEL_PRG_FILE) $(FLSTOOL) $(DISPLAY_BIN)  $(FLASHLOADER_FLS) | createflashfile_dir
	@echo "$(FLSTOOL)"
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag SPLASH_SCRN $(DISPLAY_BIN) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2

$(SPLASH_IMG_BIN_1): createsplashimg_dir
	convert $(SPLASH_IMG_FILE_1) -depth 8 rgba:$(SPLASH_IMG_BIN_1)

$(SPLASH_IMG_BIN_2): createsplashimg_dir
	convert $(SPLASH_IMG_FILE_2) -depth 8 rgba:$(SPLASH_IMG_BIN_2)

$(DISPLAY_BIN) : $(SPLASH_IMG_HEADER) $(SPLASH_IMG_DISPLAY_CONFIG) $(SPLASH_IMG_BIN_1) $(SPLASH_IMG_BIN_2) $(BINARY_MERGE_TOOL)
	$(BINARY_MERGE_TOOL) -o $@ -b 512  -p 0 $(SPLASH_IMG_HEADER) $(SPLASH_IMG_DISPLAY_CONFIG) $(SPLASH_IMG_BIN_1) $(SPLASH_IMG_BIN_2)
else
PREBUILT_SPLASH := $(CURDIR)/device/intel/sofia3gr/$(TARGET_DEVICE)/prebuilt-fls/splash_img.fls

$(SPLASH_IMG_FLS): createflashfile_dir | $(ACP)
	$(ACP) $(PREBUILT_SPLASH) $@
endif

endif


.PHONY: bootrom_patch.fls
BOOTROM_PATCH_BIN      := $(CURDIR)/device/intel/sofia3gr/$(TARGET_DEVICE)/bootrom_patch/bootrom_patch.bin
BOOTROM_PATCH_FLS      := $(FLASHFILES_DIR)/bootrom_patch.fls

$(BOOTROM_PATCH_FLS): createflashfile_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(BOOTROM_PATCH_BIN) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag BM_PATCH $(BOOTROM_PATCH_BIN) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2

ifeq ("$(wildcard $(BOOTROM_PATCH_BIN))","")
#file not exist
bootrom_patch.fls:
	@echo "*** Bootrom patch is not exist, skip generation ***"
	@echo "*** Bootrom patch file path: $(BOOTROM_PATCH_BIN)"
else
bootrom_patch.fls: $(BOOTROM_PATCH_FLS)
endif

SOFIA_PROVDATA_FILES += $(PSI_RAM_FLS) $(EBL_FLS)
SOFIA_PROVDATA_FILES += $(PSI_FLASH_FLS) $(SLB_FLS) $(SPLASH_IMG_FLS) $(UCODE_PATCH_FLS)