#
# Copyright (C) 2015 Intel Mobile Communications GmbH
#
# Releasetools hook for Sofia
#
# Here you can add variant specific custom steps to the OTA process
#
# imc.* functions are implemented inside updater/extra_hooks.c
import common
import os

def AddBinaryFiles(info):
  fwu_image = info.input_zip.read(os.path.join("RADIO", "fwu_image.bin"))
  common.ZipWriteStr(info.output_zip, "fwu_image.bin", fwu_image)
  info.script.SetProgress(0.6) #Set progress bar to end of FLS extraction

  info.script.WriteRawImage("/fwupdate", "fwu_image.bin");
  fstab = info.script.info.get("fstab", None)

  info.script.script.append('intel_install_firmware_update("%s");'
      % fstab['/misc'].device)

#These steps are called in the end of an OTA update
def FullOTA_InstallEnd(info):
  print "Intel: vendor specific OTA end hook for full OTA update"
  AddBinaryFiles(info)

def IncrementalOTA_InstallEnd(info):
  print "Intel: vendor specific OTA end hook for incremental OTA update"
  AddBinaryFiles(info)

