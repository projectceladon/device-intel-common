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

MODEM_PROJECTNAME_VAR ?= $(MODEM_PROJECTNAME)

ifeq ($(BUILD_MODEM_FROM_SRC),true)


MODEM_MAKEDIR := $(CURDIR)/$(PRODUCT_OUT)/modem_build
BUILT_MODEM   := $(MODEM_MAKEDIR)/$(MODEM_PROJECTNAME_VAR).ihex

ifeq ($(DELIVERY),YES)
ifeq ($(TARGET_BOARD_PLATFORM),sofia3g)
MODEM_BUILD_ARGUMENTS += SDLROOT=$(SOFIA_FW_SRC_BASE)/modem/system-build/HW_SIC
else
MODEM_BUILD_ARGUMENTS += SDLROOT=$(SOFIA_FW_SRC_BASE)/modem/system-build/HW_LTE_TDS
endif
else
ifeq ($(USER),tcloud)
ifeq ($(TARGET_BOARD_PLATFORM),sofia3g)
MODEM_BUILD_ARGUMENTS += SDLROOT=$(SOFIA_FW_SRC_BASE)/modem/system-build/HW_SIC
else
MODEM_BUILD_ARGUMENTS += SDLROOT=$(SOFIA_FW_SRC_BASE)/modem/system-build/HW_LTE_TDS
endif
else
MODEM_BUILD_ARGUMENTS += SDLROOT=$(CURDIR)/$(PRODUCT_OUT)/sdlcode
endif  #endif $(USER) = tcloud
endif  #DELIVERY

$(BUILT_MODEM): build_modem_hex

ifeq ($(BUILD_3GFW_FROM_SRC),true)

GEN_3G_FW_STT_FILE :=  $(CURDIR)/$(PRODUCT_OUT)/3gfw/swtdus_swtools/sttdecoder_3gfw/make_sttdecoder/bin/hybrid_image/ming_rel/sttdecoder_3gfw.dll

3GFW_GEN_PATH := $(CURDIR)/$(PRODUCT_OUT)/3gfw/umts_fw_dev/firmware/bin/ram_image/rvds_dbg

$(GEN_3G_FW_C_FILE): gen_3gfw
$(GEN_3G_FW_STT_FILE): gen_3gfw_stt

ifeq ($(TARGET_BOARD_PLATFORM),sofia3g)
gen_3gfw:
	$(MAKE) -C $(FW3G_SRC_PATH) CFG=RVDS_DBG UBN=0 RBN=030 TARGET_PRODUCT=$(FW3G_PRODUCT) OUTPUTDIR=$(CURDIR)/$(PRODUCT_OUT)/3gfw ram_image_nc
else
gen_3gfw:
	$(MAKE) -C $(FW3G_SRC_PATH) CFG=RVDS_DBG UBN=0 RBN=030 TARGET_PRODUCT=$(FW3G_PRODUCT) OUTPUTDIR=$(CURDIR)/$(PRODUCT_OUT)/3gfw rom_image
	$(MAKE) -C $(FW3G_SRC_PATH) CFG=RVDS_DBG UBN=0 RBN=030 TARGET_PRODUCT=$(FW3G_PRODUCT) OUTPUTDIR=$(CURDIR)/$(PRODUCT_OUT)/3gfw ram_image_nc
endif

gen_3gfw_stt: gen_3gfw
	$(MAKE) -C $(FW3G_SRC_PATH) CFG=MING_REL UBN=0 RBN=030 TARGET_PRODUCT=$(FW3G_PRODUCT) OUTPUTDIR=$(CURDIR)/$(PRODUCT_OUT)/3gfw stt_decoder


ifeq ($(TARGET_BUILD_VARIANT),eng)
build_modem_hex: gen_3gfw_stt
else
build_modem_hex: gen_3gfw
endif
endif #endif $(BUILD_3GFW_FROM_SRC) = true

.PHONY: modem_createdirs
modem_createdirs:
	$(MAKE) -s -C $(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) $(MODEM_BUILD_ARGUMENTS) MAKEDIR=$(MODEM_MAKEDIR) createdirs

.PHONY: modem_config
modem_config: modem_createdirs
	$(MAKE) -s -C $(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) $(MODEM_BUILD_ARGUMENTS) MAKEDIR=$(MODEM_MAKEDIR) config

.PHONY: sdlgeninit
sdlgeninit: modem_config
	$(MAKE) -s -C $(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) $(MODEM_BUILD_ARGUMENTS) MAKEDIR=$(MODEM_MAKEDIR) runsdlcmd

.PHONY: sdlgencode
sdlgencode: sdlgeninit
	$(MAKE) -s -C $(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) $(MODEM_BUILD_ARGUMENTS) MAKEDIR=$(MODEM_MAKEDIR) SDLSCR=YES SDLCODEGEN=YES runsdlscr

.PHONY: build_modem_hex
ifeq ($(DELIVERY),YES)
build_modem_hex: modem_config
	$(MAKE) -s -C $(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) $(MODEM_BUILD_ARGUMENTS) 3GFW_GEN_PATH=$(3GFW_GEN_PATH) MAKEDIR=$(MODEM_MAKEDIR)
else
ifeq ($(USER),tcloud)
build_modem_hex: modem_config
	$(MAKE) -s -C $(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) $(MODEM_BUILD_ARGUMENTS) 3GFW_GEN_PATH=$(3GFW_GEN_PATH) MAKEDIR=$(MODEM_MAKEDIR)
