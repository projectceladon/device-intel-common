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


ifeq ($(BUILD_GUESTVM2_FROM_SRC),true)
#Source Paths configured in Base Android.mk
#Build Output path.
GUESTVM2_BUILD_OUT := $(CURDIR)/$(PRODUCT_OUT)
GUESTVM2_BUILD_DIR := $(GUESTVM2_BUILD_OUT)/vm2
BUILT_GUESTVM2 := $(GUESTVM2_BUILD_DIR)/vm2.hex
GUESTVM2_FLS := $(FLASHFILES_DIR)/guestvm2.fls
#SYSTEM_SIGNED_FLS_LIST  += $(SIGN_FLS_DIR)/guestvm2_signed.fls

$(BUILT_GUESTVM2): build_guestvm2

build_guestvm2:
	@echo Building ===== Building guestvm2 =====
	make -C $(GUESTVM2_SRC_PATH) PLATFORM=$(MODEM_PLATFORM) BASEBUILDDIR=$(GUESTVM2_BUILD_OUT)

.PHONY: guestvm2
guestvm2: $(BUILT_GUESTVM2)

$(GUESTVM2_FLS): $(BUILT_GUESTVM2) $(FLSTOOL) $(INTEL_PRG_FILE) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag BOOT_IMG $(INJECT_FLASHLOADER_FLS) $(BUILT_GUESTVM2) --replace --to-fls2

.PHONY: guestvm2.fls
guestvm2.fls: $(GUESTVM2_FLS)

.PHONY: guestvm2_clean
guestvm2_clean:
	rm -rf $(GUESTVM2_BUILD_DIR)

.PHONY: guestvm2_rebuild
guestvm2_rebuild: guestvm2_clean guestvm2.fls

.PHONY: sa_vmodem
ifeq ($(findstring sofia3g,$(TARGET_BOARD_PLATFORM)),sofia3g)
sa_vmodem: bootcore_fls modem.fls guestvm2.fls ucode_patch.fls splash_img.fls mobilevisor.fls secvm.fls $(MV_CONFIG_DEFAULT_FLS)
else
sa_vmodem: bootcore_fls modem.fls ucode_patch.fls splash_img.fls mobilevisor.fls $(MV_CONFIG_DEFAULT_FLS)
endif

guestvm2_info:
	@echo "----------------------------------------------------------------"
	@echo "-make guestvm2.fls -- Generates the guestvm2 flash file."
	@echo "-make guestvm2_rebuild -- Rebuilds guestvm2 code and generates flash file."
	@echo "-make sa_vmodem --Generates all fls files for standalone virtual modem variant. This is only applicable for sofia3g_sa_vmod_xges1_1_ages2_svb TARGET"

build_info: guestvm2_info

endif
