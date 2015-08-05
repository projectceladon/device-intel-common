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

#Source Paths configured in Base Android.mk
#Build Output path.

define soclib_per_variant

BUILT_LIBSOC_TARGET.$(1) := $$(SOFIA_FIRMWARE_OUT.$(1))/lib_soc/lib_soc.a

$$(BUILT_LIBSOC_TARGET.$(1)): build_soclib.$(1)

$$(SOFIA_FIRMWARE_OUT.$(1))/lib_soc:
	mkdir -p $$@

.PHONY: build_soclib.$(1)
build_soclib.$(1): | $$(SOFIA_FIRMWARE_OUT.$(1))/lib_soc
	@echo Building ===== lib_soc.$(1) =====
	$$(if SOCLIB_FEATURES, FEATURE="$$(SOCLIB_FEATURES)") \
	$$(MAKE) -C $$(SOCLIB_SRC_PATH) PROJECTNAME=$$(shell echo $$(TARGET_BOARD_PLATFORM_VAR) | tr a-z A-Z) BASEBUILDDIR=$$(abspath $$(SOFIA_FIRMWARE_OUT.$(1))) DELIVERY_BUTTER=true PLATFORM=$$(MODEM_PLATFORM)

endef

$(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),\
       $(eval $(call soclib_per_variant,$(variant))))

.PHONY: build_soclib
build_soclib: $(addprefix build_soclib.,$(SOFIA_FIRMWARE_VARIANTS))
