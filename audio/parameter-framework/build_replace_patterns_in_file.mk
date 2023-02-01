# Copyright (c) 2014-2015, Intel Corporation
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation and/or
# other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors
# may be used to endorse or promote products derived from this software without
# specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

include $(BUILD_SYSTEM)/base_rules.mk

ifeq ($(LOCAL_SRC_FILES),)
    $(error $(LOCAL_MODULE): LOCAL_SRC_FILES is not defined)
endif

ifeq ($(REPLACE_PATTERNS),)
    $(error $(LOCAL_MODULE): REPLACE_PATTERNS is not defined)
endif

# Parse patterns and values given by $(REPLACE_PATTERNS) to create a sed rule
SED_RULE :=
PATTERN_SEPARATOR ?= =

parse_pattern_value = \
    $(eval pattern_value_separated := $(subst $(PATTERN_SEPARATOR), ,$(pattern_value))) \
    $(eval pattern := $(firstword $(pattern_value_separated))) \
    $(eval val := $(word 2, $(pattern_value_separated))) \
    $(eval SED_RULE := $(SED_RULE) -e 's|$(pattern)|$(val)|g')

$(foreach pattern_value,$(REPLACE_PATTERNS),$(if $(findstring $(PATTERN_SEPARATOR),$(pattern_value)),$(parse_pattern_value)))

# Check that the sed rule was actually created
$(if $(SED_RULE),,$(error Unable to create a sed rule from REPLACE_PATTERNS:$(REPLACE_PATTERNS). Patterns shall be separated by $(PATTERN_SEPARATOR)))

$(LOCAL_BUILT_MODULE): MY_SED_RULE := $(SED_RULE)

$(LOCAL_BUILT_MODULE): MY_FILE := $(LOCAL_PATH)/$(LOCAL_SRC_FILES)

# Run the sed rule on the input file
$(LOCAL_BUILT_MODULE): $(MY_FILE)
	$(hide) mkdir -p "$(dir $@)"
	sed $(MY_SED_RULE) $(MY_FILE) > $@

# Cleanup
SED_RULE :=
PATTERN_SEPARATOR := =
REPLACE_PATTERNS :=

