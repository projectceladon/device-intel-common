#
# Copyright (C) 2015 Intel Corporation
#
# Releasetools hook for Sofia
# This file contains releasetools extensions for updating the bootloader
# related partitions for Sofia3GR devices.

import common
import os
import zipfile
import sys

sys.path.append("device/intel/build/releasetools")
import intel_common

OPTIONS = common.OPTIONS
patchinfo = None
verbatim = None

def trigger_fwupdate(info):
  _, misc_device = common.GetTypeAndDevice("/misc", OPTIONS.info_dict)
  info.script.script.append('intel_install_firmware_update("%s");'
      % misc_device)

# These steps are called in the end of an OTA update
def FullOTA_InstallEnd(info):
  print("Intel: vendor specific OTA end hook for full OTA update")
  intel_common.AddFWImageFile(OPTIONS.target_tmp, info.output_zip)

  # Set progress bar to end of FLS extraction
  info.script.SetProgress(0.6)
  info.script.WriteRawImage("/fwupdate", "fwu_image.bin");
  trigger_fwupdate(info)

# Called during an incremental update before any changes are made
def IncrementalOTA_VerifyEnd(info):
  global patchinfo
  global verbatim
  print("Calculating fwupdate patch information")

  fwu_type, fwu_device = common.GetTypeAndDevice("/fwupdate", OPTIONS.info_dict)
  verbatim, fwu_patch, output_files = intel_common.ComputeFWUpdatePatches(OPTIONS.source_tmp, OPTIONS.target_tmp)
  if not verbatim and fwu_patch:
    (tf,sf) = fwu_patch
    # The below check ensures fwupdate partition is in an expected state before
    # the OTA system makes any changes
    info.script.PatchCheck("%s:%s:%d:%s:%d:%s" %
                           (fwu_type, fwu_device, sf.size,
                            sf.sha1, tf.size, tf.sha1))
    patchinfo = (fwu_type, fwu_device, sf, tf)
    common.ZipWriteStr(info.output_zip, "patch/fwu_image.bin.p", output_files)

def IncrementalOTA_InstallEnd(info):
  print("Intel: vendor specific OTA end hook for incremental OTA update")
  if verbatim:
    intel_common.AddFWImageFile(OPTIONS.target_tmp, info.output_zip)

    # Set progress bar to end of FLS extraction
    info.script.SetProgress(0.6)
    info.script.WriteRawImage("/fwupdate", "fwu_image.bin");
  elif patchinfo:
    fwu_type, fwu_device, sf, tf = patchinfo
    info.script.ApplyPatch("%s:%s:%d:%s:%d:%s" % (fwu_type, fwu_device, sf.size,
                                                  sf.sha1, tf.size, tf.sha1),
                           "-", tf.size, tf.sha1, sf.sha1,
                           "patch/fwu_image.bin.p")
  trigger_fwupdate(info)
