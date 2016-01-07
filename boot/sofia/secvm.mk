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

define secvm_per_variant

SECVM_BUILD_DIR.$(1) := $$(SOFIA_FIRMWARE_OUT.$(1))/secvm
BUILT_SECVM.$(1) := $$(SECVM_BUILD_DIR.$(1))/secvm.hex
SECVM_FLS.$(1) := $$(FLASHFILES_DIR.$(1))/secvm.fls
SECVM_SIGNED_FLS.$(1) := $$(SIGN_FLS_DIR.$(1))/secvm_signed.fls
SYSTEM_SIGNED_FLS_LIST.$(1) += $$(SECVM_SIGNED_FLS.$(1))
SECVM_BUILD_DIR := $$(SECVM_BUILD_DIR.$(1))

$$(BUILT_SECVM.$(1)): build_secvm.$(1)

.PHONY: build_secvm.$(1)
build_secvm.$(1):
	@echo Building ===== Building secvm.$(1) =====
	$$(MAKE) -C $$(SECVM_SRC_PATH) FEAT_VPU_G1V6_H1V6=$$(PRODUCT_FEAT_VPU_G1V6_H1V6) BASEBUILDDIR=$$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))) PROJECTNAME=$$(shell echo $$(TARGET_BOARD_PLATFORM_VAR) | tr a-z A-Z) PLATFORM=$$(MODEM_PLATFORM)

$$(SECVM_FLS.$(1)): $$(BUILT_SECVM.$(1)) $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(FLASHLOADER_FLS.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$@ --tag SECURE_VM $$(INJECT_FLASHLOADER_FLS.$(1)) $$(BUILT_SECVM.$(1)) --replace --to-fls2

.PHONY: secvm.fls.$(1)
secvm.fls.$(1): $$(SECVM_FLS.$(1))

.PHONY: secvm_clean.$(1)
secvm_clean.$(1):
	rm -rf $$(SECVM_BUILD_DIR.$(1))

endef

$(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),\
       $(eval $(call secvm_per_variant,$(variant))))

.PHONY: secvm
secvm: $(addprefix build_secvm.,$(SOFIA_FIRMWARE_VARIANTS))

.PHONY: secvm.fls
secvm.fls: $(addprefix secvm.fls.,$(SOFIA_FIRMWARE_VARIANTS))

droidcore: secvm.fls

.PHONY: secvm_clean
secvm_clean: $(addprefix secvm_clean.,$(SOFIA_FIRMWARE_VARIANTS))

.PHONY: secvm_rebuild
secvm_rebuild: secvm_clean secvm.fls

secvm_info:
	@echo "----------------------------------------------------------------"
	@echo "-make secvm.fls -- Generates the secvm flash file."
	@echo "-make secvm_rebuild -- Rebuilds secvm code and generates flash file."

build_info: secvm_info

endif

