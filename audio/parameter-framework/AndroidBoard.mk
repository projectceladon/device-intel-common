LOCAL_PATH := $(call my-dir)
COMMON_PFW_CONFIG_PATH := $(call my-dir)

PFW_CORE := $(INTEL_PATH_VENDOR)/audio/parameter-framework
#BUILD_PFW_SETTINGS := $(PFW_CORE)/support/android/build_pfw_settings.mk
PFW_DEFAULT_SCHEMAS_DIR := $(PFW_CORE)/upstream/schemas
PFW_SCHEMAS_DIR := $(PFW_DEFAULT_SCHEMAS_DIR)

TOOLS := frameworks/av/services/audiopolicy/engineconfigurable/tools
BUILD_PFW_SETTINGS := $(TOOLS)/build_audio_pfw_settings.mk
PROVISION_CRITERION_TYPES := $(TOOLS)/provision_criterion_types_from_android_headers.mk

# defines:
# - $(TUNING_SUFFIX)
# - @TUNING_ALLOWED@

# The value of @TUNING_ALLOWED@  will be used to remplace the
# "@TUNING_ALLOWED@" pattern in top-level configuration files templates
# TUNING_SUFFIX is used to change module names when tuning is allowed
# or not, forcing rebuild when tuning parameter is modified
ifneq ($(TARGET_BUILD_VARIANT),user)
AUDIO_PATTERNS += @TUNING_ALLOWED@=true
TUNING_SUFFIX :=
else
AUDIO_PATTERNS += @TUNING_ALLOWED@=false
# TUNING_SUFFIX := NoTuning
endif

BUILD_REPLACE_PATTERNS_IN_FILE := $(COMMON_PFW_CONFIG_PATH)/build_replace_patterns_in_file.mk

##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := parameter-framework.audio.common
LOCAL_MODULE_TAGS := optional

ifneq ($(TARGET_BUILD_VARIANT),user)
LOCAL_REQUIRED_MODULES += \
    libremote-processor \
    remote-process \
    parameter-audio \
    parameter-route \
    parameter-policy
endif

include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := parameter-framework.vibrator.common
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    SysfsVibratorClass.xml \
    MiscConfigurationSubsystem.xml \
    SysfsVibratorSubsystem.xml \
    VibratorParameterFramework$(TUNING_SUFFIX).xml

ifneq ($(TARGET_BUILD_VARIANT),user)
LOCAL_REQUIRED_MODULES += parameter-vibrator
endif

include $(BUILD_PHONY_PACKAGE)

##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := parameter-audio
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES := SCRIPTS/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)


include $(CLEAR_VARS)
LOCAL_MODULE := parameter-vibrator
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES := SCRIPTS/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)


include $(CLEAR_VARS)
LOCAL_MODULE := parameter-route
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES := SCRIPTS/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)


include $(CLEAR_VARS)
LOCAL_MODULE := parameter-policy
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES := SCRIPTS/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

##################################################


##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := RouteClass-common.xml
LOCAL_MODULE_STEM := RouteClass.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Route
LOCAL_SRC_FILES := Structure/Route/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := DebugFsSubsystem.xml
include $(BUILD_PREBUILT)

######### Route Structures #########

######### Route Debug FS Subsystem (Virtual) #########
include $(CLEAR_VARS)
LOCAL_MODULE := DebugFsSubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Route
LOCAL_SRC_FILES := Structure/Route/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libfs-subsystem
include $(BUILD_PREBUILT)

######### Route Common Criteria Component Set #########
include $(CLEAR_VARS)
LOCAL_MODULE := RouteSubsystem-CommonCriteria.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Route
LOCAL_SRC_FILES := Structure/Route/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

######### Route Common Types Component Set #########
include $(CLEAR_VARS)
LOCAL_MODULE := RouteSubsystem-RoutesTypes.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Route
LOCAL_SRC_FILES := Structure/Route/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

######### Audio Structures #########

include $(CLEAR_VARS)
LOCAL_MODULE := SmartXSubsystem-Definitions.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/eAVB/SmartX
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := AvbControlSubsystem-Definitions.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/eAVB/AVB
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)


include $(CLEAR_VARS)
LOCAL_MODULE := ConfigurationSubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

