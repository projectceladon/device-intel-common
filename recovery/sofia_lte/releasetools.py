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
from cStringIO import StringIO

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


def AddBinaryFiles(info,infoinput):
  provdata_name = os.path.join("RADIO", "provdata.zip")
  if provdata_name in infoinput.namelist():
    with zipfile.ZipFile(StringIO(infoinput.read(provdata_name))) as provdata_zip:
        fwu_image = provdata_zip.read("fwu_image.bin")
    common.ZipWriteStr(info.output_zip, "fwu_image.bin", fwu_image)
  else:
    # fwu_image will get populated by ota_deployment_fixup script
    pass

  info.script.SetProgress(0.6) #Set progress bar to end of FLS extraction

  info.script.WriteRawImage("/fwupdate", "fwu_image.bin");
  trigger_fwupdate(info)

#REVERTME need remove it when update boot/recovery use Android solution
#Revert is tracked by:https://jira01.devtools.intel.com/browse/CTEAN-3303
def init_t2f_dict(t2f_list):
  d = {}
  for l in t2f_list.split():
    target, fname = l.split(':')
    d[target] = fname
  return d

def Add_Recoverysecbin(info,infoinput):
  variant = None
  provdata_zip  = 'provdata_%s.zip' % variant if variant else 'provdata.zip'
  provdata_name = os.path.join(infoinput, "RADIO", provdata_zip)
  provdata, provdata_zip = common.UnzipTemp(provdata_name)
  target2file = open(os.path.join(infoinput, "RADIO", "fftf_build.opt")).read().strip()
  #target2file = open(os.path.join(provdata, "fftf_build.opt")).read().strip()
  t2f = init_t2f_dict(target2file)
  flstool = t2f["FLSTOOL"]
  cmd = [flstool, "--prg", os.path.join(provdata, os.path.basename(t2f["INTEL_PRG_FILE"])),
                  "--output", os.path.join(infoinput, "IMAGES", 'recovery.fls'),
                  "--tag=RECOVERY"]

  if (t2f["PSI_RAM_FLS"] != '') and (t2f["EBL_FLS"] != ''):
    cmd.extend(["--psi", os.path.join(provdata, os.path.basename(t2f["PSI_RAM_FLS"]))])
    cmd.extend(["--ebl-sec", os.path.join(provdata, os.path.basename(t2f["EBL_FLS"]))])

  cmd.append(os.path.join(infoinput, "IMAGES", 'recovery.img'))
  cmd.extend(["--replace", "--to-fls2"])
  print "execute 1.command: {}".format(' '.join(cmd))
  try:
    p = common.Run(cmd)
  except Exception as exc:
    print "Error: Unable to execute command: {}".format(' '.join(cmd))
    raise exc
  p.communicate()
  assert p.returncode == 0, "FlsTool failed"
  cmd = [flstool, "-o", os.path.join(infoinput, "IMAGES"),
                  "-x", os.path.join(infoinput, "IMAGES", 'recovery.fls')]
  print "execute 2.command: {}".format(' '.join(cmd))
  try:
    p = common.Run(cmd)
  except Exception as exc:
    print "Error: Unable to execute command: {}".format(' '.join(cmd))
    raise exc
  p.communicate()
  assert p.returncode == 0, "FlsTool failed"
  binary_merge = "hardware/intel/sofia_lte-fls/tools/binary_merge"
  cmd = [binary_merge, "-o", os.path.join(infoinput, "IMAGES", "recovery.secbin"),
                       "-b 512 -p 0"]
  cmd.append(os.path.join(infoinput, "IMAGES", 'recovery.fls_ID0_CUST_SecureBlock.bin'))
  cmd.append(os.path.join(infoinput, "IMAGES", 'recovery.fls_ID0_CUST_LoadMap0.bin'))
  print "execute 3.command: {}".format(' '.join(cmd))
  try:
    p = common.Run(cmd)
  except Exception as exc:
    print "Error: Unable to execute command: {}".format(' '.join(cmd))
    raise exc
  p.communicate()
  assert p.returncode == 0, "binary_merge failed"
  boot_name = os.path.join(infoinput, "IMAGES", "recovery.secbin")
  bootsecbin = open(boot_name)
  data = bootsecbin.read()
  bootsecbin.close()
  os.unlink(boot_name)
  common.ZipWriteStr(info.output_zip, "recovery.secbin", data)
  info.script.WriteRawImage("/recovery", "recovery.secbin");

