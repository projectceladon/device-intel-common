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

ifeq ($(BUILD_THREADX_FROM_SRC),true)
BUILT_THREADX := $(PRODUCT_OUT)/threadx/threadx.hex
THREADX_FLS   := $(FLASHFILES_DIR)/threadx.fls

$(BUILT_THREADX): build_threadx_hex

$(THREADX_FLS): $(BUILT_THREADX) $(FLSTOOL) $(INTEL_PRG_FILE) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag MODEM_IMG $(INJECT_FLASHLOADER_FLS) $(BUILT_THREADX) --replace --to-fls2
ifeq ($(findstring sofia3g,$(TARGET_BOARD_PLATFORM)),sofia3g)
	$(FLSTOOL) -o $(SECBIN_TEMP)/threadx -x $(THREADX_FLS)
endif
threadx: create_secbin_dir

build_threadx_hex:
	$(MAKE) -C $(MOBILEVISOR_GUEST_PATH)/threadx PROJECTNAME=$(shell echo $(TARGET_BOARD_PLATFORM_VAR) | tr a-z A-Z)  BASEBUILDDIR=$(CURDIR)/$(PRODUCT_OUT)

ifeq ($(findstring sofia3g,$(TARGET_BOARD_PLATFORM)),sofia3g)
.PHONY: buildthreadx threadx
else
.PHONY: buildthreadx threadx.fls
endif
buildthreadx: $(BUILT_THREADX)

threadx_info:
	@echo "------------------------------------------------"
	@echo "Threadx:"
	@echo "-make buildthreadx : Will build the threadx code which can be used for VP."
	@echo "-make threadx.fls : Will build and generate fls out of threadx which can act as Guest VM in liu of Modem"

ifeq ($(GEN_THREADX_FLS_FILES),true)
ifeq ($(findstring sofia3g,$(TARGET_BOARD_PLATFORM)),sofia3g)
threadx: $(THREADX_FLS)
	$(hide) rm $(THREADX_FLS)
droidcore: threadx
else
threadx.fls: $(THREADX_FLS)
droidcore: threadx.fls
endif
else
droidcore: $(BUILT_THREADX)
endif
endif

ifeq ($(DELIVERY_BUTTER),true)
THREADX_FLS   := $(FLASHFILES_DIR)/threadx.fls

$(THREADX_FLS): $(BUILT_THREADX) $(FLSTOOL) $(INTEL_PRG_FILE) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag MODEM_IMG $(INJECT_FLASHLOADER_FLS) $(BUILT_THREADX) --replace --to-fls2


.PHONY: buildthreadx threadx.fls
buildthreadx: $(BUILT_THREADX)

threadx.fls: $(THREADX_FLS)
droidcore: threadx.fls

endif

MODEM_PROJECTNAME_VAR ?= $(MODEM_PROJECTNAME)

ifeq ($(BUILD_MODEM_FROM_SRC),true)

MODEM_MAKEDIR := $(CURDIR)/$(PRODUCT_OUT)/modem_build
BUILT_MODEM   := $(MODEM_MAKEDIR)/$(MODEM_PROJECTNAME_VAR).ihex
MODEM_FLS     := $(FLASHFILES_DIR)/modem.fls
SYSTEM_SIGNED_FLS_LIST  += $(SIGN_FLS_DIR)/modem_signed.fls

ifeq ($(USER),tcloud)
ifeq ($(findstring sofia3g,$(TARGET_BOARD_PLATFORM)),sofia3g)
MODEM_BUILD_ARGUMENTS += SDLROOT=$(CURDIR)/modem/system-build/HW_SIC
else
MODEM_BUILD_ARGUMENTS += SDLROOT=$(CURDIR)/modem/system-build/HW_LTE_TDS
endif
else
MODEM_BUILD_ARGUMENTS += SDLROOT=$(CURDIR)/$(PRODUCT_OUT)/sdlcode
endif

$(BUILT_MODEM): build_modem_hex

ifeq ($(BUILD_3GFW_FROM_SRC),true)

GEN_3G_FW_STT_FILE :=  $(CURDIR)/$(PRODUCT_OUT)/3gfw/swtdus_swtools/sttdecoder_3gfw/make_sttdecoder/bin/hybrid_image/ming_rel/sttdecoder_3gfw.dll

3GFW_GEN_PATH := $(CURDIR)/$(PRODUCT_OUT)/3gfw/umts_fw_dev/firmware/bin/ram_image/rvds_dbg

$(GEN_3G_FW_C_FILE): gen_3gfw
$(GEN_3G_FW_STT_FILE): gen_3gfw_stt

ifeq ($(findstring sofia3g,$(TARGET_BOARD_PLATFORM)),sofia3g)
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
endif

.PHONY: modem_createdirs
modem_createdirs:
	$(MAKE) -s -C $(CURDIR)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) $(MODEM_BUILD_ARGUMENTS) MAKEDIR=$(MODEM_MAKEDIR) createdirs

.PHONY: modem_config
modem_config: modem_createdirs
	$(MAKE) -s -C $(CURDIR)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) $(MODEM_BUILD_ARGUMENTS) MAKEDIR=$(MODEM_MAKEDIR) config

