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

PSI_RAM_FLS            := $(CURDIR)/$(PRODUCT_OUT)/flashloader/psi_ram.fls
EBL_FLS                := $(CURDIR)/$(PRODUCT_OUT)/flashloader/ebl.fls

FLASHLOADER_FLS         = $(PSI_RAM_FLS) $(EBL_FLS)
INJECT_FLASHLOADER_FLS  = --psi $(PSI_RAM_FLS) --ebl $(EBL_FLS)

PSI_FLASH_FLS          := $(FLASHFILES_DIR)/psi_flash.fls
SLB_FLS                := $(FLASHFILES_DIR)/slb.fls

KEYSTORE_SIGNER := $(ANDROID_BUILD_TOP)/$(HOST_OUT_EXECUTABLES)/keystore_signer

include $(LOCAL_PATH)/ddrinject.mk

MODEM_PROJECTNAME_VAR ?= $(MODEM_PROJECTNAME)

.PHONY: bootcore bootcore_fls bootcore_clean bootcore_rebuild

ifeq ($(BUILD_REL10_BOOTCORE), true)
bootcore:
	$(MAKE) -C $(SOFIA_FW_SRC_BASE)/modem/system-build/make PLATFORM=$(MODEM_PLATFORM) PROJECTNAME=$(MODEM_PROJECTNAME_VAR) MAKEDIR=$(BOOTLOADER_BIN_PATH) $(MODEM_BUILD_ARGUMENTS) INT_STAGE=BOOTSYSTEM ADD_FEATURE+=FEAT_BOOTSYSTEM_DRV_DISPLAY ADD_FEATURE+=FEAT_BOOTSYSTEM_PROXY_INFO_TO_MOBILEVISOR bootsystem
else
bootcore: $(BUILT_LIBSOC_TARGET) keystore_signer libssl_static libcrypto_static
	$(if BOOTCORE_FEATURES, FEATURE="$(BOOTCORE_FEATURES)") \
	$(MAKE) -C $(SOFIA_FW_SRC_BASE)/bootsystems/make PLATFORM=$(MODEM_PLATFORM) PROJECTNAME=$(MODEM_PROJECTNAME_VAR) BL_OUTPUT_DIR=$(BL_OUTPUT_DIR) SOC_LIB=$(BUILT_LIBSOC_TARGET) KEYSTORE_SIGNER=$(KEYSTORE_SIGNER) all
endif

$(BOOTLOADER_BINARIES): bootcore


bootcore_clean:
	rm -rf $(BOOTLOADER_BIN_PATH) $(BOOTLDR_TMP_DIR)

bootcore_rebuild: bootcore_clean bootcore_fls

createflashloader_dir:
	mkdir -p $(PRODUCT_OUT)/flashloader

$(BOOTLDR_TMP_DIR):
	mkdir -p $@

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
UCODE_PATCH_BIN        := $(CURDIR)/device/intel/$(TARGET_BOARD_PLATFORM)/$(TARGET_PRODUCT)/ucode_patch/ucode_patch.bin
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

SPLASH_IMG_OUTPUT_DIR  		:= $(CURDIR)/$(PRODUCT_OUT)
SPLASH_IMG_BIN_PATH    		:= $(BL_OUTPUT_DIR)/splash_image
SPLASH_IMG_FILE_1      		:= $(CURDIR)/device/intel/$(TARGET_BOARD_PLATFORM)/$(TARGET_PRODUCT)/splash_image/splash_screen.jpg
SPLASH_IMG_FILE_2      		:= $(CURDIR)/device/intel/$(TARGET_BOARD_PLATFORM)/$(TARGET_PRODUCT)/splash_image/fastboot.jpg
SPLASH_DISPLAY_DTS			:= $(SPLASH_IMG_BIN_PATH)/splash_display_config.dts
SPLASH_IMG_DISPLAY_CONFIG   := $(SPLASH_IMG_BIN_PATH)/vbt.bin
SPLASH_IMG_HEADER	   		:= $(SPLASH_IMG_BIN_PATH)/splash_hdr.bin
SPLASH_IMG_BIN_0			:= $(SPLASH_IMG_BIN_PATH)/splash_config.bin
SPLASH_IMG_BIN_1       		:= $(SPLASH_IMG_BIN_PATH)/splash_screen.bin
SPLASH_IMG_BIN_2       		:= $(SPLASH_IMG_BIN_PATH)/fastboot.bin
DISPLAY_BIN := $(SPLASH_IMG_BIN_PATH)/display.bin
SPLASH_IMG_FLS         		:= $(FLASHFILES_DIR)/splash_img.fls
DTC							:= $(LOCAL_KERNEL_PATH)/dtc
SYSTEM_SIGNED_FLS_LIST 		+= $(SIGN_FLS_DIR)/splash_img_signed.fls

ifneq ("$(wildcard $(SPLASH_IMG_FILE_1))","")
  ifneq ("$(wildcard $(SPLASH_IMG_FILE_2))","")
    splash_img.fls: $(SPLASH_IMG_FLS)
  else
    splash_img.fls:
  endif
else
splash_img.fls:
endif

createsplashimg_dir:
	mkdir -p $(SPLASH_IMG_BIN_PATH)

LOCAL_DTB_PATH := $(LOCAL_KERNEL_PATH)/$(BOARD_DTB_FILE)

$(SPLASH_IMG_BIN_0): createsplashimg_dir
	$(DTC) -I dtb -O dts -o $(SPLASH_DISPLAY_DTS) $(LOCAL_DTB_PATH)
	$(VBT_GENERATE_TOOL) -i $(SPLASH_DISPLAY_DTS) -o $(SPLASH_IMG_DISPLAY_CONFIG) -splash $(SPLASH_IMG_HEADER)
	cat $(SPLASH_IMG_HEADER) $(SPLASH_IMG_DISPLAY_CONFIG) > $(SPLASH_IMG_BIN_0)
	
