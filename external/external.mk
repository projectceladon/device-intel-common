# Make sure REF_PRODUCT_NAME is set
ifeq ($(REF_PRODUCT_NAME),)
REF_PRODUCT_NAME:=$(TARGET_PRODUCT)
endif

# At the moment we only generate prebuilts for user and userdebug builds
# so intel_prebuilts should be used only for one variant anyway.
ifneq ($(filter userdebug user,$(TARGET_BUILD_VARIANT)),)


# Prebuilts generation for external release is now done in two steps
# 1/ A full build is done
# 2/ Based on the files generated in 1/, prepare the prebuilts
#
# Some modules do specific processing when prebuilts are generated.
# Therefore, specific variables must be set for both all prebuilt targets.
#
# * intel_prebuilts target is built together with full image
#   It also restarts a make with publish_intel_prebuilts target
# * generate_intel_prebuilts target will pick built files and package them
#   in out folder.
# * publish_intel_prebuilts target takes the prebuilts from out folder
#   packages them in a zip and publishes the zip in pub


ifneq (,$(filter \
    intel_prebuilts generate_intel_prebuilts publish_intel_prebuilts, \
    $(MAKECMDGOALS)))
# GENERATE_INTEL_PREBUILTS is used to indicate we are generating intel_prebuilts
# so that the tests above are not duplicated in different portions of the code.
GENERATE_INTEL_PREBUILTS:=true

TARGET_OUT_prebuilts := $(PRODUCT_OUT)/prebuilts/intel

endif # intel_prebuilts || generate_intel_prebuilts || publish_intel_prebuilts


ifneq (,$(filter generate_intel_prebuilts publish_intel_prebuilts,$(MAKECMDGOALS)))
# Projects that require prebuilt are defined in manifest as follow:
# - project belongs to bsp-priv manifest group
# - and project has g_external annotation set to 'bin' ('g' meaning 'generic' customer)
$(eval _prebuilt_projects := $(shell repo forall -g bsp-priv -a g_external=bin -c 'echo $$REPO_PATH'))
# Projects that are under restrictive IP Plan
$(eval _private_projects := $(shell repo forall -g bsp-priv -c 'echo $$REPO_PATH'))

# get the original path of the hooked build makefiles
define original-metatarget
$(strip \
  $(eval _LOCAL_BUILD_MAKEFILE := $$(lastword $$(MAKEFILE_LIST))) \
  $(BUILD_SYSTEM)/$(notdir $(_LOCAL_BUILD_MAKEFILE)))
endef

# $(1) : line to echo to the makefile
define external-echo-makefile
       echo $(1) >>$@;
endef

# When odex is generated, .dex files are removed but .dex files should
# be saved for external release as they can be used to rebuild a component
# while odex can't.
# This is not necessary for java libraries that have unstripped jar in out/target/common.
# This requires patches in AOSP /build/ project to backup the .dex file.
EXT_JAVA_BACKUP_SUFFIX := .dex