ifeq ($(BOARD_HAVE_MODE),true)
include $(CLEAR_VARS)
LOCAL_MODULE := IMCSubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libimc-subsystem
include $(BUILD_PREBUILT)
endif

include $(CLEAR_VARS)
LOCAL_MODULE := PowerSubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libpower-subsystem
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := PropertySubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libproperty-subsystem
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Realtek5672Subsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libtinyalsa-subsystem
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Realtek5645Subsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libtinyalsa-subsystem
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := AFE2.0.Subsystem-common.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libtinyalsa-subsystem
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := WM8281Subsystem-common.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libtinyalsa-subsystem
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := WM8998Subsystem-common.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libtinyalsa-subsystem
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := ALC286Subsystem-common.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libtinyalsa-subsystem
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := TI_TLV320AIC3100Subsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Realtek564xSubsystem-common.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libproperty-subsystem
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := BluedroidCommSubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio
LOCAL_SRC_FILES := Structure/Audio/$(LOCAL_MODULE)
LOCAL_REQUIRED_MODULES := libbluedroidcomm-subsystem
include $(BUILD_PREBUILT)


######### SmartXbar Processing module #########

include $(CLEAR_VARS)
LOCAL_MODULE := ModulesLibrary.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/eAVB/SmartX
LOCAL_SRC_FILES := Structure/Audio/SmartX/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

######### Audio Algos #########

include $(CLEAR_VARS)
LOCAL_MODULE := CommonAlgoTypes.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Gain.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := GSD_Gain.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := VoiceVolume.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := DbVolume.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SampleSpecDomain.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Dcr.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SbaFir.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SbaIir.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Lpro.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Mdrc.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SbaEqualizers.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := HfSns2.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := ToneGenerator_V2_4.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

######### Audio CAVS Algos #########

include $(CLEAR_VARS)
LOCAL_MODULE := cavs-Gain.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/cavs
LOCAL_SRC_FILES := Structure/Audio/cavs/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := cavs-Dcr.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/cavs
LOCAL_SRC_FILES := Structure/Audio/cavs/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := cavs-Fir.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/cavs
LOCAL_SRC_FILES := Structure/Audio/cavs/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := cavs-Iir.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/cavs
LOCAL_SRC_FILES := Structure/Audio/cavs/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := cavs-Mdrc.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/cavs
LOCAL_SRC_FILES := Structure/Audio/cavs/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := cavs-Lpro.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/cavs
LOCAL_SRC_FILES := Structure/Audio/cavs/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := cavs-Equalizers.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/cavs
LOCAL_SRC_FILES := Structure/Audio/cavs/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

######### WOV GHWD Algos #########

include $(CLEAR_VARS)
LOCAL_MODULE := cavs-Ghwd.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/cavs
LOCAL_SRC_FILES := Structure/Audio/cavs/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

##############################
# Algos_Gen3_5 Phony package
include $(CLEAR_VARS)
LOCAL_MODULE := MediaAlgos_Gen3_5
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    MediaAlgos_Gen3_5.xml \
    AutomaticGainControlAudio_V1_0.xml \
    BeamForming_V1_2.xml \
    WindNoiseReductionAudio_V1_0.xml \

include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := VoiceAlgos_Gen3_5
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    VoiceAlgos_Gen3_5.xml \
    AmbientNoiseAdapter_V2_5.xml \
    NoiseReduction_V1_1.xml \
    ComfortNoiseInjector_V1_1.xml \
    ComfortNoiseInjector_V1_2.xml \
    AutomaticGainControl_V1_3.xml \
    FbaFir_V1_1.xml \
    FbaIir_V1_1.xml \
    DualMicrophoneNoiseReduction_V1_5.xml \
    SpectralEchoReduction_V2_5.xml \
    BeamForming_V1_1.xml \
    EchoDelayLine_V1_1.xml \
    GainLossControl_V1_0.xml \
    AcousticEchoCanceler_V1_6.xml \
    EchoReferenceLine_V1_1.xml \
    NonLinearFilter_V1_0.xml \
    TrafficNoiseReduction_V1_0.xml \
    DynamicRangeProcessor_V1_4.xml \
    BandWidthExtender_V1_0.xml \
    WindNoiseReduction_V1_0.xml \
    SlowVoice_V1_0.xml \
    MultibandDynamicRangeProcessor_V1_0.xml

