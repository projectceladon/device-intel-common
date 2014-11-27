# this file is symlinked by all the build makefile that we dont support
# in private projects - ignore the projects that are never released.
_need_prebuilts :=
$(foreach project, $(_prebuilt_projects),\
  $(if $(findstring $(project), $(LOCAL_MODULE_MAKEFILE)),\
    $(eval _need_prebuilts := true)))

ifeq (true,$(_need_prebuilts))
$(warning intel_prebuilts - unsupported $(LOCAL_MODULE) in $(LOCAL_MODULE_MAKEFILE).)
endif # _need_prebuilts

include $(call original-metatarget)
