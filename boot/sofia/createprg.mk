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

INTEL_PRG_PATH = $(CURDIR)/$(PRODUCT_OUT)/scatter_obj
ifeq ($(GEN_PRG_FROM_SRC),true)
INTEL_PRG_FILE = $(INTEL_PRG_PATH)/modem_sw.prg

MODEM_PROJECTNAME_VAR ?= $(MODEM_PROJECTNAME)

.PHONY: prg
$(INTEL_PRG_FILE): prg

prg_clean:
	rm -rf $(INTEL_PRG_PATH)

ifeq ($(findstring sofia3g,$(TARGET_BOARD_PLATFORM)),sofia3g)
prg:
	$(MAKE) -C $(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) MAKEDIR=$(CURDIR)/$(PRODUCT_OUT) INT_STAGE=MEX $(MODEM_BUILD_ARGUMENTS) makeprg > $(PRODUCT_OUT)/prggen.log
else
prg:
	$(MAKE) -C $(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$(MODEM_PROJECTNAME_VAR) PLATFORM=$(MODEM_PLATFORM) MAKEDIR=$(CURDIR)/$(PRODUCT_OUT) INT_STAGE=MODEM makeprg > $(PRODUCT_OUT)/prggen.log
endif

prg_rebuild: prg_clean prg

prginfo:
	@echo "------------------------------------------"
	@echo "PRG:"
	@echo "-make prg : Will create the PRG file"
	@echo "-make prg_rebuild : Will regenerate the PRG file"

build_info: prginfo
endif

SOFIA_PROVDATA_FILES += $(INTEL_PRG_FILE)
