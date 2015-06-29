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
ifeq ($(DELIVERY_BUTTER), true)
SOCLIB_BUILD_OUT := $(CURDIR)/../images
else
SOCLIB_BUILD_OUT := $(CURDIR)/$(PRODUCT_OUT)
endif

BUILT_LIBSOC_TARGET := $(SOCLIB_BUILD_OUT)/lib_soc/lib_soc.a

TARGET_BOARD_PLATFORM_VAR ?= $(TARGET_BOARD_PLATFORM)

$(BUILT_LIBSOC_TARGET): build_soclib

build_soclib:
	@echo Building ===== lib_soc =====
	$(if SOCLIB_FEATURES, FEATURE="$(SOCLIB_FEATURES)") \
	$(MAKE) -C $(SOCLIB_SRC_PATH) PROJECTNAME=$(shell echo $(TARGET_BOARD_PLATFORM_VAR) | tr a-z A-Z) BASEBUILDDIR=$(SOCLIB_BUILD_OUT) DELIVERY_BUTTER=true PLATFORM=$(MODEM_PLATFORM)

.PHONY: vmm_lib_soc
vmm_lib_soc: $(BUILT_LIBSOC_TARGET)

