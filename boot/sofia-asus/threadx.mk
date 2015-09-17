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
ifeq ($(TARGET_BOARD_PLATFORM),sofia3g)
	$(FLSTOOL) -o $(EXTRACT_TEMP)/threadx -x $(THREADX_FLS)
endif
threadx: createflashfile_dir

build_threadx_hex:
	$(MAKE) -C $(MOBILEVISOR_GUEST_PATH)/threadx PROJECTNAME=$(shell echo $(TARGET_BOARD_PLATFORM_VAR) | tr a-z A-Z)  BASEBUILDDIR=$(CURDIR)/$(PRODUCT_OUT)

ifeq ($(TARGET_BOARD_PLATFORM),sofia3g)
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
ifeq ($(TARGET_BOARD_PLATFORM),sofia3g)
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