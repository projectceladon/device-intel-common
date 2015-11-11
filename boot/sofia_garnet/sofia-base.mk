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
LOCAL_PATH:= $(call my-dir)

#-----------------------
# Common
#-----------------------

FLSTOOL             = $(CURDIR)/device/intel/common/tools/FlsTool
IMAGES_DIR         := $(PRODUCT_OUT)/fls
FLASHFILES_DIR     := $(IMAGES_DIR)/fls
SIGN_FLS_DIR       := $(IMAGES_DIR)/signed_fls
FASTBOOT_IMG_DIR   := $(IMAGES_DIR)/fastboot
FWU_IMG_DIR        := $(IMAGES_DIR)/fwu_image
EXTRACT_TEMP	   := $(SIGN_FLS_DIR)/extract

SOCLIB_SRC_PATH ?= $(SOFIA_FW_SRC_BASE)/soclib
SECVM_SRC_PATH  ?= $(SOFIA_FW_SRC_BASE)/secure_vm
GUESTVM2_SRC_PATH  ?= $(SOFIA_FW_SRC_BASE)/mobilevisor/guests/vm2
MOBILEVISOR_SVC_PATH ?= $(SOFIA_FW_SRC_BASE)/mobilevisor/services
MOBILEVISOR_SRC_PATH ?= $(SOFIA_FW_SRC_BASE)/mobilevisor/products
MOBILEVISOR_REL_PATH ?= $(SOFIA_FW_SRC_BASE)/mobilevisor/release
MOBILEVISOR_GUEST_PATH ?= $(SOFIA_FW_SRC_BASE)/mobilevisor/guests
BLOB_BUILDER_SCRIPT ?= $(MOBILEVISOR_REL_PATH)/tools/vmmBlobBuilder.py
BINARY_MERGE_TOOL = $(MOBILEVISOR_REL_PATH)/tools/binary_merge
VBT_GENERATE_TOOL ?= $(MOBILEVISOR_REL_PATH)/tools/vbtgen
FWU_PACK_GENERATE_TOOL = $(MOBILEVISOR_REL_PATH)/tools/fwpgen

SOFIA_PROVDATA_FILES += $(FLSTOOL)

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

SYSTEM_SIGNED_FLS_LIST ?=

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
