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

#########################################################################
# This file originated in WPRD's android/device/intel/common/Android.mk #
# It has been adapted to function in the GMIN build system              #
#########################################################################

LOCAL_PATH:= $(call my-dir)

#-----------------------
# Common
#-----------------------

FLSTOOL                          = $(CURDIR)/device/intel/common/tools/FlsTool
INSTALLED_OEMIMAGE_TARGET        = $(CURDIR)/device/intel/common/oem/oem.img
IMAGES_DIR                      :=
FLASHFILES_DIR                  :=
SIGN_FLS_DIR                    :=
FASTBOOT_IMG_DIR                :=
FWU_IMG_DIR                     :=
EXTRACT_TEMP                    :=

SOCLIB_SRC_PATH                 ?= $(SOFIA_FW_SRC_BASE)/soclib
SECVM_SRC_PATH                  ?= $(SOFIA_FW_SRC_BASE)/secure_vm
GUESTVM2_SRC_PATH               ?= $(SOFIA_FW_SRC_BASE)/mobilevisor/guests/vm2
MOBILEVISOR_SVC_PATH            ?= $(SOFIA_FW_SRC_BASE)/mobilevisor/services
MOBILEVISOR_SRC_PATH            ?= $(SOFIA_FW_SRC_BASE)/mobilevisor/products
MOBILEVISOR_REL_PATH            ?= $(SOFIA_FW_SRC_BASE)/mobilevisor/release
MOBILEVISOR_GUEST_PATH          ?= $(SOFIA_FW_SRC_BASE)/mobilevisor/guests
BLOB_BUILDER_SCRIPT             ?= $(MOBILEVISOR_REL_PATH)/tools/vmmBlobBuilder.py
BINARY_MERGE_TOOL                = $(MOBILEVISOR_REL_PATH)/tools/binary_merge
VBT_GENERATE_TOOL               ?= $(MOBILEVISOR_REL_PATH)/tools/vbtgen$(if $(findstring 3gr,$(TARGET_BOARD_PLATFORM)),_vop)
FWU_PACK_GENERATE_TOOL           = $(MOBILEVISOR_REL_PATH)/tools/fwpgen

TARGET_BOARD_PLATFORM_VAR       ?= $(TARGET_BOARD_PLATFORM)
SOFIA_FIRMWARE_VARIANTS         ?= $(TARGET_PRODUCT)
MODEM_PROJECTNAME_VAR           ?= $(MODEM_PROJECTNAME)

define sofia_base_per_variant

ifeq ($(words $(SOFIA_FIRMWARE_VARIANTS)),1)
IMAGES_DIR.$(1)                 := $$(PRODUCT_OUT)/fls
else
IMAGES_DIR.$(1)                 := $$(PRODUCT_OUT)/fls_$(1)_$(TARGET_BUILD_VARIANT)
endif

SOFIA_PROVDATA_FILES.$(1)       += $$(FLSTOOL)
INTEL_PRG_FILE.$(1)             := $$(INTEL_PRG_FILE)
MV_CONFIG_DEFAULT_TYPE.$(1)     := $$(MV_CONFIG_DEFAULT_TYPE)
FLASHFILES_DIR.$(1)             := $$(IMAGES_DIR.$(1))/fls
SIGN_FLS_DIR.$(1)               := $$(IMAGES_DIR.$(1))/signed_fls
FASTBOOT_IMG_DIR.$(1)           := $$(IMAGES_DIR.$(1))/fastboot
FWU_IMG_DIR.$(1)                := $$(IMAGES_DIR.$(1))/fwu_image
EXTRACT_TEMP.$(1)               := $$(SIGN_FLS_DIR.$(1))/extract

IMAGES_DIR                      += $$(IMAGES_DIR.$(1))
FLASHFILES_DIR                  += $$(FLASHFILES_DIR.$(1))
SIGN_FLS_DIR                    += $$(SIGN_FLS_DIR.$(1))
FASTBOOT_IMG_DIR                += $$(FASTBOOT_IMG_DIR.$(1))
FWU_IMG_DIR                     += $$(FWU_IMG_DIR.$(1))
EXTRACT_TEMP                    += $$(EXTRACT_TEMP.$(1))

SOFIA_FIRMWARE_OUT.$(1)         := $$(PRODUCT_OUT)/sofia_fw_$$(TARGET_BUILD_VARIANT)/$(1)
$$(SOFIA_FIRMWARE_OUT.$(1)):
	mkdir -p $$@

endef

$(foreach variant,$(SOFIA_FIRMWARE_VARIANTS),\
       $(eval $(call sofia_base_per_variant,$(variant))))

FASTBOOT_IMG_DIR := $(strip $(FASTBOOT_IMG_DIR))

.PHONY: createflashfile_dir
createflashfile_dir:
	mkdir -p $(IMAGES_DIR)
	mkdir -p $(FLASHFILES_DIR)
	mkdir -p $(FWU_IMG_DIR)
	mkdir -p $(FASTBOOT_IMG_DIR)
	mkdir -p $(EXTRACT_TEMP)
	mkdir -p $(SIGN_FLS_DIR)

droidcore: createflashfile_dir

.PHONY: build_info
build_info:
	@echo "-------------------------------------------"

include $(LOCAL_PATH)/createprg.mk
include $(LOCAL_PATH)/soclib.mk
include $(LOCAL_PATH)/mobilevisor_svc.mk
include $(LOCAL_PATH)/bootcore.mk
include $(LOCAL_PATH)/mobilevisor_config.mk
include $(LOCAL_PATH)/mobilevisor.mk
include $(LOCAL_PATH)/secvm.mk
#include $(LOCAL_PATH)/kernel.mk
include $(LOCAL_PATH)/threadx.mk
include $(LOCAL_PATH)/modem.mk
include $(LOCAL_PATH)/guestvm.mk
include $(LOCAL_PATH)/androidfls.mk
include $(LOCAL_PATH)/signfls.mk
include $(LOCAL_PATH)/fastboot.mk

include $(all-subdir-makefiles)

ifeq ($(words $(SOFIA_FIRMWARE_VARIANTS)),1)
SOFIA_PROVDATA_FILES += $(SOFIA_PROVDATA_FILES.$(word 1,$(SOFIA_FIRMWARE_VARIANTS))) $(INTEL_PRG_FILE)
endif