else
build_modem_hex: sdlgencode
	$(MAKE) -s -C $(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) $(MODEM_BUILD_ARGUMENTS) 3GFW_GEN_PATH=$(3GFW_GEN_PATH) MAKEDIR=$(MODEM_MAKEDIR)
endif
endif

modem_info:
	@echo "-----------------------------------------------------"
	@echo "Modem:"
	@echo "-make modem.fls : Will build the Virtualized Modem configuration and generate fls file"
	@echo "-make sdlgencode : Will generate Protocol Stack SDL Code"

build_info: modem_info

endif #endif $(BUILD_MODEM_FROM_SRC) = true

ifeq ('$(BUILT_MODEM_OVERRIDE)','YES')
@echo "Using ========= $(BUILT_MODEM_OVERRIDE) for $(MODEM_FLS) generation =========="
BUILT_MODEM = $(SOFIA_FW_SRC_BASE)/images/$(MODEM_PLATFORM)/SF_3GR.ihex
endif

MODEM_FLS  := $(FLASHFILES_DIR)/modem.fls
ANDROID_SIGNED_FLS_LIST  += $(SIGN_FLS_DIR)/modem_signed.fls
ifeq ($(TARGET_BOARD_PLATFORM),sofia_lte)
ANDROID_SIGNED_FLS_LIST += $(SIGN_FLS_DIR)/dsp_image_signed.fls
ANDROID_SIGNED_FLS_LIST += $(SIGN_FLS_DIR)/lte_signed.fls
ANDROID_SIGNED_FLS_LIST += $(SIGN_FLS_DIR)/imc_fw_block_1_signed.fls
ANDROID_SIGNED_FLS_LIST += $(SIGN_FLS_DIR)/imc_fw_block_2_signed.fls
ANDROID_SIGNED_FLS_LIST += $(SIGN_FLS_DIR)/imc_bootloader_a_signed.fls
ANDROID_SIGNED_FLS_LIST += $(SIGN_FLS_DIR)/imc_bootloader_b_signed.fls
endif

ifeq ($(TARGET_BOARD_PLATFORM),sofia3g)
.INTERMEDIATE: $(MODEM_FLS)
.INTERMEDIATE: $(SIGN_FLS_DIR)/modem_signed.fls


$(MODEM_FLS): $(BUILT_MODEM) $(FLSTOOL) $(INTEL_PRG_FILE) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag MODEM_IMG $(INJECT_FLASHLOADER_FLS) $(BUILT_MODEM) --replace --to-fls2

BUILT_MODEM_DATA_EXT := $(EXTRACT_TEMP)/modem/modem.fls_ID0_CUST_LoadMap0.bin

$(BUILT_MODEM_DATA_EXT) : $(EXTRACT_TEMP)/modem

$(EXTRACT_TEMP)/modem : $(MODEM_FLS) force
	$(FLSTOOL) -o $(EXTRACT_TEMP)/modem -x $(MODEM_FLS)

MODEM_BIN_LOAD_PATH := $(TARGET_OUT)/vendor/firmware

MODEM_INSTALL_PATH := $(MODEM_BIN_LOAD_PATH)/modem.fls_ID0_CUST_LoadMap0.bin

.PHONY: install_modem
install_modem: $(BUILT_MODEM_DATA_EXT) | $(ACP)
	@echo "Installing Modem Data Extract Binary to System Image.."
	$(hide) mkdir -p $(MODEM_BIN_LOAD_PATH)
	$(ACP) $< $(MODEM_INSTALL_PATH)

ifeq ($(TARGET_LOAD_MODEM_DATA_EXTRACT),true)
$(PRODUCT_OUT)/obj/PACKAGING/systemimage_intermediates/system.img: install_modem
endif

.PHONY: modem
modem: $(BUILT_MODEM_DATA_EXT)

droidcore: modem

else
.PHONY: modem.fls
$(MODEM_FLS): $(BUILT_MODEM) $(FLSTOOL) $(INTEL_PRG_FILE) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag MODEM_IMG $(INJECT_FLASHLOADER_FLS) $(BUILT_MODEM) --replace --to-fls2
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(FLASHFILES_DIR)/dsp_image.fls --tag DSP_IMAGE $(INJECT_FLASHLOADER_FLS) $(BUILT_MODEM) --replace --to-fls2
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(FLASHFILES_DIR)/lte.fls --tag LTE $(INJECT_FLASHLOADER_FLS) $(LTE_BIN) --replace --to-fls2
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(FLASHFILES_DIR)/imc_fw_block_1.fls --tag LC_FW1 $(INJECT_FLASHLOADER_FLS) $(LC_FW1_BIN)  --replace --to-fls2
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(FLASHFILES_DIR)/imc_fw_block_2.fls --tag LC_FW2 $(INJECT_FLASHLOADER_FLS) $(LC_FW2_BIN) --replace --to-fls2
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(FLASHFILES_DIR)/imc_bootloader_a.fls --tag MINI_BL_1 $(INJECT_FLASHLOADER_FLS) $(MINI_BL1_BIN) --replace --to-fls2
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(FLASHFILES_DIR)/imc_bootloader_b.fls --tag MINI_BL_2 $(INJECT_FLASHLOADER_FLS) $(MINI_BL2_BIN) --replace --to-fls2

modem.fls: $(MODEM_FLS)
droidcore: modem.fls
endif #endif $(TARGET_BOARD_PLATFORM) = sofia3g


