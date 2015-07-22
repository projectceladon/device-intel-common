#
# Copyright (C) 2009-2013 The Android-x86 Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#

ifeq ($(COMPILE_KERNEL_FROM_SRC),true)

#Get cross compilation prefix
ifneq ($(TARGET_ARCH),$(HOST_ARCH))
  CROSS_COMPILE := CROSS_COMPILE=$(CROSS_COMPILE_PATH)
else
  CROSS_COMPILE :=
endif

######  Wifi build is switched off currently due to change in kernel version (build is failing, to be switched on after further investigation).
#Hook dependency on the iwlwifi modules
$(PRODUCT_OUT)/system.img: iwlwifi_install
$(PRODUCT_OUT)/system.img: gnss_drv_install

#File and directory paths
KERNEL_DIR ?= $(CURDIR)/../linux-3.10

ifeq ($(KERNEL_OUT_DIR),)
$(error KERNEL_OUT_DIR not set - please configure in BoardConfig.mk)
endif

ifeq ($(RECOVERY_KERNEL_OUT_DIR),)
$(error RECOVERY_KERNEL_OUT_DIR not set - please configure in BoardConfig.mk)
endif

## KERNEL & DTB
KERNEL_CONFIG_FILE    := $(if $(wildcard $(TARGET_KERNEL_CONFIG)),$(TARGET_KERNEL_CONFIG),$(KERNEL_DIR)/arch/$(TARGET_ARCH)/configs/$(TARGET_KERNEL_CONFIG))
KERNEL_DOTCONFIG_FILE := $(KERNEL_OUT_DIR)/.config
BUILT_KERNEL_TARGET   := $(KERNEL_OUT_DIR)/arch/$(TARGET_ARCH)/boot/vmlinux.bin
BUILT_DTB_TARGET      := $(KERNEL_OUT_DIR)/arch/$(TARGET_ARCH)/boot/dts/$(DTB)

## RECOVERY KERNEL & DTB
RECOVERY_KERNEL_CONFIG_FILE    := $(if $(wildcard $(TARGET_RECOVERY_KERNEL_CONFIG)),$(TARGET_RECOVERY_KERNEL_CONFIG),$(KERNEL_DIR)/arch/$(TARGET_ARCH)/configs/$(TARGET_RECOVERY_KERNEL_CONFIG))
RECOVERY_KERNEL_DOTCONFIG_FILE := $(RECOVERY_KERNEL_OUT_DIR)/.config
BUILT_RECOVERY_KERNEL_TARGET   := $(RECOVERY_KERNEL_OUT_DIR)/arch/$(TARGET_ARCH)/boot/Image
BUILT_DTB_RECOVERY_TARGET      := $(RECOVERY_KERNEL_OUT_DIR)/arch/$(TARGET_ARCH)/boot/dts/$(DTB_RECOVERY)

#Create Kernel Build output Directory.
$(KERNEL_OUT_DIR):
	@echo Creating Kernel Build Out Directory ----- $(KERNEL_OUT_DIR)
	mkdir -p $(KERNEL_OUT_DIR)

#Create Recovery Kernel Build output Directory.
$(RECOVERY_KERNEL_OUT_DIR):
	@echo Creating Recovery Kernel Build Out Directory ------- $(RECOVERY_KERNEL_OUT_DIR)
	mkdir -p $(RECOVERY_KERNEL_OUT_DIR)

# Copy kernel configuration files to build out directory.
$(KERNEL_DOTCONFIG_FILE): $(KERNEL_OUT_DIR) $(KERNEL_CONFIG_FILE)
	@echo Copying kernel configuration from $(KERNEL_CONFIG_FILE) to $(KERNEL_DOTCONFIG_FILE)
	$(MAKE) -C $(KERNEL_DIR) O=$(KERNEL_OUT_DIR) ARCH=$(TARGET_ARCH) $(TARGET_KERNEL_CONFIG)


$(RECOVERY_KERNEL_DOTCONFIG_FILE): $(RECOVERY_KERNEL_CONFIG_FILE) $(RECOVERY_KERNEL_OUT_DIR)
	@echo Copying recovery kernel configuration from $(RECOVERY_KERNEL_CONFIG_FILE) to $(RECOVERY_KERNEL_DOTCONFIG_FILE)
	$(MAKE) -C $(KERNEL_DIR) O=$(RECOVERY_KERNEL_OUT_DIR) ARCH=$(TARGET_ARCH) $(TARGET_KERNEL_CONFIG)


# Kernel reconfiguration
.PHONY: kernel_menuconfig
kernel_menuconfig: $(KERNEL_OUT_DIR) $(KERNEL_DOTCONFIG_FILE)
	$(MAKE) -C $(KERNEL_DIR) O=$(KERNEL_OUT_DIR) ARCH=$(TARGET_ARCH) menuconfig
	@echo Copying kernel config back into $(KERNEL_CONFIG_FILE)
	cp $(KERNEL_DOTCONFIG_FILE) $(KERNEL_CONFIG_FILE)

