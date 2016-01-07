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
ifeq ($(BUILD_VMM_FROM_SRC),true)
#Source Paths configured in Base Android.mk
#Build Output path.

BUILT_MV_CORE_BIN       := $(MOBILEVISOR_REL_PATH)/lib_mobilevisor_core/debug/linux/lib_mobilevisor_core.a

define mobilevisor_per_variant

VMM_BUILD_OUT.$(1) := $$(SOFIA_FIRMWARE_OUT.$(1))/vmm_build
VMM_BUILD_OUT := $$(VMM_BUILD_OUT.$(1))

#Required Intermiediate and final targets.
BUILT_VMM_TARGET.$(1)           := $$(VMM_BUILD_OUT.$(1))/mobilevisor/mobilevisor.hex
BUILT_VMM_TARGET_BIN.$(1)       := $$(VMM_BUILD_OUT.$(1))/mobilevisor/mobilevisor.bin

MOBILEVISOR_FLS.$(1)            := $$(FLASHFILES_DIR.$(1))/mobilevisor.fls
MOBILEVISOR_SIGNED_FLS.$(1)     := $$(SIGN_FLS_DIR.$(1))/mobilevisor_signed.fls
SYSTEM_SIGNED_FLS_LIST.$(1)     += $$(MOBILEVISOR_SIGNED_FLS.$(1))

ifeq ($$(GEN_MV_RAM_DEFS_FROM_XML), true)
MOBILEVISOR_OPTION_common.$(1) := __MV_RAM_LAYOUT_DEFS_FROM_XML__
MOBILEVISOR_INCLUDE_common.$(1) := $$(VMM_BUILD_OUT.$(1))/mobilevisor
MV_RAM_DEFS_FILE.$(1) := $$(SOFIA_FIRMWARE_OUT.$(1))/ram_layout.h
MV_RAM_DEFS_DEST_FILE.$(1) := $$(VMM_BUILD_OUT.$(1))/mobilevisor/ram_layout.h
else
MOBILEVISOR_OPTION_common.$(1) :=
MOBILEVISOR_INCLUDE_common.$(1) :=
endif

###########################
# create rules
###########################
.PHONY : force
force: ;


$$(VMM_BUILD_OUT.$(1)):
	mkdir -p $$(VMM_BUILD_OUT.$(1))

ifeq ($$(GEN_MV_RAM_DEFS_FROM_XML), true)
$$(MV_RAM_DEFS_DEST_FILE.$(1)): force | $$(VMM_BUILD_OUT.$(1)) prg
	mkdir -p $$(VMM_BUILD_OUT.$(1))/mobilevisor
	if [ -a $$(MV_RAM_DEFS_FILE.$(1)) ]; \
	then diff  $$(MV_RAM_DEFS_FILE.$(1)) $$(MV_RAM_DEFS_DEST_FILE.$(1)) || cp -f $$(MV_RAM_DEFS_FILE.$(1)) $$(MV_RAM_DEFS_DEST_FILE.$(1)); \
	else echo "Error: Required ram layout file $$(MV_RAM_DEFS_FILE.$(1)) was not found!"; exit 1; \
	fi
endif


#Override hardcoded LIBSOC path with WHOLE_ARCHIVE_LIB_LIST. Otherwise build fails
$$(BUILT_VMM_TARGET.$(1)) $$(BUILT_VMM_TARGET_BIN.$(1)): build_vmm_target.$(1)

.PHONY: build_vmm_target.$(1)
ifeq ($$(GEN_MV_RAM_DEFS_FROM_XML), true)
build_vmm_target.$(1): $$(BUILT_LIBSOC_TARGET.$(1)) $$(BUILT_LIB_MOBILEVISOR_SVC_TARGET.$(1)) | $$(MV_RAM_DEFS_DEST_FILE.$(1))
else
build_vmm_target.$(1): $$(BUILT_LIBSOC_TARGET.$(1)) $$(BUILT_LIB_MOBILEVISOR_SVC_TARGET.$(1))
endif
	@echo Building ===== mobilevisor.$(1) ======
	$$(MAKE) -C $$(MOBILEVISOR_SRC_PATH) PROJECTNAME=$$(shell echo $$(TARGET_BOARD_PLATFORM_VAR) | tr a-z A-Z) BASEBUILDDIR=$$(abspath $$(VMM_BUILD_OUT.$(1))) WHOLE_ARCHIVE_LIB_LIST+="$$(abspath $$(BUILT_LIBSOC_TARGET.$(1))) $$(abspath $$(BUILT_LIB_MOBILEVISOR_SVC_TARGET.$(1))) $$(abspath $$(BUILT_MV_CORE_BIN))" PLATFORM=$$(MODEM_PLATFORM) C_DEFINES=$$(MOBILEVISOR_OPTION_common.$(1)) INCLUDEDIR=$$(abspath $$(MOBILEVISOR_INCLUDE_common.$(1)))

$$(MOBILEVISOR_FLS.$(1)): createflashfile_dir $$(FLSTOOL) $$(INTEL_PRG_FILE.$(1)) $$(BUILT_VMM_TARGET.$(1)) $$(FLASHLOADER_FLS.$(1))
	$$(FLSTOOL) --prg $$(INTEL_PRG_FILE.$(1)) --output $$@ --tag MOBILEVISOR $$(INJECT_FLASHLOADER_FLS.$(1)) $$(BUILT_VMM_TARGET.$(1)) --replace --to-fls2

.PHONY: mobilevisor.fls.$(1)
mobilevisor.fls.$(1): $$(MOBILEVISOR_FLS.$(1))

.PHONY: mobilevisor_clean.$(1)
mobilevisor_clean.$(1):
	@echo Deleting mobilevisor build files
	rm -rf $$(VMM_BUILD_OUT.$(1))

SOFIA_PROVDATA_FILES.$(1) += $$(MVCONFIG_SMP_FLS.$(1))

endef

$(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),\
       $(eval $(call mobilevisor_per_variant,$(variant))))

.PHONY: mobilevisor.fls
mobilevisor.fls: $(addprefix mobilevisor.fls.,$(SOFIA_FIRMWARE_VARIANTS))

droidcore: mobilevisor.fls

.PHONY: mobilevisor_clean
mobilevisor_clean: $(addprefix mobilevisor_clean.,$(SOFIA_FIRMWARE_VARIANTS))

.PHONY: mobilevisor_rebuild
mobilevisor_rebuild: mobilevisor_clean mobilevisor.fls

mobilevisor_info:
	@echo "---------------------------------------------------------------------"
	@echo "Mobilevisor:"
	@echo "-make mobilevisor.fls : Will generate fls file for mobilevisor binary"
	@echo "-make mobilevisor_rebuild : Will clean and regenerate the mobilevisor fls files."

build_info: mobilevisor_info
endif