$(SPLASH_IMG_BIN_1): createsplashimg_dir
	convert $(SPLASH_IMG_FILE_1) -depth 8 rgba:$(SPLASH_IMG_BIN_1)
$(SPLASH_IMG_BIN_2): createsplashimg_dir
	convert $(SPLASH_IMG_FILE_2) -depth 8 rgba:$(SPLASH_IMG_BIN_2)

$(DISPLAY_BIN) : $(SPLASH_IMG_BIN_0) $(SPLASH_IMG_BIN_1) $(SPLASH_IMG_BIN_2) $(BINARY_MERGE_TOOL)
	$(BINARY_MERGE_TOOL) -o $@ -b 512  -p 0 $(SPLASH_IMG_BIN_0) $(SPLASH_IMG_BIN_1) $(SPLASH_IMG_BIN_2)
	
$(SPLASH_IMG_FLS): createflashfile_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(DISPLAY_BIN)  $(FLASHLOADER_FLS)
	echo "$(FLSTOOL)"
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag SPLASH_SCRN $(DISPLAY_BIN) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2




endif


.PHONY: bootrom_patch.fls
BOOTROM_PATCH_BIN      := $(CURDIR)/device/intel/$(TARGET_BOARD_PLATFORM)/$(TARGET_PRODUCT)/bootrom_patch/bootrom_patch.bin
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

ifeq ($(DELIVERY_BUTTER), true)

createflashloader_dir:
	mkdir -p $(CURDIR)/$(PRODUCT_OUT)/flashloader

PSI_RAM_FLS            := $(CURDIR)/$(PRODUCT_OUT)/flashloader/psi_ram.fls
EBL_FLS                := $(CURDIR)/$(PRODUCT_OUT)/flashloader/ebl.fls
PSI_FLASH_FLS          := $(FLASHFILES_DIR)/psi_flash.fls
SLB_FLS                := $(FLASHFILES_DIR)/slb.fls
SPLASH_IMG_FLS         := $(FLASHFILES_DIR)/splash_img.fls

BOOTLOADER_BIN_PATH    := $(CURDIR)/../images/modem/prebuilt/boot

BUILT_PSI_RAM_HEX     := $(BOOTLOADER_BIN_PATH)/psi_ram.hex
BUILT_PSI_RAM_XOR     := $(BOOTLOADER_BIN_PATH)/psi_ram.xor_script.txt
BUILT_PSI_FLASH_HEX   := $(BOOTLOADER_BIN_PATH)/psi_flash.hex
BUILT_PSI_FLASH_XOR   := $(BOOTLOADER_BIN_PATH)/psi_flash.xor_script.txt
BUILT_EBL_HEX         := $(BOOTLOADER_BIN_PATH)/ebl.hex
BUILT_SLB_HEX         := $(BOOTLOADER_BIN_PATH)/slb.hex

SPLASH_IMG_FILE_1      := $(CURDIR)/device/intel/$(TARGET_PRODUCT)/splash_image/splash_screen.jpg
SPLASH_IMG_FILE_2      := $(CURDIR)/device/intel/$(TARGET_PRODUCT)/splash_image/fastboot.jpg
SPLASH_IMG_BIN_0       := $(BOOTLOADER_BIN_PATH)/splash_image/vbt.bin
SPLASH_IMG_BIN_1       := $(BOOTLOADER_BIN_PATH)/splash_image/splash_screen.bin
SPLASH_IMG_BIN_2       := $(BOOTLOADER_BIN_PATH)/splash_image/fastboot.bin



$(PSI_RAM_FLS): createflashloader_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(BUILT_PSI_RAM_XOR) $(BUILT_PSI_RAM_HEX)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --script $(BUILT_PSI_RAM_XOR) --tag PSI_RAM $(BUILT_PSI_RAM_HEX) --replace --to-fls2

$(EBL_FLS): createflashloader_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(BUILT_EBL_HEX)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag EBL $(BUILT_EBL_HEX) --replace --to-fls2


FLASHLOADER_FLS         = $(PSI_RAM_FLS) $(EBL_FLS)
INJECT_FLASHLOADER_FLS  = --psi $(PSI_RAM_FLS) --ebl $(EBL_FLS)

$(PSI_FLASH_FLS): createflashfile_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(BUILT_PSI_FLASH_HEX) $(BUILT_PSI_FLASH_XOR) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --script $(BUILT_PSI_FLASH_XOR) --tag PSI_FLASH $(BUILT_PSI_FLASH_HEX) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2

$(SLB_FLS): createflashfile_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(BUILT_SLB_HEX) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag SLB $(BUILT_SLB_HEX) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2

$(SPLASH_IMG_FLS): createflashfile_dir $(INTEL_PRG_FILE) $(FLSTOOL) $(SPLASH_IMG_BIN_0) $(SPLASH_IMG_BIN_1) $(SPLASH_IMG_BIN_2) $(FLASHLOADER_FLS)
	echo "$(FLSTOOL)"
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag SPLASH_SCRN $(SPLASH_IMG_BIN_0) $(SPLASH_IMG_BIN_1) $(SPLASH_IMG_BIN_2) $(INJECT_FLASHLOADER_FLS) --replace --to-fls2

.PHONY: psi_flash.fls
psi_flash.fls: $(PSI_FLASH_FLS)

droidcore: psi_flash.fls

.PHONY: slb.fls
slb.fls: $(SLB_FLS)

droidcore: slb.fls

.PHONY: splash_img.fls
splash_img.fls: $(SPLASH_IMG_FLS)

droidcore: splash_img.fls

endif


