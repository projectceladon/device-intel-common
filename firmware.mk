#
# Copyright 2016 The Android Open Source Project
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
#

ifeq ($(INCLUDE_ALL_FIRMWARE), true)

FIND_IGNORE_FILES := -not -name "*\ *" -not -name "*LICENSE.*" -not -name "*LICENCE.*" \
	-not -name "*Makefile*" -not -name "*WHENCE" -not -name "*README"

LOCAL_FIRMWARES ?= $(filter-out .git/% %.mk,$(subst ./,,$(shell cd $(FIRMWARES_DIR) && find . -type f,l $(FIND_IGNORE_FILES))))

PRODUCT_COPY_FILES := \
	    $(foreach f,$(LOCAL_FIRMWARES),$(FIRMWARES_DIR)/$(f):vendor/firmware/$(f))

else

## List of complete Firmware folders to be copied
LOCAL_FIRMWARE_DIR := \
    intel \
    i915

## List of matching patterns of Firmware bins to be copied
LOCAL_FIRMWARE_PATTERN := \
    iwlwifi

LOCAL_FIRMWARE_SRC += $(foreach f,$(LOCAL_FIRMWARE_PATTERN),$(shell cd $(FIRMWARES_DIR) && find . -iname "*$(f)*" -type f,l ))
LOCAL_FIRMWARE_SRC += $(foreach f,$(LOCAL_FIRMWARE_DIR),$(shell cd $(FIRMWARES_DIR) && find $(f) -type f,l) )

PRODUCT_COPY_FILES := \
    $(foreach f,$(LOCAL_FIRMWARE_SRC),$(FIRMWARES_DIR)/$(f):$(TARGET_COPY_OUT_VENDOR)/firmware/$(f))

endif
