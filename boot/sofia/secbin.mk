# Mechanisms to generate .secbin files for OTA packages below
# These files are essentially a binary dump of what will exist in the
# partitions on target


SECBIN_OUT  		:= $(PRODUCT_OUT)/secbin
SECBIN_TEMP		:= $(SECBIN_OUT)/temp
BOOTIMG_SECBIN		:= $(SECBIN_OUT)/boot.secbin
RECOVERY_SECBIN     	:= $(SECBIN_OUT)/recovery.secbin
MEX_SECBIN		:= $(SECBIN_OUT)/modem.secbin
MOBILEVISOR_SECBIN	:= $(SECBIN_OUT)/mobilevisor.secbin
SPLASH_SECBIN		:= $(SECBIN_OUT)/splash_img.secbin
SECVM_SECBIN		:= $(SECBIN_OUT)/secvm.secbin
MVCONFIG_SECBIN		:= $(SECBIN_OUT)/mobilevisor_config.secbin

SYSTEM_SEC_BIN_LIST += $(BOOTIMG_SECBIN)
SYSTEM_SEC_BIN_LIST += $(RECOVERY_SECBIN)
SYSTEM_SEC_BIN_LIST += $(MEX_SECBIN)
SYSTEM_SEC_BIN_LIST += $(MOBILEVISOR_SECBIN)
SYSTEM_SEC_BIN_LIST += $(SPLASH_SECBIN)
SYSTEM_SEC_BIN_LIST += $(SECVM_SECBIN)
SYSTEM_SEC_BIN_LIST += $(MVCONFIG_SECBIN)

INSTALLED_RADIOIMAGE_TARGET += $(SYSTEM_SEC_BIN_LIST)

MOBILEVISOR_CONFIG_FLS = $(MV_CONFIG_DEFAULT_FLS)

SECP_EXT := *.fls_ID0_*_SecureBlock.bin
DATA_EXT := *.fls_ID0_*_LoadMap*

BUILT_MODEM_DATA_EXT := $(SECBIN_TEMP)/modem/modem.fls_ID0_CUST_LoadMap0.bin
BUILT_MODEM_SEC_BLK  := $(SECBIN_TEMP)/modem/modem.fls_ID0_CUST_SecureBlock.bin

MODEM_BIN_LOAD_PATH := $(TARGET_OUT_VENDOR)/firmware

INSTALLED_MODEM_DATA_EXT := $(MODEM_BIN_LOAD_PATH)/modem.fls_ID0_CUST_LoadMap0.bin
INSTALLED_MODEM_SEC_BLK  := $(MODEM_BIN_LOAD_PATH)/modem.fls_ID0_CUST_SecureBlock.bin


$(SECBIN_TEMP)/mobilevisor_config: $(MOBILEVISOR_CONFIG_FLS)
	$(FLSTOOL) -o $@ -x $(MOBILEVISOR_CONFIG_FLS)

$(SECBIN_TEMP)/%: $(FLASHFILES_DIR)/%.fls
	$(FLSTOOL) -o $@ -x $<

$(SYSTEM_SEC_BIN_LIST): $(SECBIN_OUT)/%.secbin: $(SECBIN_TEMP)/%
	$(BINARY_MERGE_TOOL) -o $@ -b 512 -p 0 $</$(SECP_EXT) $(shell ls -d $</$(DATA_EXT))

create_secbin_dir:
	mkdir -p $(SECBIN_OUT)
	mkdir -p $(SECBIN_TEMP)

$(SYSTEM_SEC_BIN_LIST): create_secbin_dir

$(BUILT_MODEM_DATA_EXT): $(MEX_SECBIN)
$(BUILT_MODEM_SEC_BLK): $(MEX_SECBIN)

$(INSTALLED_MODEM_DATA_EXT): $(BUILT_MODEM_DATA_EXT) | ${ACP}
	@echo "Installing Modem Data Extract Binary to System Image.."
	$(hide) mkdir -p $(MODEM_BIN_LOAD_PATH)
	acp $< $@

$(INSTALLED_MODEM_SEC_BLK): $(BUILT_MODEM_SEC_BLK) | ${ACP}
	@echo "Installing Modem Secure Block Binary to System Image.."
	$(hide) mkdir -p $(MODEM_BIN_LOAD_PATH)
	acp $< $@

# ------------------------------------------------------------#
# This copies the Secbin Modem Data Extract & Secure Block to
# System Partition for Modem Silent Reset Feature.

# Modem Build becomes pre-requisite for the System Image
# to be generated.
# ------------------------------------------------------------#
ifeq ($(TARGET_LOAD_MODEM_DATA_EXTRACT),true)
$(PRODUCT_OUT)/obj/PACKAGING/systemimage_intermediates/system.img: $(INSTALLED_MODEM_DATA_EXT)
	$(hide) rm  $(INSTALLED_MODEM_DATA_EXT)
endif

ifeq ($(TARGET_LOAD_MODEM_SECURE_BLOCK),true)
$(PRODUCT_OUT)/obj/PACKAGING/systemimage_intermediates/system.img: $(INSTALLED_MODEM_SEC_BLK)
	$(hide) rm  $(INSTALLED_MODEM_DATA_EXT)
endif

.PHONY: android_secbin
android_secbin: $(SYSTEM_SEC_BIN_LIST)

ifeq ($(GEN_SECBIN_FILES),true)
droidcore: android_secbin
endif

