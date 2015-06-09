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
FASTBOOT_FLS_LIST  :=
ifeq ($(findstring sofia3g,$(TARGET_BOARD_PLATFORM)),sofia3g)
ifneq ($(TARGET_NO_RECOVERY),true)
FASTBOOT_FLS_LIST  += $(RECOVERY_FLS)
endif
endif
FASTBOOT_FLS_LIST  += $(BOOTIMG_FLS)
FASTBOOT_FLS_LIST  += $(CACHE_FLS)
FASTBOOT_FLS_LIST  += $(USERDATA_FLS)
FASTBOOT_FLS_LIST  += $(SYSTEM_FLS)
FASTBOOT_FLS_LIST  += $(PSI_FLASH_FLS)
FASTBOOT_FLS_LIST  += $(SLB_FLS)
FASTBOOT_FLS_LIST  += $(UCODE_PATCH_FLS)
FASTBOOT_FLS_LIST  += $(SPLASH_IMG_FLS)
FASTBOOT_FLS_LIST  += $(MOBILEVISOR_FLS)
FASTBOOT_FLS_LIST  += $(MV_CONFIG_DEFAULT_FLS)
FASTBOOT_FLS_LIST  += $(SECVM_FLS)

DATA_EXT_NAME := *.fls_ID0_*_LoadMap*

.PHONY: fastboot_img
define FB_IMG_GEN
fastboot_$(basename $(notdir $(1))): force $(1) | createflashfile_dir $(ACP)
	$(FLSTOOL) -o $(EXTRACT_TEMP)/$(basename $(notdir $(1))) -x $(1)
	echo $(ACP) $(EXTRACT_TEMP)/$(basename $(notdir $(1)))/$(DATA_EXT_NAME) $(FASTBOOT_IMG_DIR)/$(basename $(notdir $(1))).bin
	cat $(EXTRACT_TEMP)/$(basename $(notdir $(1)))/$(DATA_EXT_NAME) > $(FASTBOOT_IMG_DIR)/$(basename $(notdir $(1))).bin
fastboot_img: fastboot_$(basename $(notdir $(1)))
endef

$(foreach t,$(FASTBOOT_FLS_LIST),$(eval $(call FB_IMG_GEN,$(t))))

#fastboot_img:  $(FASTBOOT_FLS_LIST) | createflashfile_dir
#$(foreach f, $(FASTBOOT_FLS_LIST), $(shell $(FLSTOOL) -x $(f) -o $(EXTRACT_TEMP)))

droidcore: fastboot_img
