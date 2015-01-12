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


ifeq ($(BUILD_SECVM_FROM_SRC),true)
#Source Paths configured in Base Android.mk
#Build Output path.
SECVM_BUILD_OUT := $(CURDIR)/$(PRODUCT_OUT)
SECVM_BUILD_DIR := $(SECVM_BUILD_OUT)/secvm
BUILT_SECVM := $(SECVM_BUILD_DIR)/secvm.hex
SECVM_FLS := $(FLASHFILES_DIR)/secvm.fls
SYSTEM_SIGNED_FLS_LIST  += $(SIGN_FLS_DIR)/secvm_signed.fls
TARGET_BOARD_PLATFORM_VAR ?= $(TARGET_BOARD_PLATFORM)

$(BUILT_SECVM): build_secvm

build_secvm:
	@echo Building ===== Building secvm =====
	make -C $(SECVM_SRC_PATH) BASEBUILDDIR=$(SECVM_BUILD_OUT) PROJECTNAME=$(shell echo $(TARGET_BOARD_PLATFORM_VAR) | tr a-z A-Z) PLATFORM=$(MODEM_PLATFORM)

.PHONY: secvm
secvm: $(BUILT_SECVM)

$(SECVM_FLS): $(BUILT_SECVM) $(FLSTOOL) $(BOARD_PRG_FILE) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(BOARD_PRG_FILE) --output $@ --tag SECURE_VM $(INJECT_FLASHLOADER_FLS) $(BUILT_SECVM) --replace --to-fls2

.PHONY: secvm.fls
secvm.fls: $(SECVM_FLS)

droidcore: secvm.fls

.PHONY: secvm_clean
secvm_clean:
	rm -rf $(SECVM_BUILD_DIR)

.PHONY: secvm_rebuild
secvm_rebuild: secvm_clean secvm.fls

secvm_info:
	@echo "----------------------------------------------------------------"
	@echo "-make secvm.fls -- Generates the secvm flash file."
	@echo "-make secvm_rebuild -- Rebuilds secvm code and generates flash file."

build_info: secvm_info

endif

