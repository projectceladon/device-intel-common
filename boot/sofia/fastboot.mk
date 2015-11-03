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

DATA_EXT_NAME := *.fls_ID0_*_LoadMap*
SECP_EXT_NAME := *.fls_ID0_*_SecureBlock.bin

define fastboot_per_variant

FASTBOOT_FLS_LIST.$(1)  :=
BOOTLOADER_SIGNED_FLS_LIST.$(1)  :=
FASTBOOT_FLS_LIST.$(1)  += $$(PSI_FLASH_FLS.$(1))
FASTBOOT_FLS_LIST.$(1)  += $$(SLB_FLS.$(1))
FASTBOOT_FLS_LIST.$(1)  += $$(UCODE_PATCH_FLS.$(1))
FASTBOOT_FLS_LIST.$(1)  += $$(SPLASH_IMG_FLS.$(1))
FASTBOOT_FLS_LIST.$(1)  += $$(MOBILEVISOR_FLS.$(1))
FASTBOOT_FLS_LIST.$(1)  += $$(MV_CONFIG_DEFAULT_FLS.$(1))
FASTBOOT_FLS_LIST.$(1)  += $$(SECVM_FLS.$(1))

.PHONY: fastboot_img.$(1)
define FB_IMG_GEN
fastboot_$$(basename $$(notdir $$(1))).$(1): force $$(1) | createflashfile_dir $$(ACP)
	$$(FLSTOOL) -o $$(EXTRACT_TEMP.$(1))/$$(basename $$(notdir $$(1))) -x $$(1)
	echo $$(ACP) $$(EXTRACT_TEMP.$(1))/$$(basename $$(notdir $$(1)))/$$(DATA_EXT_NAME) $$(FASTBOOT_IMG_DIR.$(1))/$$(basename $$(notdir $$(1))).bin
	cat $$(EXTRACT_TEMP.$(1))/$$(basename $$(notdir $$(1)))/$$(DATA_EXT_NAME) > $$(FASTBOOT_IMG_DIR.$(1))/$$(basename $$(notdir $$(1))).bin
fastboot_img.$(1): fastboot_$$(basename $$(notdir $$(1))).$(1)
endef

$$(foreach t,$$(FASTBOOT_FLS_LIST.$(1)),$$(eval $$(call FB_IMG_GEN,$$(t))))

#fastboot_img:  $$(FASTBOOT_FLS_LIST) | createflashfile_dir
#$$(foreach f, $$(FASTBOOT_FLS_LIST), $$(shell $$(FLSTOOL) -x $$(f) -o $$(EXTRACT_TEMP)))

BOOTLOADER_SIGNED_FLS_LIST.$(1)  += $$(basename $$(notdir $$(PSI_FLASH_SIGNED_FLS.$(1))))
BOOTLOADER_SIGNED_FLS_LIST.$(1)  += $$(basename $$(notdir $$(SLB_SIGNED_FLS.$(1))))
BOOTLOADER_SIGNED_FLS_LIST.$(1)  += $$(basename $$(notdir $$(SYSTEM_SIGNED_FLS_LIST.$(1))))

BOOTLOADER_DEP.$(1) := $$(addprefix $$(EXTRACT_TEMP.$(1))/,$$(BOOTLOADER_SIGNED_FLS_LIST.$(1)))

BOOTLOADER_IMAGE.$(1) := $$(FASTBOOT_IMG_DIR.$(1))/bootloader

bootloader_img.$(1): fastboot_img.$(1) $$(BOOTLOADER_DEP.$(1)) | createflashfile_dir $${ACP}
	$$(foreach a, $$(BOOTLOADER_DEP.$(1)), $$(shell $$(FWU_PACK_GENERATE_TOOL) --input $$(BOOTLOADER_IMAGE.$(1)) --output $$(BOOTLOADER_IMAGE.$(1))_temp --secpack $$(a)/$$(SECP_EXT_NAME) --data $$(a)/$$(DATA_EXT_NAME) ; acp $$(BOOTLOADER_IMAGE.$(1))_temp $$(BOOTLOADER_IMAGE.$(1))))
	rm $$(BOOTLOADER_IMAGE.$(1))_temp

$$(BOOTLOADER_IMAGE.$(1)) : bootloader_img.$(1)

SOFIA_PROVDATA_FILES.$(1) += $$(BOOTLOADER_IMAGE.$(1))

endef

$(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),\
       $(eval $(call fastboot_per_variant,$(variant))))

.PHONY: fastboot_img
fastboot_img: $(addprefix fastboot_img.,$(SOFIA_FIRMWARE_VARIANTS))

droidcore: fastboot_img
