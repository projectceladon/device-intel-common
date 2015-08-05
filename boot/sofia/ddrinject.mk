ifneq ($$(INTEL_DDR_CTL_PARAMS_FILE.$(1)),)

ifeq ($$(INTEL_DDR_PHY_PARAMS_FILE.$(1)),)
  $$(error Please specify also emic physical parameters file.)
endif

ifeq ($$(wildcard $$(INTEL_DDR_CTL_PARAMS_FILE.$(1))),)
  $$(error File $$(INTEL_DDR_CTL_PARAMS_FILE.$(1)) does not exist.)
endif

ifeq ($$(wildcard $$(INTEL_DDR_PHY_PARAMS_FILE.$(1))),)
  $$(error File $$(INTEL_DDR_CTL_PARAMS_FILE.$(1)) does not exist.)
endif

DDR_CONV_SCRIPT.$(1)				:= $$(LOCAL_PATH)/conv_ddr_params.sh
CREATE_INJECTION_SCRIPT_SCRIPT.$(1)		:= $$(LOCAL_PATH)/create_ddr_injection_script.sh
PSI_RAM_DDRINJECT_SCRIPT.$(1) 		:= $$(BOOTLDR_TMP_DIR.$(1))/psi_ram.ddrinject_script.txt
PSI_FLASH_DDRINJECT_SCRIPT.$(1) 		:= $$(BOOTLDR_TMP_DIR.$(1))/psi_flash.ddrinject_script.txt

DDR_CTL_PARAMS_BINARY.$(1)			:= $$(BOOTLDR_TMP_DIR.$(1))/ddr_ctl_param.bin
DDR_PHY_PARAMS_BINARY.$(1)			:= $$(BOOTLDR_TMP_DIR.$(1))/ddr_phy_param.bin

# Perhaps this variable would be candidate to specify in the variant? Could be rather confusing I guess
DDR_CTL_PARAMS_SYMBOL_NAME.$(1)			?=  denaliSdram_CTL
DDR_PHY_PARAMS_SYMBOL_NAME.$(1)			?=  denaliSdram_PHY

$$(PSI_RAM_DDRINJECT_SCRIPT.$(1)): $$(BUILT_PSI_RAM_ELF.$(1)) $$(DDR_CTL_PARAMS_BINARY.$(1)) $$(DDR_PHY_PARAMS_BINARY.$(1)) $$(BOOTLDR_TMP_DIR.$(1))
	$$(CREATE_INJECTION_SCRIPT_SCRIPT.$(1)) $$(BUILT_PSI_RAM_ELF.$(1)) $$(DDR_CTL_PARAMS_BINARY.$(1)) $$(DDR_PHY_PARAMS_BINARY.$(1)) $$@

$$(PSI_FLASH_DDRINJECT_SCRIPT.$(1)): $$(BUILT_PSI_FLASH_ELF.$(1)) $$(DDR_CTL_PARAMS_BINARY.$(1)) $$(DDR_PHY_PARAMS_BINARY.$(1)) $$(BOOTLDR_TMP_DIR.$(1))
	$$(CREATE_INJECTION_SCRIPT_SCRIPT.$(1)) $$(BUILT_PSI_FLASH_ELF.$(1)) $$(DDR_CTL_PARAMS_BINARY.$(1)) $$(DDR_PHY_PARAMS_BINARY.$(1)) $$@

$$(DDR_PHY_PARAMS_BINARY.$(1)): $$(INTEL_DDR_PHY_PARAMS_FILE.$(1)) $$(DDR_CONV_SCRIPT.$(1))
	$$(DDR_CONV_SCRIPT.$(1)) $$(INTEL_DDR_PHY_PARAMS_FILE.$(1)) $$@

$$(DDR_CTL_PARAMS_BINARY.$(1)): $$(INTEL_DDR_CTL_PARAMS_FILE.$(1)) $$(DDR_CONV_SCRIPT.$(1))
	$$(DDR_CONV_SCRIPT.$(1)) $$(INTEL_DDR_CTL_PARAMS_FILE.$(1)) $$@

endif
