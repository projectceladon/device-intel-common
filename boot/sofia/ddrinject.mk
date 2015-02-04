ifneq ($(INTEL_DDR_CTL_PARAMS_FILE),)

ifeq ($(INTEL_DDR_PHY_PARAMS_FILE),)
  $(error Please specify also emic physical parameters file.)
endif

ifeq ($(wildcard $(INTEL_DDR_CTL_PARAMS_FILE)),)
  $(error File $(INTEL_DDR_CTL_PARAMS_FILE) does not exist.)
endif

ifeq ($(wildcard $(INTEL_DDR_PHY_PARAMS_FILE)),)
  $(error File $(INTEL_DDR_CTL_PARAMS_FILE) does not exist.)
endif

DDR_CONV_SCRIPT				:= device/intel/common/conv_ddr_params.sh
CREATE_INJECTION_SCRIPT_SCRIPT		:= device/intel/common/create_ddr_injection_script.sh
PSI_RAM_DDRINJECT_SCRIPT 		:= $(BOOTLDR_TMP_DIR)/psi_ram.ddrinject_script.txt
PSI_FLASH_DDRINJECT_SCRIPT 		:= $(BOOTLDR_TMP_DIR)/psi_flash.ddrinject_script.txt

DDR_CTL_PARAMS_BINARY			:= $(BOOTLDR_TMP_DIR)/ddr_ctl_param.bin
DDR_PHY_PARAMS_BINARY			:= $(BOOTLDR_TMP_DIR)/ddr_phy_param.bin

# Perhaps this variable would be candidate to specify in the variant? Could be rather confusing I guess
DDR_CTL_PARAMS_SYMBOL_NAME			:=  denaliSdram_CTL
DDR_PHY_PARAMS_SYMBOL_NAME			:=  denaliSdram_PHY

$(PSI_RAM_DDRINJECT_SCRIPT): $(BUILT_PSI_RAM_ELF) $(DDR_CTL_PARAMS_BINARY) $(DDR_PHY_PARAMS_BINARY) $(BOOTLDR_TMP_DIR)
	$(CREATE_INJECTION_SCRIPT_SCRIPT) $(BUILT_PSI_RAM_ELF) $(DDR_CTL_PARAMS_BINARY) $(DDR_PHY_PARAMS_BINARY) $@

$(PSI_FLASH_DDRINJECT_SCRIPT): $(BUILT_PSI_FLASH_ELF) $(DDR_CTL_PARAMS_BINARY) $(DDR_PHY_PARAMS_BINARY) $(BOOTLDR_TMP_DIR)
	$(CREATE_INJECTION_SCRIPT_SCRIPT) $(BUILT_PSI_FLASH_ELF) $(DDR_CTL_PARAMS_BINARY) $(DDR_PHY_PARAMS_BINARY) $@

$(DDR_PHY_PARAMS_BINARY): $(INTEL_DDR_PHY_PARAMS_FILE) $(DDR_CONV_SCRIPT)
	$(DDR_CONV_SCRIPT) $(INTEL_DDR_PHY_PARAMS_FILE) $@

$(DDR_CTL_PARAMS_BINARY): $(INTEL_DDR_CTL_PARAMS_FILE) $(DDR_CONV_SCRIPT)
	$(DDR_CONV_SCRIPT) $(INTEL_DDR_CTL_PARAMS_FILE) $@

endif
