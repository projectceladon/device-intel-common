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

ifeq ($(GEN_PRG_FROM_SRC),true)

INTEL_PRG_PATH :=
INTEL_PRG_FILE :=

define createprg_per_variant

INTEL_PRG_PATH.$(1) = $$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))/scatter_obj)
INTEL_PRG_FILE.$(1) = $$(INTEL_PRG_PATH.$(1))/modem_sw.prg

$$(INTEL_PRG_FILE.$(1)): prg.$(1)

.PHONY: prg.$(1)
ifeq ($$(findstring sofia3g,$$(TARGET_BOARD_PLATFORM)),sofia3g)
prg.$(1): | $$(SOFIA_FIRMWARE_OUT.$(1))
	$$(MAKE) -C $$(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$$(MODEM_PROJECTNAME_VAR) PLATFORM=$$(MODEM_PLATFORM) MAKEDIR=$$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))) INT_STAGE=MEX $$(MODEM_BUILD_ARGUMENTS) makeprg > $$(SOFIA_FIRMWARE_OUT.$(1))/prggen.log
else
prg.$(1): | $$(SOFIA_FIRMWARE_OUT.$(1))
	$$(MAKE) -C $$(SOFIA_FW_SRC_BASE)/modem/system-build/make PROJECTNAME=$$(MODEM_PROJECTNAME_VAR) PLATFORM=$$(MODEM_PLATFORM) MAKEDIR=$$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))) INT_STAGE=MODEM makeprg > $$(SOFIA_FIRMWARE_OUT.$(1))/prggen.log
endif

INTEL_PRG_PATH += $$(INTEL_PRG_PATH.$(1))
INTEL_PRG_FILE += $$(INTEL_PRG_FILE.$(1))

SOFIA_PROVDATA_FILES.$(1) += $$(INTEL_PRG_FILE.$(1))

endef

$(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),\
       $(eval $(call createprg_per_variant,$(variant))))

INTEL_PRG_FILE := $(strip $(INTEL_PRG_FILE))

.PHONY: prg
prg: $(INTEL_PRG_FILE)

.PHONY: prg_clean
prg_clean:
	rm -rf $(INTEL_PRG_PATH)

.PHONY: prg_rebuild
prg_rebuild: prg_clean prg

prginfo:
	@echo "------------------------------------------"
	@echo "PRG:"
	@echo "-make prg : Will create the PRG file"
	@echo "-make prg_rebuild : Will regenerate the PRG file"

build_info: prginfo
endif
