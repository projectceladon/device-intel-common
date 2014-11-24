# BKMs and good practices related to audio configuration files and Makefiles

Please follow the rules described in this readme as they will

1. ease your work;
2. avoid divergence across branches and products;
3. ensure readability and cohesion of configuration files and makefiles.

If these rules are too long for you to read, read at least the "Rules of thumb"
sections.

In general, there are 3 problems that can arise:

1. Duplication;
2. Divergence;
3. Noise (unwanted/irrelevant information).

Duplication and divergence are solved by factorization but factorization may
introduce noise because a configuration file covering all possible use-cases may
not be wanted in the context of a product with reduced capabilities (e.g. tablet
vs. phone).

## Parameter-framework configuration files

The overall parameter-framework configuration files structure is described
here:
<https://github.com/01org/parameter-framework/blob/master/Schemas/README.md>.

In the context of Android, there are additional details:

1.  In order to avoid duplication, the build system shall decide at build time
    whether tuning is allowed. To that end, the following rules shall be
    respected:
    
    * the top-level configuration file (e.g.
      `ParameterFrameworkConfiguration.xml`) shall have an additional `.in`
      extension (e.g. `ParameterFrameworkConfiguration.xml.in`);
    * it shall set the "TuningAllowed" property to `@TUNING_ALLOWED@`;
    * the makefile shall change this value at build time (see an example in
      `AndroidBoard.mk`).
    
    That allows to maintain only one file per PFW instance instead of two.

2.  In the same way, when a Structure file is used in several products with
    only a change in a Subsystem-level mapping, the same mechanism as described
    above shall be used. For instance, the RouteSubsystem Structure file is
    often the same for all platforms and only the name of the soundcard on the
    platform changes (`Mapping="Card:foobar"` in the `<Subsystem>` tag). In
    this example, this can be achieved with `Mapping=Card:@SOUND_CARD_NAME@`.

3.  The `xi:include` mechanism in Structure files should be used wisely. Its
    purpose is to factorize parts of Structures that can be reused and allow to:
    
    * write concise Structure files;
    * differentiate Structure files while avoid divergence: a full-blown
      Structure file (e.g. phone) will include all ComponentLibraries whereas a
      minimal Structure file (e.g. tablet) will only include a subset of those.
    
    Avoid creating non-reusable ComponentLibraries (i.e. tied to a product) or
    causing the Structure to contain unused parameters on the target product:
    this will add noise and clients do not want it. Think of the difference
    between evaluation board, tablet, phone, dual-sim phone, etc.
    
    Conclusion: learn the difference between the two usages of ComponentTypes:
    
    * As reusable base types (e.g. the output devices defined by android);
    * As a convenience for instantiating the same list of components on
      different products (e.g. the list of platform routes).

4. In the same way, the Settings files shall be split in a way that prevents
   duplication, divergence and noise. It is a good idea to split the ".pfw"
   files according to the components they contain and split again according to
   the features they enable, when possible.

### Rules of thumb

* Do not duplicate a file if you can easily differentiate it at build time.
  Instead, write a template and specialize it at build time.
* Use `xi:include` and factorize base ComponentTypes whenever possible; put the
  factorized file at the lowest relevant level (lower: common, higher:
  product-specific). Keep in mind that it might evolve and have several
  versions, which is fine but might cause duplication to avoid version
  conflict.
* Learn to identify the difference between a) reusable building blocks
  and b) mere copy/paste avoidance (subject to divergence) - see item 3 above.
* Split ".pfw" files whenever relevant and "commonalize" when possible.


## Parameter-framework XML generation build rule

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

