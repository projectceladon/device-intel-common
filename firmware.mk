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

FIND_IGNORE_FILES := -not -name "*\ *" -not -name "*LICENSE.*" -not -name "*LICENCE.*" \
	-not -name "*Makefile*" -not -name "*WHENCE" -not -name "*README"

LOCAL_FIRMWARES ?= $(filter-out .git/% %.mk,$(subst ./,,$(shell cd $(FIRMWARES_DIR) && find . -type f $(FIND_IGNORE_FILES))))

PRODUCT_COPY_FILES := \
	    $(foreach f,$(LOCAL_FIRMWARES),$(FIRMWARES_DIR)/$(f):vendor/firmware/$(f))
