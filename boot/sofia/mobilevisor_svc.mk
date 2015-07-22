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
MOBILEVISOR_SVC_BUILD_OUT := $(CURDIR)/$(PRODUCT_OUT)

BUILT_LIB_MOBILEVISOR_SVC_TARGET := $(MOBILEVISOR_SVC_BUILD_OUT)/lib_mobilevisor_service/lib_mobilevisor_service.a

TARGET_BOARD_PLATFORM_VAR ?= $(TARGET_BOARD_PLATFORM)

$(BUILT_LIB_MOBILEVISOR_SVC_TARGET): build_mobilevisor_service

build_mobilevisor_service:
	@echo Building ===== lib_mobilevisor_service =====
	$(MAKE) -C $(MOBILEVISOR_SVC_PATH) PROJECTNAME=$(shell echo $(TARGET_BOARD_PLATFORM_VAR) | tr a-z A-Z) BASEBUILDDIR=$(MOBILEVISOR_SVC_BUILD_OUT) PLATFORM=$(MODEM_PLATFORM)

.PHONY: vmm_lib_mobilevisor_service
vmm_lib_mobilevisor_service: $(BUILT_LIB_MOBILEVISOR_SVC_TARGET)