include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := MediaAlgos_Gen3_5.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := VoiceAlgos_Gen3_5.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := AmbientNoiseAdapter_V2_5.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := NoiseReduction_V1_1.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := ComfortNoiseInjector_V1_1.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := FbaFir_V1_1.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := FbaIir_V1_1.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := ComfortNoiseInjector_V1_2.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := AutomaticGainControl_V1_3.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := AutomaticGainControlAudio_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := DualMicrophoneNoiseReduction_V1_5.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SpectralEchoReduction_V2_5.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := BeamForming_V1_1.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := BeamForming_V1_2.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := EchoDelayLine_V1_1.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := GainLossControl_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := AcousticEchoCanceler_V1_6.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := EchoReferenceLine_V1_1.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := NonLinearFilter_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := TrafficNoiseReduction_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := DynamicRangeProcessor_V1_4.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := BandWidthExtender_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := WindNoiseReduction_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := WindNoiseReductionAudio_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SlowVoice_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := MultibandDynamicRangeProcessor_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := ModuleVoiceProcessingLock_V1_0.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Audio/intel
LOCAL_SRC_FILES := Structure/Audio/intel/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

######### Vibrator Structures #########

include $(CLEAR_VARS)
LOCAL_MODULE := VibratorParameterFramework$(TUNING_SUFFIX).xml
LOCAL_MODULE_STEM := VibratorParameterFramework.xml
LOCAL_MODULE_RELATIVE_PATH := parameter-framework
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_SRC_FILES := $(LOCAL_MODULE_STEM).in
REPLACE_PATTERNS := $(AUDIO_PATTERNS)
include $(BUILD_REPLACE_PATTERNS_IN_FILE)

include $(CLEAR_VARS)
LOCAL_MODULE := SysfsVibratorClass.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Vibrator
LOCAL_SRC_FILES := Structure/Vibrator/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := MiscConfigurationSubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Vibrator
LOCAL_SRC_FILES := Structure/Vibrator/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SysfsVibratorSubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Vibrator
LOCAL_SRC_FILES := Structure/Vibrator/$(LOCAL_MODULE).in
LOCAL_REQUIRED_MODULES := libfs-subsystem
REPLACE_PATTERNS := $(AUDIO_PATTERNS)
include $(BUILD_REPLACE_PATTERNS_IN_FILE)

##################################################


########## Policy PFW Structures #########

include $(CLEAR_VARS)
LOCAL_MODULE := PolicyClass.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_ETC)/parameter-framework/Structure/Policy
LOCAL_SRC_FILES := Structure/Policy/$(LOCAL_MODULE)

include $(BUILD_PREBUILT)
include $(CLEAR_VARS)
LOCAL_MODULE := ProductStrategies.xml
LOCAL_MODULE_STEM := ProductStrategies.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Structure/Policy
LOCAL_SRC_FILES :=  Structure/Policy/$(LOCAL_MODULE_STEM)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := audio_policy_engine_criteria.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_ETC)
LOCAL_SRC_FILES := Structure/Policy/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := audio_policy_engine_criterion_types.xml
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_ETC)
LOCAL_ADDITIONAL_DEPENDENCIES := \
    $(TARGET_OUT_VENDOR_ETC)/audio_policy_configuration.xml \
    $(TARGET_OUT_VENDOR_ETC)/usb_audio_policy_configuration.xml \
    $(TARGET_OUT_VENDOR_ETC)/r_submix_audio_policy_configuration.xml \
    $(TARGET_OUT_VENDOR_ETC)/a2dp_audio_policy_configuration.xml \
    $(TARGET_OUT_VENDOR_ETC)/default_volume_tables.xml \
    $(TARGET_OUT_VENDOR_ETC)/audio_policy_volumes.xml

ANDROID_AUDIO_BASE_HEADER_FILE := system/media/audio/include/system/audio-base.h
AUDIO_POLICY_CONFIGURATION_FILE := $(TARGET_OUT_VENDOR_ETC)/audio_policy_configuration.xml
CRITERION_TYPES_FILE := $(LOCAL_PATH)/Structure/Policy/$(LOCAL_MODULE).in
include $(PROVISION_CRITERION_TYPES) 