# Check for IP violations when a module gets source files from another private project
define external-check-ip
$(eval ### Make sure the project does not reference other private projects) \
$(foreach _prj, $(_private_projects), \
    $(if $(findstring $(_prj)/, $(LOCAL_MODULE_MAKEFILE)), \
    , \
        $(if $(findstring $(_prj)/, $(LOCAL_SRC_FILES) $(LOCAL_PREBUILT_MODULE_FILE)), \
            $(info PRIVATE module [$(LOCAL_MODULE)] cannot use another PRIVATE module files directly to prevent IP violation) \
            $(foreach s, $(LOCAL_SRC_FILES) $(LOCAL_PREBUILT_MODULE_FILE), \
                $(if $(findstring $(_prj)/, $(s)), $(info >    [$(s)])) \
            ) \
            $(error Stop) \
        ) \
    ) \
)
endef

# $(1): module source file
# $(2): module arch -> 64 or 32 for native; empty otherwise
#
# .LOCAL_STRIP_MODULE is forced to false
#
# Use the unique key as defined in base_rules.mk: module_id + bitness
define external-gather-files
$(call external-check-ip) \
\
$(eval _key := $(module_id)$(2)) \
$(eval $(my).key_list := $($(my).key_list) $(_key)) \
$(eval $(_key).LOCAL_MODULE := $(strip $(LOCAL_MODULE))) \
$(eval $(_key).LOCAL_MODULE_SUFFIX := $(strip $(LOCAL_MODULE_SUFFIX))) \
$(eval $(_key).LOCAL_MODULE_TAGS := $(strip $(LOCAL_MODULE_TAGS))) \
$(eval ### For native, there is one prebuilt per arch. \
           Fallback to module setting otherwise - eg. package odex ) \
$(eval $(_key).LOCAL_MULTILIB := $(firstword $(2) $(LOCAL_MULTILIB))) \
$(eval $(_key).LOCAL_IS_HOST_MODULE := $(strip $(LOCAL_IS_HOST_MODULE))) \
$(eval $(_key).LOCAL_MODULE_CLASS := $(strip $(LOCAL_MODULE_CLASS))) \
$(eval $(_key).LOCAL_UNINSTALLABLE_MODULE := $(strip $(LOCAL_UNINSTALLABLE_MODULE))) \
$(eval $(_key).LOCAL_MODULE_STEM := $(LOCAL_MODULE_STEM)) \
$(eval $(_key).LOCAL_MODULE_STEM_$(2) := $(LOCAL_MODULE_STEM_$(2))) \
$(eval ### built stem must be preserved for javalib/packages - use the given stem if available ) \
$(eval $(_key).LOCAL_BUILT_MODULE_STEM := $(strip $(LOCAL_BUILT_MODULE_STEM))) \
$(eval $(_key).LOCAL_INSTALLED_MODULE_STEM := $(strip $(LOCAL_INSTALLED_MODULE_STEM))) \
$(eval $(_key).LOCAL_STRIP_MODULE := ) \
$(eval $(_key).LOCAL_SHARED_LIBRARIES := $(strip $(LOCAL_SHARED_LIBRARIES))) \
$(eval $(_key).LOCAL_REQUIRED_MODULES := $(strip $(LOCAL_REQUIRED_MODULES))) \
$(eval $(_key).LOCAL_CERTIFICATE := $(strip $(notdir $(LOCAL_CERTIFICATE)))) \
$(eval $(_key).LOCAL_MODULE_PATH := $(subst $(HOST_OUT),$$$$(HOST_OUT),$(subst $(PRODUCT_OUT),$$$$(PRODUCT_OUT),$(LOCAL_MODULE_PATH)))) \
$(eval $(_key).LOCAL_MODULE_PATH_$(2) := $(subst $(HOST_OUT),$$$$(HOST_OUT),$(subst $(PRODUCT_OUT),$$$$(PRODUCT_OUT),$(LOCAL_MODULE_PATH_$(2))))) \
$(eval $(_key).LOCAL_MODULE_RELATIVE_PATH := $(strip $(LOCAL_MODULE_RELATIVE_PATH))) \
\
$(eval ### Get source file) \
$(eval _input_file := ) \
$(if $(filter prebuilt,$(_metatarget)), \
    $(eval ### prebuilts must copy the original source file as some post-processing may happen on the built file) \
    $(eval ### TODO - get LOCAL_SRC_FILES_{arch} if available) \
    $(eval _input_file := $(firstword \
        $(LOCAL_PREBUILT_MODULE_FILE) \
        $(if $(2), $(if $(LOCAL_SRC_FILES_$(2)), $(LOCAL_PATH)/$(LOCAL_SRC_FILES_$(2)))) \
        $(LOCAL_PATH)/$(LOCAL_SRC_FILES) \
        )) \
) \
$(if $(filter java_library,$(_metatarget)), \
    $(eval ### get unstripped jar) \
    $(eval _input_file := $(common_javalib.jar)) \
) \
$(if $(filter package,$(_metatarget)), \
    $(eval ### get unstripped apk) \
    $(eval _input_file := $(LOCAL_BUILT_MODULE)$(EXT_JAVA_BACKUP_SUFFIX)) \
) \
$(if $(1), \
    $(eval ### get source file from parameter) \
    $(eval _input_file := $(1)) \
) \
$(if $(_input_file),, \
    $(eval ### default - get built module) \
    $(eval _input_file := $(LOCAL_BUILT_MODULE)) \
) \
\
$(eval $(_key).LOCAL_SRC_FILES := $(module_type)$(2)/$(LOCAL_MODULE)$(LOCAL_MODULE_SUFFIX)) \
\
$(eval $(my).copyfiles := $($(my).copyfiles) $(_input_file):$(dir $(my))$(module_type)$(2)/$(LOCAL_MODULE)$(LOCAL_MODULE_SUFFIX))
endef

define external-phony-package-boilerplate
  $(call external-echo-makefile, '') \
  $(call external-echo-makefile,'include $$(CLEAR_VARS)') \
  $(call external-echo-makefile,'LOCAL_MODULE:=$(strip $(1))') \
  $(call external-echo-makefile,'LOCAL_MODULE_TAGS:=optional') \
  $(call external-echo-makefile,'LOCAL_REQUIRED_MODULES:=$(strip $(2))') \
  $(call external-echo-makefile,'include $$(BUILD_PHONY_PACKAGE)')
endef

# Write a prebuilt module definition to the output makefile.
#
# $(1): Unique identifier holding all the module variables.
#       This can be seen as a structure representing a module.
define external-auto-prebuilt-boilerplate
$(call external-echo-makefile, '') \
$(call external-echo-makefile, 'include $$(CLEAR_VARS)') \
$(call external-echo-makefile, 'LOCAL_MODULE:=$($(1).LOCAL_MODULE)') \
$(call external-echo-makefile, 'LOCAL_MODULE_SUFFIX:=$($(1).LOCAL_MODULE_SUFFIX)') \
$(call external-echo-makefile, 'LOCAL_MODULE_TAGS:=$($(1).LOCAL_MODULE_TAGS)') \
$(call external-echo-makefile, 'LOCAL_MULTILIB:=$($(1).LOCAL_MULTILIB)') \
$(call external-echo-makefile, 'LOCAL_IS_HOST_MODULE:=$($(1).LOCAL_IS_HOST_MODULE)') \
$(call external-echo-makefile, 'LOCAL_MODULE_CLASS:=$($(1).LOCAL_MODULE_CLASS)') \
$(call external-echo-makefile, 'LOCAL_UNINSTALLABLE_MODULE:=$($(1).LOCAL_UNINSTALLABLE_MODULE)') \
$(call external-echo-makefile, 'LOCAL_MODULE_STEM:=$($(1).LOCAL_MODULE_STEM)') \
$(call external-echo-makefile, 'LOCAL_MODULE_STEM_32:=$($(1).LOCAL_MODULE_STEM_32)') \
$(call external-echo-makefile, 'LOCAL_MODULE_STEM_64:=$($(1).LOCAL_MODULE_STEM_64)') \
$(call external-echo-makefile, 'LOCAL_BUILT_MODULE_STEM:=$($(1).LOCAL_BUILT_MODULE_STEM)') \
$(call external-echo-makefile, 'LOCAL_INSTALLED_MODULE_STEM:=$($(1).LOCAL_INSTALLED_MODULE_STEM)') \
$(call external-echo-makefile, 'LOCAL_STRIP_MODULE:=$($(1).LOCAL_STRIP_MODULE)') \
$(call external-echo-makefile, 'LOCAL_SHARED_LIBRARIES:=$($(1).LOCAL_SHARED_LIBRARIES)') \
$(call external-echo-makefile, 'LOCAL_REQUIRED_MODULES:=$($(1).LOCAL_REQUIRED_MODULES)') \
$(call external-echo-makefile, 'LOCAL_CERTIFICATE:=$($(1).LOCAL_CERTIFICATE)') \
$(call external-echo-makefile, 'LOCAL_MODULE_PATH:=$($(1).LOCAL_MODULE_PATH)') \
$(call external-echo-makefile, 'LOCAL_MODULE_PATH_32:=$($(1).LOCAL_MODULE_PATH_32)') \
$(call external-echo-makefile, 'LOCAL_MODULE_PATH_64:=$($(1).LOCAL_MODULE_PATH_64)') \
$(call external-echo-makefile, 'LOCAL_MODULE_RELATIVE_PATH:=$($(1).LOCAL_MODULE_RELATIVE_PATH)') \
$(call external-echo-makefile, 'LOCAL_SRC_FILES:=$($(1).LOCAL_SRC_FILES)') \
$(call external-echo-makefile, 'LOCAL_EXPORT_C_INCLUDE_DIRS:=$$(LOCAL_PATH)/include') \
$(call external-echo-makefile, 'include $$(BUILD_PREBUILT)')
endef

# Copy several files.
# $(1): The files to copy.  Each entry is a ':' separated src:dst pair
# Note: Explicitly fail when attempting to copy a directory as acp does not return an error
define copy-several-files
$(foreach f, $(1), \
    $(eval _cmf_tuple := $(subst :, ,$(f))) \
    $(eval _cmf_src := $(word 1,$(_cmf_tuple))) \
    $(eval _cmf_dest := $(word 2,$(_cmf_tuple))) \
    ( mkdir -p $(dir $(_cmf_dest)); \
    $(ACP) $(_cmf_src) $(_cmf_dest) && \
    test ! -d $(_cmf_src) ) && ) true;
endef

# List several files dependencies.
# $(1): The files to compute.  Each entry is a ':' separated src:dst pair
define several-files-deps
$(foreach f, $(1), $(strip \
    $(eval _cmf_tuple := $(subst :, ,$(f))) \
    $(eval _cmf_src := $(word 1,$(_cmf_tuple))) \
    $(_cmf_src)))
endef

EXTERNAL_BUILD_SYSTEM=device/intel/common/external

# hook all the build makefiles with our own version
# most of them are only symlinks to "unsupported.mk", which will generate an
# error if included from a "PRIVATE" dir
# others are symlink to generic_rules.mk
# we cannot directly point to unsupported or generic_rules, because we would loose
# the information on what we are building
BUILD_HOST_STATIC_LIBRARY:= $(EXTERNAL_BUILD_SYSTEM)/symlinks/host_static_library.mk
BUILD_HOST_SHARED_LIBRARY:= $(EXTERNAL_BUILD_SYSTEM)/symlinks/host_shared_library.mk
BUILD_STATIC_LIBRARY:= $(EXTERNAL_BUILD_SYSTEM)/symlinks/static_library.mk
BUILD_RAW_STATIC_LIBRARY := $(EXTERNAL_BUILD_SYSTEM)/symlinks/raw_static_library.mk
BUILD_SHARED_LIBRARY:= $(EXTERNAL_BUILD_SYSTEM)/symlinks/shared_library.mk
BUILD_EXECUTABLE:= $(EXTERNAL_BUILD_SYSTEM)/symlinks/executable.mk
BUILD_RAW_EXECUTABLE:= $(EXTERNAL_BUILD_SYSTEM)/symlinks/raw_executable.mk
BUILD_HOST_EXECUTABLE:= $(EXTERNAL_BUILD_SYSTEM)/symlinks/host_executable.mk
BUILD_PACKAGE:= $(EXTERNAL_BUILD_SYSTEM)/symlinks/package.mk
BUILD_PHONY_PACKAGE:= $(EXTERNAL_BUILD_SYSTEM)/symlinks/phony_package.mk
BUILD_HOST_PREBUILT:= $(EXTERNAL_BUILD_SYSTEM)/symlinks/host_prebuilt.mk
BUILD_PREBUILT:= $(EXTERNAL_BUILD_SYSTEM)/symlinks/prebuilt.mk
BUILD_JAVA_LIBRARY:= $(EXTERNAL_BUILD_SYSTEM)/symlinks/java_library.mk
BUILD_STATIC_JAVA_LIBRARY:= $(EXTERNAL_BUILD_SYSTEM)/symlinks/static_java_library.mk
BUILD_HOST_JAVA_LIBRARY:= $(EXTERNAL_BUILD_SYSTEM)/symlinks/host_java_library.mk
BUILD_COPY_HEADERS := $(EXTERNAL_BUILD_SYSTEM)/symlinks/copy_headers.mk
BUILD_NATIVE_TEST := $(EXTERNAL_BUILD_SYSTEM)/symlinks/native_test.mk
BUILD_HOST_NATIVE_TEST := $(EXTERNAL_BUILD_SYSTEM)/symlinks/host_native_test.mk
BUILD_CUSTOM_EXTERNAL := $(EXTERNAL_BUILD_SYSTEM)/symlinks/custom_external.mk

# No need to define rules for wrappers around targets we already support
# BUILD_MULTI_PREBUILT -> relies on BUILD_PREBUILT

endif # generate_intel_prebuilts || publish_intel_prebuilts
endif # userdebug

# Convenient function to translate the path from internal to external.
# It's available regardless of the prebuilt generation.
#
# $(1) : Local path to be translated in prebuilt
#
define intel-prebuilts-path
prebuilts/intel/$(REF_PRODUCT_NAME)/$(subst /PRIVATE/,/,$(1))
endef