.PHONY: sdlgeninit
sdlgeninit: modem_config
	$(MAKE) -s -C $(CURDIR)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) $(MODEM_BUILD_ARGUMENTS) MAKEDIR=$(MODEM_MAKEDIR) runsdlcmd

.PHONY: sdlgencode
sdlgencode: sdlgeninit
	$(MAKE) -s -C $(CURDIR)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) $(MODEM_BUILD_ARGUMENTS) MAKEDIR=$(MODEM_MAKEDIR) SDLSCR=YES SDLCODEGEN=YES runsdlscr

.PHONY: build_modem_hex
ifeq ($(USER),tcloud)
build_modem_hex: modem_config
	$(MAKE) -s -C $(CURDIR)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) $(MODEM_BUILD_ARGUMENTS) 3GFW_GEN_PATH=$(3GFW_GEN_PATH) MAKEDIR=$(MODEM_MAKEDIR)
else
build_modem_hex: sdlgencode
	$(MAKE) -s -C $(CURDIR)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) $(MODEM_BUILD_ARGUMENTS) 3GFW_GEN_PATH=$(3GFW_GEN_PATH) MAKEDIR=$(MODEM_MAKEDIR)
endif

ifeq ($(findstring sofia3g,$(TARGET_BOARD_PLATFORM)),sofia3g)
.PHONY: modem
$(MODEM_FLS): $(BUILT_MODEM) $(FLSTOOL) $(INTEL_PRG_FILE) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag MODEM_IMG $(INJECT_FLASHLOADER_FLS) $(BUILT_MODEM) --replace --to-fls2

modem: $(BUILT_MODEM_DATA_EXT) $(BUILT_MODEM_SEC_BLK) 
	$(hide) rm $(MODEM_FLS)
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
endif

modem_info:
	@echo "-----------------------------------------------------"
	@echo "Modem:"
	@echo "-make modem.fls : Will build the Virtualized Modem configuration and generate fls file"
	@echo "-make sdlgencode : Will generate Protocol Stack SDL Code"


build_info: modem_info

endif

ifeq ($(NON_IMC_BUILD),true)
MODEM_FLS     := $(FLASHFILES_DIR)/modem.fls

ifeq ($(findstring sofia3g,$(TARGET_BOARD_PLATFORM)),sofia3g)
.PHONY: modem
ifneq ($(BOARD_USE_FLS_PREBUILTS),$(TARGET_PRODUCT))
$(MODEM_FLS): $(BUILT_MODEM) $(FLSTOOL) $(INTEL_PRG_FILE) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag MODEM_IMG $(INJECT_FLASHLOADER_FLS) $(BUILT_MODEM) --replace --to-fls2
endif # BOARD_USE_FLS_PREBUILTS != true

modem: $(MEX_SECBIN)
	$(hide) rm $(MODEM_FLS)
droidcore: modem

else
.PHONY: modem.fls
ifneq ($(BOARD_USE_FLS_PREBUILTS),$(TARGET_PRODUCT))
$(MODEM_FLS): $(BUILT_MODEM) $(FLSTOOL) $(INTEL_PRG_FILE) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag MODEM_IMG $(INJECT_FLASHLOADER_FLS) $(BUILT_MODEM) --replace --to-fls2
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(FLASHFILES_DIR)/dsp_image.fls --tag DSP_IMAGE $(INJECT_FLASHLOADER_FLS) $(BUILT_MODEM) --replace --to-fls2
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(FLASHFILES_DIR)/lte.fls --tag LTE $(INJECT_FLASHLOADER_FLS) $(LTE_BIN) --replace --to-fls2
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(FLASHFILES_DIR)/imc_fw_block_1.fls --tag LC_FW1 $(INJECT_FLASHLOADER_FLS) $(LC_FW1_BIN)  --replace --to-fls2
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(FLASHFILES_DIR)/imc_fw_block_2.fls --tag LC_FW2 $(INJECT_FLASHLOADER_FLS) $(LC_FW2_BIN) --replace --to-fls2
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(FLASHFILES_DIR)/imc_bootloader_a.fls --tag MINI_BL_1 $(INJECT_FLASHLOADER_FLS) $(MINI_BL1_BIN) --replace --to-fls2
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $(FLASHFILES_DIR)/imc_bootloader_b.fls --tag MINI_BL_2 $(INJECT_FLASHLOADER_FLS) $(MINI_BL2_BIN) --replace --to-fls2
endif # BOARD_USE_FLS_PREBUILTS != true
	
modem.fls: $(MODEM_FLS)
droidcore: modem.fls
endif # TARGET_BOARD_PLATFORM == sofia3g

endif # NON_IMC_BUILD == true

ifeq ($(DELIVERY_BUTTER),true)
MODEM_FLS     := $(FLASHFILES_DIR)/modem.fls

ifeq ($(findstring sofia3g,$(TARGET_BOARD_PLATFORM)),sofia3g)
.PHONY: modem
$(MODEM_FLS): $(BUILT_MODEM) $(FLSTOOL) $(INTEL_PRG_FILE) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag MODEM_IMG $(INJECT_FLASHLOADER_FLS) $(BUILT_MODEM) --replace --to-fls2

modem: $(MEX_SECBIN)
	$(hide) rm $(MODEM_FLS)
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
endif

endif
