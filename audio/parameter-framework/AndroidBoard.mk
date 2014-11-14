LOCAL_PATH := $(call my-dir)
COMMON_PFW_CONFIG_PATH := $(call my-dir)
CLEAR_PFW_VARS := $(COMMON_PFW_CONFIG_PATH)/clear_pfw_vars.mk
BUILD_PFW_SETTINGS := $(COMMON_PFW_CONFIG_PATH)/build_pfw_settings.mk

# defines:
# - $(PFW_TUNING_ALLOWED)

# requires:
# $(DEVICE_SOUND_CARD_NAME) to be provided

# The value of PFW_TUNING_ALLOWED will be used to remplace the
# "@TUNING_ALLOWED@" pattern in top-level configuration files templates
ifeq ($(TARGET_BUILD_VARIANT),eng)
PFW_TUNING_ALLOWED := true
else
PFW_TUNING_ALLOWED := false
endif

##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := parameter-framework.audio.common
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    ConfigurationSubsystem.xml

ifneq ($(TARGET_BUILD_VARIANT),user)
LOCAL_REQUIRED_MODULES += \
    libremote-processor \
    remote-process \
    parameter
endif

include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := parameter-framework.vibrator.common
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    vibrator
include $(BUILD_PHONY_PACKAGE)

##################################################


include $(CLEAR_VARS)
LOCAL_MODULE := parameter
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := EXECUTABLES
ifeq ($(TARGET_BUILD_VARIANT),eng)
LOCAL_SRC_FILES := SCRIPTS/$(LOCAL_MODULE)
else
LOCAL_SRC_FILES := SCRIPTS/$(LOCAL_MODULE).user_debug
endif
include $(BUILD_PREBUILT)


include $(CLEAR_VARS)
LOCAL_MODULE := vibrator
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES := SCRIPTS/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

##################################################


##################################################
######### Route PFW #########
# Route PFW top-level configuration file
include $(CLEAR_VARS)
LOCAL_MODULE := ParameterFrameworkConfigurationRoute.xml
LOCAL_MODULE_STEM := ParameterFrameworkConfigurationRoute-$(DEVICE_SOUND_CARD_NAME)-default.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework
LOCAL_SRC_FILES := $(LOCAL_MODULE).in

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): MY_FILE := $(LOCAL_PATH)/$(LOCAL_MODULE).in
$(LOCAL_BUILT_MODULE): MY_TUNING_ALLOWED := $(PFW_TUNING_ALLOWED)
$(LOCAL_BUILT_MODULE):
	$(hide) mkdir -p $(dir $@)
	sed -e 's/@TUNING_ALLOWED@/$(MY_TUNING_ALLOWED)/' $(MY_FILE) > $@


include $(CLEAR_VARS)
LOCAL_MODULE := RouteClass-common.xml
LOCAL_MODULE_STEM := RouteClass.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Route
LOCAL_SRC_FILES := Structure/Route/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

######### Route Structures #########

######### Route Debug FS Subsystem (Virtual) #########
include $(CLEAR_VARS)
LOCAL_MODULE := DebugFsSubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Route
LOCAL_SRC_FILES := Structure/Route/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libfs-subsystem
include $(BUILD_PREBUILT)

######### Route Common Criteria Component Set #########
include $(CLEAR_VARS)
LOCAL_MODULE := RouteSubsystem-CommonCriteria.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Route
LOCAL_SRC_FILES := Structure/Route/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

######### Audio Structures #########

include $(CLEAR_VARS)
LOCAL_MODULE := ConfigurationSubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := CMESubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libremoteparameter-subsystem
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := IMCSubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libimc-subsystem
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := PowerSubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libpower-subsystem
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := PropertySubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libproperty-subsystem
include $(BUILD_PREBUILT)

######### Audio Algos #########

include $(CLEAR_VARS)
LOCAL_MODULE := CommonAlgoTypes.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Gain.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := VoiceVolume.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Dcr.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SbaFir.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SbaIir.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Lpro.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Mdrc.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := ToneGenerator_V2_4.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

##############################
# VoiceAlgos_Gen3_5 Phony package
include $(CLEAR_VARS)
LOCAL_MODULE := VoiceAlgos_Gen3_5
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    Algos_Gen3_5.xml \
    AmbientNoiseAdapter_V2_5.xml \
    NoiseReduction_V1_1.xml \
    ComfortNoiseInjector_V1_1.xml \
    ComfortNoiseInjector_V1_2.xml \
    AutomaticGainControlVoice_V1_3.xml \
    AutomaticGainControlAudio_V1_0.xml \
    FbaFir_V1_1.xml \
    FbaIir_V1_1.xml \
    DualMicrophoneNoiseReduction_V1_5.xml \
    SpectralEchoReduction_V2_5.xml \
    BeamformingVoice_V1.1.xml \
    BeamformingAudio_V1.0.xml \
    EchoDelayLine_V1_1.xml \
    GainLossControl_V1_0.xml \
    AcousticEchoCanceler_V1_6.xml \
    ReferenceLine_V1_1.xml \
    NonLinearFilter_V1_0.xml \
    TrafficNoiseReduction_V1_0.xml \
    DynamicRangeProcessor_V1_4.xml \
    BandWidthExtender_V1_0.xml \
    WindNoiseReductionVoice_V1_0.xml \
    WindNoiseReductionAudio_V1_0.xml \
    SlowVoice_V1_0.xml \
    MultibandDynamicRangeProcessor_V1_0.xml

include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := Algos_Gen3_5.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := AmbientNoiseAdapter_V2_5.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := NoiseReduction_V1_1.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := ComfortNoiseInjector_V1_1.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := FbaFir_V1_1.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := FbaIir_V1_1.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := ComfortNoiseInjector_V1_2.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := AutomaticGainControlVoice_V1_3.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := AutomaticGainControlAudio_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := DualMicrophoneNoiseReduction_V1_5.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SpectralEchoReduction_V2_5.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := BeamformingVoice_V1.1.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := BeamformingAudio_V1.0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := EchoDelayLine_V1_1.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := GainLossControl_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := AcousticEchoCanceler_V1_6.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := ReferenceLine_V1_1.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := NonLinearFilter_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := TrafficNoiseReduction_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := DynamicRangeProcessor_V1_4.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := BandWidthExtender_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := WindNoiseReductionVoice_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := WindNoiseReductionAudio_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SlowVoice_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := MultibandDynamicRangeProcessor_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := ModuleVoiceProcessingLock_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

##################################################
