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

define threadx_per_variant

BUILT_THREADX.$(1) := $$(SOFIA_FIRMWARE_OUT.$(1))/threadx/threadx.hex
THREADX_FLS.$(1)   := $$(FLASHFILES_DIR.$(1))/threadx.fls

$$(BUILT_THREADX.$(1)): build_threadx_hex.$(1)

$$(THREADX_FLS.$(1)): $$(BUILT_THREADX.$(1)) $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(FLASHLOADER_FLS.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$@ --tag MODEM_IMG $$(INJECT_FLASHLOADER_FLS.$(1)) $$(BUILT_THREADX.$(1)) --replace --to-fls2
ifeq ($$(findstring sofia3g,$$(TARGET_BOARD_PLATFORM)),sofia3g)
	$$(FLSTOOL) -o $$(EXTRACT_TEMP.$(1))/threadx -x $$(THREADX_FLS.$(1))
endif
threadx: createflashfile_dir

build_threadx_hex:
	$$(MAKE) -C $$(MOBILEVISOR_GUEST_PATH)/threadx PROJECTNAME=$$(shell echo $$(TARGET_BOARD_PLATFORM_VAR) | tr a-z A-Z)  BASEBUILDDIR=$$(abspath $$(SOFIA_FIRMWARE_OUT.$(1)))

.PHONY: buildthreadx.$(1)
buildthreadx.$(1): $$(BUILT_THREADX.$(1))

.PHONY: threadx.fls.$(1)
threadx.fls.$(1): $$(THREADX_FLS.$(1))

endef

$(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),\
       $(eval $(call threadx_per_variant,$(variant))))

.PHONY: buildthreadx
buildthreadx: $(addprefix buildthreadx.,$(SOFIA_FIRMWARE_VARIANTS))

.PHONY: threadx.fls
threadx.fls: $(addprefix threadx.fls.,$(SOFIA_FIRMWARE_VARIANTS))

.PHONY: buildthreadx threadx.fls

threadx_info:
	@echo "------------------------------------------------"
	@echo "Threadx:"
	@echo "-make buildthreadx : Will build the threadx code which can be used for VP."
	@echo "-make threadx.fls : Will build and generate fls out of threadx which can act as Guest VM in liu of Modem"

droidcore: threadx.fls

endif