include $(CLEAR_VARS)
LOCAL_MODULE := PolicySubsystem.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_REQUIRED_MODULES := \
    PolicySubsystem-CommonTypes.xml \
	ProductStrategies.xml \
	PolicySubsystem-Volume.xml \
    libpolicy-subsystem

LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_ETC)/parameter-framework/Structure/Policy
LOCAL_SRC_FILES := Structure/Policy/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := PolicySubsystem-CommonTypes.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_ETC)/parameter-framework/Structure/Policy
LOCAL_SRC_FILES := Structure/Policy/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)


include $(CLEAR_VARS)
LOCAL_MODULE := audio_policy_engine_configuration.xml
LOCAL_MODULE_STEM := audio_policy_engine_configuration.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := .
LOCAL_SRC_FILES :=  audio_policy_engine_configuration.xml
LOCAL_REQUIRED_MODULES := \
    audio_policy_engine_product_strategies.xml  \
    audio_policy_engine_criteria.xml \
    audio_policy_engine_criterion_types.xml \
    audio_policy_engine_volumes.xml 
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := audio_policy_engine_product_strategies.xml
LOCAL_MODULE_STEM := audio_policy_engine_product_strategies.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := .
LOCAL_SRC_FILES := Structure/Policy/$(LOCAL_MODULE_STEM)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := audio_policy_engine_volumes.xml
LOCAL_MODULE_STEM := audio_policy_engine_volumes.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := .
LOCAL_SRC_FILES := Structure/Policy/$(LOCAL_MODULE_STEM)
include $(BUILD_PREBUILT)

######### Policy PFW Settings #########
include $(CLEAR_VARS)
LOCAL_MODULE := parameter-framework.policy
LOCAL_MODULE_STEM := PolicyConfigurableDomains.xml
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := parameter-framework/Settings/Policy
LOCAL_ADDITIONAL_DEPENDENCIES := \
        $(TARGET_OUT_VENDOR_ETC)/parameter-framework/Structure/Policy/PolicyClass.xml \
        $(TARGET_OUT_VENDOR_ETC)/parameter-framework/Structure/Policy/PolicySubsystem.xml \
        $(TARGET_OUT_VENDOR_ETC)/parameter-framework/ParameterFrameworkConfigurationPolicy$(TUNING_SUFFIX).xml

LOCAL_REQUIRED_MODULES := \
    PolicySubsystem.xml \
    PolicyClass.xml \
    audio_policy_engine_criteria.xml \
    audio_policy_engine_criterion_types.xml \
    ParameterFrameworkConfigurationPolicy.xml \
    PolicySubsystem-CommonTypes.xml \
    audio_policy_engine_configuration.xml


PFW_CRITERION_TYPES_FILE := $(TARGET_OUT_VENDOR_ETC)/audio_policy_engine_criterion_types.xml
PFW_CRITERIA_FILE := $(TARGET_OUT_VENDOR_ETC)/audio_policy_engine_criteria.xml
PFW_TOPLEVEL_FILE := $(TARGET_OUT_VENDOR_ETC)/parameter-framework/ParameterFrameworkConfigurationPolicy.xml

PFW_EDD_FILES := \
        $(LOCAL_PATH)/Settings/Policy/device_for_input_source.pfw \
        $(LOCAL_PATH)/Settings/Policy/device_for_product_strategy_media.pfw \
        $(LOCAL_PATH)/Settings/Policy/device_for_product_strategy_phone.pfw \
        $(LOCAL_PATH)/Settings/Policy/device_for_product_strategy_sonification.pfw \
        $(LOCAL_PATH)/Settings/Policy/device_for_product_strategy_sonification_respectful.pfw \
        $(LOCAL_PATH)/Settings/Policy/device_for_product_strategy_dtmf.pfw \
        $(LOCAL_PATH)/Settings/Policy/device_for_product_strategy_enforced_audible.pfw \
        $(LOCAL_PATH)/Settings/Policy/device_for_product_strategy_transmitted_through_speaker.pfw \
        $(LOCAL_PATH)/Settings/Policy/device_for_product_strategy_accessibility.pfw \
        $(LOCAL_PATH)/Settings/Policy/device_for_product_strategy_rerouting.pfw

include $(BUILD_PFW_SETTINGS)
