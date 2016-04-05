LOCAL_PATH := $(call my-dir)

define copy_file
include $(CLEAR_VARS)
LOCAL_PATH := $(2)
LOCAL_MODULE := $(notdir $(1))
LOCAL_SRC_FILES := $(3)/$(strip $1)
LOCAL_MODULE_OWNER := intel
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $4
LOCAL_PROPRIETARY_MODULE := true
include $(BUILD_PREBUILT)
endef

# Creation of hash file
include $(CLEAR_VARS)
LOCAL_MODULE := hash
LOCAL_MODULE_OWNER := intel
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/firmware/telephony
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE) : $(STREAMLINE_TLVS) $(MDM_FW_FILES)
	@echo "Building telephony hash file"
	$(hide) rm -fr $(dir $@)
	$(hide) mkdir -p $(dir $@)
	$(hide) cat $(STREAMLINE_TLVS) $(MDM_FW_FILES) | md5sum | tr -d ' -' > $@

# TCS1. @TODO: remove this
TCS_XMLS := $(notdir $(wildcard $(LOCAL_PATH)/hw_config/tcs/*.xml))
$(foreach xml, $(TCS_XMLS), $(eval $(call copy_file, $(xml), $(LOCAL_PATH), hw_config/tcs, $(TARGET_OUT_VENDOR)/etc/telephony)))

# TCS2
TCS2_XMLS := $(notdir $(wildcard $(LOCAL_PATH)/hw_config/tcs2/*.xml))
$(foreach xml, $(TCS2_XMLS), $(eval $(call copy_file, $(xml), $(LOCAL_PATH), hw_config/tcs2, $(TARGET_OUT_VENDOR)/etc/telephony/tcs/config)))

STREAMLINE_XMLS := $(notdir $(wildcard $(LOCAL_PATH)/streamline/xmls/*.xml))
$(foreach xml, $(STREAMLINE_XMLS), $(eval $(call copy_file, $(xml), $(LOCAL_PATH), streamline/xmls, $(TARGET_OUT_VENDOR)/etc/telephony/tcs/streamline)))

NVM_XMLS := $(notdir $(wildcard $(LOCAL_PATH)/nvm/*.xml))
$(foreach xml, $(NVM_XMLS), $(eval $(call copy_file, $(xml), $(LOCAL_PATH), nvm, $(TARGET_OUT_VENDOR)/etc/telephony/tcs/nvm)))

# TLV files
STREAMLINE_TLVS := $(notdir $(wildcard $(LOCAL_PATH)/streamline/tlvs/*.tlv))
$(foreach tlv, $(STREAMLINE_TLVS), $(eval $(call copy_file, $(tlv), $(LOCAL_PATH), streamline/tlvs, $(TARGET_OUT_VENDOR)/firmware/telephony)))

# modem firmwares
MDM_FW_FILES := $(foreach mdm, $(BOARD_MODEM_LIST), $(wildcard vendor/intel/fw/modem/IMC/*/$(mdm)/*.fls))
$(foreach fw, $(MDM_FW_FILES), $(eval $(call copy_file, $(fw), ., , $(TARGET_OUT_VENDOR)/firmware/telephony)))

# Geo file used by M2 module
XML_GEO_FILE := $(foreach mdm, $(BOARD_MODEM_LIST), $(wildcard vendor/intel/fw/modem/IMC/*/$(mdm)/*.xml))
$(if $(strip $(XML_GEO_FILE)), $(eval $(call copy_file, $(XML_GEO_FILE), ., , $(TARGET_OUT_VENDOR)/firmware/telephony)))

include $(CLEAR_VARS)
LOCAL_MODULE := mdm_fw_pkg
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := intel
LOCAL_REQUIRED_MODULES := $(STREAMLINE_TLVS) $(XML_GEO_FILE) $(notdir $(MDM_FW_FILES)) hash
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := tcs_hw_xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := intel
LOCAL_REQUIRED_MODULES := $(TCS_XMLS)
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := tcs2_hw_xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := intel
LOCAL_REQUIRED_MODULES := $(TCS2_XMLS) $(STREAMLINE_XMLS) $(NVM_XMLS)
include $(BUILD_PHONY_PACKAGE)
