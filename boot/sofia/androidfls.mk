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

# --------------------------------------
# Fls generation of AOSP image files
# -------------------------------------

OEM_FLS                  := $(FLASHFILES_DIR)/oem.fls
OEM_SIGNED_FLS           := $(SIGN_FLS_DIR)/oem_signed.fls

ifneq ($(TARGET_BOARD_PLATFORM), sofia_lte)
ANDROID_SIGNED_FLS_LIST  += $(OEM_SIGNED_FLS)
SOFIA_PROVDATA_FILES += $(OEM_FLS)
endif

$(OEM_FLS): createflashfile_dir $(FLSTOOL) $(INTEL_PRG_FILE) $(INSTALLED_OEMIMAGE_TARGET) $(PSI_RAM_FLB) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag OEM $(INJECT_FLASHLOADER_FLS) $(INSTALLED_OEMIMAGE_TARGET) --replace --to-fls2

.PHONY: oem.fls

oem.fls: $(OEM_FLS)

ifeq ($(findstring sofia3g,$(TARGET_BOARD_PLATFORM)), sofia3g)
android_fls: $(OEM_FLS)
else
android_fls:
	@echo "Android Images: nothing to do"
endif

ifeq ($(GEN_ANDROID_FLS_FILES),true)
droidcore: android_fls
endif

flsinfo:
	@echo "-------------------------------------------------------------"
	@echo " Android Images:"
	@echo "-make oem.fls : Will create fls file for oem image."

build_info: flsinfo

.PHONY: boot.fls
BOOTIMG_FLS := $(FLASHFILES_DIR)/boot.fls
boot.fls: $(BOOTIMG_FLS)
#boot.fls: bootimage
$(BOOTIMG_FLS): createflashfile_dir $(FLSTOOL) $(INTEL_PRG_FILE) $(BUILT_RAMDISK_TARGET) $(INSTALLED_KERNEL_TARGET) bootimage $(INSTALLED_BOOTIMAGE_TARGET) $(FLASHLOADER_FLS)
	$(FLSTOOL) --prg $(INTEL_PRG_FILE) --output $@ --tag BOOT_IMG $(INJECT_FLASHLOADER_FLS) $(INSTALLED_BOOTIMAGE_TARGET) --replace --to-fls2

