#
# Copyright (C) 2015 Intel Corporation
#
# Releasetools hook for Sofia
#
# Here you can add variant specific custom steps to the OTA process
#
import common
import os
import zipfile
from io import StringIO

OPTIONS = common.OPTIONS
patchinfo = None


def get_file_data(tmpdir, path):
    provdata_name = os.path.join(tmpdir, "RADIO", "provdata.zip")
    with zipfile.ZipFile(provdata_name) as provdata_zip:
        data = provdata_zip.read(path)
    return common.File(path, data)


def trigger_fwupdate(info):
  _, misc_device = common.GetTypeAndDevice("/misc", OPTIONS.info_dict)
  info.script.script.append('intel_install_firmware_update("%s");'
      % misc_device)


def AddBinaryFiles(info):
  provdata_name = os.path.join("RADIO", "provdata.zip")
  if provdata_name in info.input_zip.namelist():
    with zipfile.ZipFile(StringIO(info.input_zip.read(provdata_name))) as provdata_zip:
        fwu_image = provdata_zip.read("fwu_image.bin")
    common.ZipWriteStr(info.output_zip, "fwu_image.bin", fwu_image)
  else:
    # fwu_image will get populated by ota_deployment_fixup script
    pass

  info.script.SetProgress(0.6) #Set progress bar to end of FLS extraction

  info.script.WriteRawImage("/fwupdate", "fwu_image.bin");
  trigger_fwupdate(info)


#These steps are called in the end of an OTA update
def FullOTA_InstallEnd(info):
  print("Intel: vendor specific OTA end hook for full OTA update")
  AddBinaryFiles(info)


# Called during an incremental update before any changes are made
def IncrementalOTA_VerifyEnd(info):
  global patchinfo

  print("Calculating fwupdate patch information")
  src_fwupdate = get_file_data(OPTIONS.source_tmp, "fwu_image.bin")
  tgt_fwupdate = get_file_data(OPTIONS.target_tmp, "fwu_image.bin")

  diffs = [common.Difference(tgt_fwupdate, src_fwupdate)]
  common.ComputeDifferences(diffs)

  tf, sf, d = diffs[0].GetPatch()
  # If the patch size is almost as big as the actual file don't bother
  if d is None or len(d) > tf.size * 0.95:
    print("Firmware update image will be included verbatim")
    return

  common.ZipWriteStr(info.output_zip, "patch/fwu_image.bin.p", d)
  fwu_type, fwu_device = common.GetTypeAndDevice("/fwupdate", OPTIONS.info_dict)
  # This check ensure fwupdate partition is in an expected state before
  # the OTA system makes any changes
  info.script.PatchCheck("%s:%s:%d:%s:%d:%s" %
                         (fwu_type, fwu_device, sf.size,
                          sf.sha1, tf.size, tf.sha1))
  patchinfo = (fwu_type, fwu_device, sf, tf)


def IncrementalOTA_InstallEnd(info):
  print("Intel: vendor specific OTA end hook for incremental OTA update")
  if not patchinfo:
    AddBinaryFiles(info)
    return

  fwu_type, fwu_device, sf, tf = patchinfo
  info.script.ApplyPatch("%s:%s:%d:%s:%d:%s" % (fwu_type, fwu_device, sf.size,
                                                sf.sha1, tf.size, tf.sha1),
                         "-", tf.size, tf.sha1, sf.sha1,
                         "patch/fwu_image.bin.p")
  trigger_fwupdate(info)