.PHONY: recovery_kernel_menuconfig
recovery_kernel_menuconfig: $(RECOVERY_KERNEL_OUT_DIR) $(RECOVERY_KERNEL_DOTCONFIG_FILE)
	$(MAKE) -C $(KERNEL_DIR) O=$(RECOVERY_KERNEL_OUT_DIR) ARCH=$(TARGET_ARCH) menuconfig
	@echo Copying recovery kernel config back into $(RECOVERY_KERNEL_CONFIG_FILE)
	cp $(RECOVERY_KERNEL_DOTCONFIG_FILE) $(RECOVERY_KERNEL_CONFIG_FILE)


#Build kernel
$(BUILT_KERNEL_TARGET): $(KERNEL_DOTCONFIG_FILE)
	@echo Building kernel in $(KERNEL_OUT_DIR)
	$(MAKE) -C $(KERNEL_DIR) O=$(KERNEL_OUT_DIR) ARCH=$(TARGET_ARCH) $(CROSS_COMPILE) bzImage

btif_drv_install: $(BUILT_KERNEL_TARGET)
	-cp -f $(KERNEL_OUT_DIR)/drivers/idi/peripherals/btif_drv.ko $(ANDROID_PRODUCT_OUT)/system/lib/modules/

#Hook dependency on btif module
$(PRODUCT_OUT)/system.img: btif_drv_install

#INSTALL KERNEL
$(INSTALLED_KERNEL_TARGET): $(BUILT_KERNEL_TARGET) $(ACP)
	$(ACP) -fp $< $@

.PHONY: kernel
kernel: $(INSTALLED_KERNEL_TARGET)

.PHONY: kernel_clean
kernel_clean:
	@echo Cleaning kernel build files
	$(MAKE) -C $(KERNEL_DIR) O=$(KERNEL_OUT_DIR) mrproper

.PHONY: kernel_rebuild
kernel_rebuild: kernel_clean kernel

#Build Direct Tree Image.
$(BUILT_DTB_TARGET): $(KERNEL_DOTCONFIG_FILE) $(KERNEL_OUT_DIR) $(BUILT_KERNEL_TARGET)
	@echo Building Direct Tree image in $(KERNEL_OUT_DIR)
	$(MAKE) -C $(KERNEL_DIR) O=$(KERNEL_OUT_DIR) ARCH=$(TARGET_ARCH) $(CROSS_COMPILE) $(DTB)

#Copy setup header + DTB image to destination for mkbootimg processing.
$(INSTALLED_2NDBOOTLOADER_TARGET): $(BUILT_DTB_TARGET) $(ACP)
	$(ACP) -fp $< $@

.PHONY: dtb_kernel
dtb_kernel: $(INSTALLED_KERNEL_TARGET) $(INSTALLED_2NDBOOTLOADER_TARGET)

#Build recovery kernel
#$(BUILT_RECOVERY_KERNEL_TARGET): $(RECOVERY_KERNEL_DOTCONFIG_FILE) $(RECOVERY_KERNEL_OUT_DIR)
#	@echo Building recovery kernel in $(RECOVERY_KERNEL_OUT_DIR)
#	$(MAKE) -C $(KERNEL_DIR) O=$(RECOVERY_KERNEL_OUT_DIR) ARCH=$(TARGET_ARCH) $(CROSS_COMPILE) Image

#Build Recovery Direct Tree Image
#$(BUILT_DTB_RECOVERY_TARGET): $(KERNEL_DOTCONFIG_FILE) $(RECOVERY_KERNEL_OUT_DIR) $(BUILT_RECOVERY_KERNEL_TARGET)
#	@echo Building Direct Tree image in $(RECOVERY_KERNEL_OUT_DIR)
#	$(MAKE) -C $(KERNEL_DIR) O=$(RECOVERY_KERNEL_OUT_DIR) ARCH=$(TARGET_ARCH) $(CROSS_COMPILE) $(DTB_RECOVERY)

#Copy recovery binary to destination for mkbootimg processing.
#$(INSTALLED_RECOVERY_KERNEL_TARGET): $(BUILT_RECOVERY_KERNEL_TARGET)
#	$(ACP) -fp $< $@

## USE "bootimage" target to generate kernel, ramdisk, dtb & setup header images.

#.PHONY: recovery_kernel
#recovery_kernel: $(INSTALLED_RECOVERY_KERNEL_TARGET)

#.PHONY: recovery_kernel_clean
#recovery_kernel_clean:
#	@echo Cleaning kernel build files
#	make -C $(KERNEL_DIR) O=$(RECOVERY_KERNEL_OUT_DIR) mrproper

#.PHONY: kernels_clean
#kernels_clean: kernel_clean recovery_kernel_clean


kernelinfo:
	@echo "------------------------------------------------"
	@echo "Kernel:"
	@echo "-make kernel : Will build the kernel image for selected lunch target."
	@echo "-make dtb_kernel : Will build the dtb image for selected lunch target along with the main kernel image."
	@echo "-make kernel_rebuild : Will clean and rebuild the kernel image."

build_info: kernelinfo

endif

