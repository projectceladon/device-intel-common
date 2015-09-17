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
VMM_BUILD_OUT := $(CURDIR)/$(PRODUCT_OUT)/vmm_build

#Required Intermiediate and final targets.
BUILT_VMM_TARGET          := $(VMM_BUILD_OUT)/mobilevisor/mobilevisor.hex
BUILT_VMM_TARGET_BIN	  := $(VMM_BUILD_OUT)/mobilevisor/mobilevisor.bin

##Temp Fix for override of Whole archive lib list.
BUILT_MV_CORE_BIN       ?= $(MOBILEVISOR_REL_PATH)/lib_mobilevisor_core/debug/linux/lib_mobilevisor_core.a

MOBILEVISOR_FLS         := $(FLASHFILES_DIR)/mobilevisor.fls
SYSTEM_SIGNED_FLS_LIST  += $(SIGN_FLS_DIR)/mobilevisor_signed.fls

ifeq ($(GEN_MV_RAM_DEFS_FROM_XML), true)
	MOBILEVISOR_OPTION_common := __MV_RAM_LAYOUT_DEFS_FROM_XML__
	MOBILEVISOR_INCLUDE_common := $(VMM_BUILD_OUT)/mobilevisor
	MV_RAM_DEFS_FILE := $(CURDIR)/$(PRODUCT_OUT)/ram_layout.h
	MV_RAM_DEFS_DEST_FILE := $(VMM_BUILD_OUT)/mobilevisor/ram_layout.h
else
	MOBILEVISOR_OPTION_common :=
	MOBILEVISOR_INCLUDE_common :=
endif

###########################
# create rules
###########################
.PHONY : force
force: ;

$(VMM_BUILD_OUT):
	mkdir -p $(VMM_BUILD_OUT)

ifeq ($(GEN_MV_RAM_DEFS_FROM_XML), true)
$(MV_RAM_DEFS_DEST_FILE): force | $(VMM_BUILD_OUT) prg
	mkdir -p $(VMM_BUILD_OUT)/mobilevisor
	if [ -a $(MV_RAM_DEFS_FILE) ]; \
	then diff  $(MV_RAM_DEFS_FILE) $(MV_RAM_DEFS_DEST_FILE) || cp -f $(MV_RAM_DEFS_FILE) $(MV_RAM_DEFS_DEST_FILE); \
	else echo "Error: Required ram layout file $(MV_RAM_DEFS_FILE) was not found!"; exit 1; \
	fi
endif

TARGET_BOARD_PLATFORM_VAR ?= $(TARGET_BOARD_PLATFORM)

#Override hardcoded LIBSOC path with WHOLE_ARCHIVE_LIB_LIST. Otherwise build fails
$(BUILT_VMM_TARGET) $(BUILT_VMM_TARGET_BIN): build_vmm_target

ifeq ($(GEN_MV_RAM_DEFS_FROM_XML), true)
build_vmm_target: $(BUILT_LIBSOC_TARGET) $(BUILT_LIB_MOBILEVISOR_SVC_TARGET) | $(MV_RAM_DEFS_DEST_FILE)
else
build_vmm_target: $(BUILT_LIBSOC_TARGET) $(BUILT_LIB_MOBILEVISOR_SVC_TARGET)
endif
	@echo Building ===== mobilevisor ======
	make -C $(MOBILEVISOR_SRC_PATH) PROJECTNAME=$(shell echo $(TARGET_BOARD_PLATFORM_VAR) | tr a-z A-Z) BASEBUILDDIR=$(VMM_BUILD_OUT) WHOLE_ARCHIVE_LIB_LIST+="$(BUILT_LIBSOC_TARGET) $(BUILT_LIB_MOBILEVISOR_SVC_TARGET) $(BUILT_MV_CORE_BIN)" PLATFORM=$(MODEM_PLATFORM) C_DEFINES=$(MOBILEVISOR_OPTION_common) INCLUDEDIR=$(MOBILEVISOR_INCLUDE_common)

$(MOBILEVISOR_FLS): createflashfile_dir $(FLSTOOL) $(INTEL_PRG_FILE) $(BUILT_VMM_TARGET) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag MOBILEVISOR $(INJECT_FLASHLOADER_FLS) $(BUILT_VMM_TARGET) --replace --to-fls2