def Add_Bootsecbin(info,infoinput):
  variant = None
  provdata_zip  = 'provdata_%s.zip' % variant if variant else 'provdata.zip'
  provdata_name = os.path.join(infoinput, "RADIO", provdata_zip)
  provdata, provdata_zip = common.UnzipTemp(provdata_name)
  target2file = open(os.path.join(infoinput, "RADIO", "fftf_build.opt")).read().strip()
  #target2file = open(os.path.join(provdata, "fftf_build.opt")).read().strip()
  t2f = init_t2f_dict(target2file)
  flstool = t2f["FLSTOOL"]
  cmd = [flstool, "--prg", os.path.join(provdata, os.path.basename(t2f["INTEL_PRG_FILE"])),
                  "--output", os.path.join(infoinput, "IMAGES", 'boot.fls'),
                  "--tag", "BOOT_IMG"]

  if (t2f["PSI_RAM_FLS"] != '') and (t2f["EBL_FLS"] != ''):
    cmd.extend(["--psi", os.path.join(provdata, os.path.basename(t2f["PSI_RAM_FLS"]))])
    cmd.extend(["--ebl-sec", os.path.join(provdata, os.path.basename(t2f["EBL_FLS"]))])

  cmd.append(os.path.join(infoinput, "IMAGES", 'boot.img'))
  cmd.extend(["--replace", "--to-fls2"])
  print "execute 1.command: {}".format(' '.join(cmd))
  try:
    p = common.Run(cmd)
  except Exception as exc:
    print "Error: Unable to execute command: {}".format(' '.join(cmd))
    raise exc
  p.communicate()
  assert p.returncode == 0, "FlsTool failed"
  cmd = [flstool, "-o", os.path.join(infoinput, "IMAGES"),
                  "-x", os.path.join(infoinput, "IMAGES", 'boot.fls')]
  print "execute 2.command: {}".format(' '.join(cmd))
  try:
    p = common.Run(cmd)
  except Exception as exc:
    print "Error: Unable to execute command: {}".format(' '.join(cmd))
    raise exc
  p.communicate()
  assert p.returncode == 0, "FlsTool failed"
  binary_merge = "hardware/intel/sofia_lte-fls/tools/binary_merge"
  cmd = [binary_merge, "-o", os.path.join(infoinput, "IMAGES", "boot.secbin"),
                       "-b 512 -p 0"]
  cmd.append(os.path.join(infoinput, "IMAGES", 'boot.fls_ID0_CUST_SecureBlock.bin'))
  cmd.append(os.path.join(infoinput, "IMAGES", 'boot.fls_ID0_CUST_LoadMap0.bin'))
  print "execute 3.command: {}".format(' '.join(cmd))
  try:
    p = common.Run(cmd)
  except Exception as exc:
    print "Error: Unable to execute command: {}".format(' '.join(cmd))
    raise exc
  p.communicate()
  assert p.returncode == 0, "binary_merge failed"
  boot_name = os.path.join(infoinput, "IMAGES", "boot.secbin")
  bootsecbin = open(boot_name)
  data = bootsecbin.read()
  bootsecbin.close()
  os.unlink(boot_name)
  common.ZipWriteStr(info.output_zip, "boot.secbin", data)
  info.script.WriteRawImage("/boot", "boot.secbin");

#These steps are called in the end of an OTA update
def FullOTA_InstallEnd(info):
  print "Intel: vendor specific OTA end hook for full OTA update"
  Add_Bootsecbin(info,info.input_tmp)
  Add_Recoverysecbin(info,info.input_tmp)
  AddBinaryFiles(info,info.input_zip)


# Called during an incremental update before any changes are made
def IncrementalOTA_VerifyEnd(info):
  global patchinfo

  print "Calculating fwupdate patch information"
  src_fwupdate = get_file_data(OPTIONS.source_tmp, "fwu_image.bin")
  tgt_fwupdate = get_file_data(OPTIONS.target_tmp, "fwu_image.bin")

  diffs = [common.Difference(tgt_fwupdate, src_fwupdate)]
  common.ComputeDifferences(diffs)

  tf, sf, d = diffs[0].GetPatch()
  # If the patch size is almost as big as the actual file don't bother
  if d is None or len(d) > tf.size * 0.95:
    print "Firmware update image will be included verbatim"
    return

  common.ZipWriteStr(info.output_zip, "patch/fwu_image.bin.p", d)
  fwu_type, fwu_device = common.GetTypeAndDevice("/fwupdate", OPTIONS.info_dict)
  # This check ensure fwupdate partition is in an expected state before
  # the OTA system makes any changes
  #info.script.PatchCheck("%s:%s:%d:%s:%d:%s" %
  #                       (fwu_type, fwu_device, sf.size,
  #                        sf.sha1, tf.size, tf.sha1))
  patchinfo = (fwu_type, fwu_device, sf, tf)


def IncrementalOTA_InstallEnd(info):
  print "Intel: vendor specific OTA end hook for incremental OTA update"
  Add_Bootsecbin(info,OPTIONS.target_tmp)
  Add_Recoverysecbin(info,OPTIONS.target_tmp)
  AddBinaryFiles(info,info.target_zip)

