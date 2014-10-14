# Parameter-framework XML generation build rule

We provide a build rule for generating parameter-framework XML Settings (aka
Domains) files using ".pfw" files and, optionaly, a pre-existing Settings file.
This is similar to the ones provided by the Android build system (through
instructions like `include $(BUILD_SHARED_LIBRARY)`).

Here is usage example followed by an explanation:

    include $(CLEAR_VARS)
    LOCAL_MODULE := AudioConfigurableDomains-bytcr-rt5640-default.xml
    LOCAL_MODULE_TAGS := optional
    LOCAL_MODULE_CLASS := ETC
    LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Settings/Audio

    include $(CLEAR_PFW_VARS)
    # Refresh tunning + routing domain file for rt5640-default
    LOCAL_REQUIRED_MODULES := \
        parameter-framework.audio.common \
        parameter-framework.audio.baytrail \
        ParameterFrameworkConfiguration-bytcr-rt5640-default.xml \
        AudioClass-bytcr-rt5640-default.xml \
        CodecSubsystem-bytcr-rt564x-common.xml \
        CodecSubsystem-bytcr-rt5640-default.xml \
        SstSubsystem-bytcr-rt5640-default.xml \
        SstSubsystem-bytcr-rt56xx-common.xml \

    PFW_TOPLEVEL_FILE := $(TARGET_OUT_ETC)/parameter-framework/ParameterFrameworkConfiguration-bytcr-rt5640-default.xml
    PFW_CRITERIA_FILE := $(COMMON_PFW_CONFIG_PATH)/AudioCriteria.txt
    PFW_TUNING_FILE := $(LOCAL_PATH)/Settings/Audio/AudioConfigurableDomains-bytcr-rt5640-default.Tuning.xml
    PFW_EDD_FILES := \
        $(PLATFORM_PFW_CONFIG_PATH)/Settings/Audio/routing_scalpe_common.pfw \
        $(LOCAL_PATH)/Settings/Audio/bytcr-rt5640-default.pfw
    PFW_COPYBACK := Settings/Audio/$(LOCAL_MODULE)
    include $(BUILD_PFW_SETTINGS)

The important parts are the `PFW_`-prefixed variables:

* `PFW_TOPLEVEL_FILE`: the top-level configuration file for xml generation
* `PFW_CRITERIA_FILE`: the file containing the criteria, their types and their
    values
* `PFW_TUNING_FILE` (optional): an XML file containing existing settings to be
    augmented
* `PFW_EDD_FILES`: a list of files using the ".pfw" (aka Extended Domain
    Description) language
* `PFW_COPYBACK` (optional): if set, the generated file will be copied to the
    given location, relative to `$(LOCAL_PATH)`. This oughts to be a temporary
    hack.

Before using any `PFW_` variable, you must call `include $(CLEAR_PFW_VARS)` and
you can call `include $(BUILD_PFW_SETTINGS)` to trigger XML generation. This
two variables are defined by `AndroidBoard.mk`.