# Build VMM images as dependency to default android build target "droidcore"
ifeq ($(GEN_VMM_FLS_FILES),true)
droidcore: $(MOBILEVISOR_FLS)
else
droidcore: $(BUILT_VMM_TARGET)
ifeq ($(PRODUCT_NAME),SfLTE_vp)
	@echo "Build Kernel Image file for VP..."
	$(mk_kernel) Image
	@echo "Pack Android Minimal file system to rootfs in $(PRODUCT_OUT)"
	rm -f -r $(PRODUCT_OUT)/root/system
	cp -f -r $(PRODUCT_OUT)/system $(PRODUCT_OUT)/root/system
	rm -f $(PRODUCT_OUT)/root/system/app/*
	rm -f $(PRODUCT_OUT)/root/system/lib/libwebcore.so
	rm -f $(PRODUCT_OUT)/root/system/lib/libchromium*.so
	rm -f $(PRODUCT_OUT)/root/system/lib/libwebview*.so
	rm -f $(PRODUCT_OUT)/root/system/lib/libwebview*.so
	rm -f $(PRODUCT_OUT)/root/system/bin/houdini
	rm -f -r $(PRODUCT_OUT)/root/system/lib/arm
	rm -f -r $(PRODUCT_OUT)/root/system/lib/*houdini*
	./out/host/linux-x86/bin/mkbootfs $(PRODUCT_OUT)/root | out/host/linux-x86/bin/minigzip  > $(PRODUCT_OUT)/tmp_ramdisk.img
	#using uncompressed filesystem reduces boot time significantly on VP.
	zcat $(PRODUCT_OUT)/tmp_ramdisk.img > $(PRODUCT_OUT)/ramdisk.img
	rm -f -r $(PRODUCT_OUT)/root/system
	rm -f -r $(PRODUCT_OUT)/tmp_ramdisk.img
	python $(BLOB_BUILDER_SCRIPT) --xml $(BLOB_GEN_XML_FILE) --out $(FLASHFILES_DIR) --root $(CURDIR)
endif
endif

.PHONY: mobilevisor.fls
mobilevisor.fls:  $(MOBILEVISOR_FLS)

.PHONY: mobilevisor_clean
mobilevisor_clean: $(VMM_BUILD_OUT) $(INSTALLED_VMM_TARGET)
	@echo Deleting mobilevisor build files
	rm -rf $(VMM_BUILD_OUT)

.PHONY: mobilevisor_rebuild
mobilevisor_rebuild: mobilevisor_clean $(MOBILEVISOR_FLS)

mobilevisor_info:
	@echo "---------------------------------------------------------------------"
	@echo "Mobilevisor:"
	@echo "-make mobilevisor.fls : Will generate fls file for mobilevisor binary"
	@echo "-make mobilevisor_rebuild : Will clean and regenerate the mobilevisor fls files."

build_info: mobilevisor_info
endif

ifeq ($(DELIVERY_BUTTER), true)
MOBILEVISOR_FLS  := $(FLASHFILES_DIR)/mobilevisor.fls
MVCONFIG_FLS  := $(FLASHFILES_DIR)/mvconfig.fls
MVCONFIG_SMP_FLS  := $(FLASHFILES_DIR)/mvconfig_smp.fls

#Required Intermiediate and final targets.
BUILT_VMM_TARGET          := $(SOFIA_FW_SRC_BASE)/images/vmm_build/mobilevisor/mobilevisor.hex
BUILT_VMM_TARGET_BIN      := $(SOFIA_FW_SRC_BASE)/images/vmm_build/mobilevisor/mobilevisor.bin
BUILT_SMP_MVCONFIG_TARGET := $(SOFIA_FW_SRC_BASE)/images/mobilevisor/release/prebuilt/mvconfig_smp.bin
BUILT_LIB_MOBILEVISOR_SVC_TARGET := $(SOFIA_FW_SRC_BASE)/images/vmm_build/lib_mobilevisor_service/lib_mobilevisor_service.a
VMM_BUILD_OUT := $(SOFIA_FW_SRC_BASE)/images/vmm_build
BUILT_MV_CORE_BIN ?= $(SOFIA_FW_SRC_BASE)/mobilevisor/release/lib_mobilevisor_core/debug/linux/lib_mobilevisor_core.a

$(BUILT_VMM_TARGET) $(BUILT_VMM_TARGET_BIN): build_vmm_target

build_vmm_target: $(BUILT_LIBSOC_TARGET)
	@echo Building ===== mobilevisor ======
	make -C $(MOBILEVISOR_SRC_PATH) PROJECTNAME=$(shell echo $(TARGET_BOARD_PLATFORM_VAR) | tr a-z A-Z) BASEBUILDDIR=$(VMM_BUILD_OUT) WHOLE_ARCHIVE_LIB_LIST+="$(BUILT_LIBSOC_TARGET) $(BUILT_LIB_MOBILEVISOR_SVC_TARGET) $(BUILT_MV_CORE_BIN)" PLATFORM=$(MODEM_PLATFORM)

$(MOBILEVISOR_FLS): createflashfile_dir $(FLSTOOL) $(INTEL_PRG_FILE) $(BUILT_VMM_TARGET) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag MOBILEVISOR $(INJECT_FLASHLOADER_FLS) $(BUILT_VMM_TARGET) --replace --to-fls2

$(MVCONFIG_SMP_FLS): createflashfile_dir $(FLSTOOL) $(INTEL_PRG_FILE) $(BUILT_SMP_MVCONFIG_TARGET) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag MV_CONFIG $(INJECT_FLASHLOADER_FLS) $(BUILT_SMP_MVCONFIG_TARGET) --replace --to-fls2

.PHONY: mobilevisor.fls
mobilevisor.fls:  $(MOBILEVISOR_FLS)
droidcore: mobilevisor.fls

.PHONY: mvconfig_smp.fls
mvconfig_smp.fls:  $(MVCONFIG_SMP_FLS)
droidcore: mvconfig_smp.fls

endif

