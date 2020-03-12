import common
import fnmatch
import os
import sys
import tempfile
import subprocess
import zipfile
import json
import hashlib
import os, errno
import shlex
import shutil
import imp
import time
import collections
import time
import re
import random

from io import StringIO

sys.path.append("device/intel/build/releasetools")
import intel_common

_SIMG2IMG = "out/host/linux-x86/bin/simg2img"
_FASTBOOT = "out/host/linux-x86/bin/fastboot"
_VERIFYTOOL = "device/intel/common/recovery/verify_from_ota"

def hash_sparse_ext4_image(image_name):

  print("TFP: ", image_name)
  t = tempfile.NamedTemporaryFile(delete=False)
  OPTIONS.tempfiles.append(t.name)
  t.close()

  subprocess.check_call([_SIMG2IMG, image_name, t.name])
  remain = os.path.getsize(t.name)
  fd = open(t.name)
  hc = hashlib.sha1()

  while (remain):
      data = fd.read(1024 * 1024)
      hc.update(data)
      remain = remain - len(data)

  print("system hash", hc.hexdigest())
  fd.close()
  return hc.hexdigest()


def GetBootloaderImagesfromFls(unpack_dir, variant=None):
  """ EFI bootloaders, comprise of
  various partitions. The partitions are fixed """

  bootloader_zip_path = os.path.join(unpack_dir, "RADIO", "bootloader" + ".zip")
  bootloader_unzip_path = common.UnzipTemp(bootloader_zip_path)
  bootloader_unzip = zipfile.ZipFile(bootloader_zip_path,"r")
  additional_data_hash = collections.OrderedDict()

  print("bootloader unzip in ", bootloader_unzip_path)
  curr_loader = "loader.efi"
  loader_filepath = os.path.join(bootloader_unzip_path, curr_loader)
  if not os.path.exists(loader_filepath):
      print("Can't find ", loader_filepath)
      print("GetBootloaderImagesfromFls failed")
      return
  loader_file = open(loader_filepath)
  loader_data = loader_file.read()
  additional_data_hash['bootloader/loader.efi'] = loader_data
  loader_file.close()

  curr_loader = "bootx64.efi"
  loader_filepath = os.path.join(bootloader_unzip_path, "EFI/BOOT", curr_loader)
  if not os.path.exists(loader_filepath):
      print("Can't find ", loader_filepath)
      print("GetBootloaderImagesfromFls failed")
      return
  loader_file = open(loader_filepath)
  loader_data = loader_file.read()
  additional_data_hash['bootloader/EFI/BOOT/bootx64.efi'] = loader_data
  loader_file.close()

  curr_loader = "manifest.txt"
  loader_filepath = os.path.join(bootloader_unzip_path, curr_loader)
  if not os.path.exists(loader_filepath):
      print("Can't find ", loader_filepath)
      print("GetBootloaderImagesfromFls failed")
      return
  loader_file = open(loader_filepath)
  loader_data = loader_file.read()
  additional_data_hash['bootloader/manifest.txt'] = loader_data
  loader_file.close()

  curr_loader = "current.fv"
  loader_filepath = os.path.join(bootloader_unzip_path, "capsules",curr_loader)
  if not os.path.exists(loader_filepath):
      print("Can't find ", loader_filepath)
      print("GetBootloaderImagesfromFls failed")
      return
  loader_file = open(loader_filepath)
  loader_data = loader_file.read()
  additional_data_hash['bootloader/capsules/current.fv'] = loader_data
  loader_file.close()

  #need get boot/recovery/system data first
  curr_loader = "boot.img"
  loader_filepath = os.path.join(unpack_dir, "IMAGES", curr_loader)
  if not os.path.exists(loader_filepath):
      print("Can't find ", loader_filepath)
      print("GetBootloaderImagesfromFls failed")
      return
  loader_file = open(loader_filepath)
  loader_data = loader_file.read()
  additional_data_hash['boot'] = loader_data
  loader_file.close()

  curr_loader = "recovery.img"
  loader_filepath = os.path.join(unpack_dir, "IMAGES", curr_loader)
  if not os.path.exists(loader_filepath):
      print("Can't find ", loader_filepath)
      print("GetBootloaderImagesfromFls failed")
      return
  loader_file = open(loader_filepath)
  loader_data = loader_file.read()
  additional_data_hash['recovery'] = loader_data
  loader_file.close()

  curr_loader = "system.img"
  loader_filepath = os.path.join(unpack_dir, "IMAGES", curr_loader)
  if not os.path.exists(loader_filepath):
      print("Can't find ", loader_filepath)
      print("GetBootloaderImagesfromFls failed")
      return
  additional_data_hash['system'] = str(hash_sparse_ext4_image(loader_filepath))
  loader_file.close()
  return additional_data_hash

def Get_verifydata(info,infoinput):
  print("Trying to get verify data...")
  variant = None

  for app in [_SIMG2IMG, _FASTBOOT, _VERIFYTOOL]:
      if not os.path.exists(app):
          print("Can't find", app)
          print("Get_verifydata failed")
          return

  print("Extracting bootloader archive...")
  additional_data = GetBootloaderImagesfromFls(infoinput,None)
  if not additional_data:
    print("additional_data is None")
    return
  bootloader_sizes = ""
  imghash_value = "..."
  imghash_bootloader = ""

  for imgname, imgdata in additional_data.items():
      if imgname != 'bootloader' and imgname != 'system' and imgname != 'boot' and imgname != 'recovery':
          bootloader_sizes += ":" + str(len(imgdata))
      if imgname != 'system':
          imghash_value += "\n(bootloader) target: /" + str(imgname)
          imghash_value += "\n(bootloader) hash: " + str(hashlib.sha1(imgdata).hexdigest())
      if imgname == 'system':
          imghash_value += "\n(bootloader) target: /" + str(imgname)
          imghash_value += "\n(bootloader) hash: " + str(imgdata)
  imghash_value += imghash_bootloader + "\n"

  common.ZipWriteStr(info.output_zip, "verify/fastbootcmd.txt", bootloader_sizes)
  common.ZipWriteStr(info.output_zip, "verify/hashesfromtgt.txt", imghash_value)
  #write fastboot tool
  f = open(_FASTBOOT, "rb")
  fbbin = f.read()
  common.ZipWriteStr(info.output_zip, "verify/fastboot", fbbin, perms=0o755)
  f.close()
  #Save verify_from_ota script to OTA package
  f = open(_VERIFYTOOL, "r")
  data = f.read()
  common.ZipWriteStr(info.output_zip, "verify/verify_from_ota", data, perms=0o755)
  f.close()



# releasetools extensions for updating UserFastBoot boot image and the
# EFI system partition.
verbatim_targets = []
patch_list = []
delete_files = None
OPTIONS = common.OPTIONS

def IncrementalEspUpdateInit(info):
    global delete_files
    global patch_list
    global verbatim_targets

    output_files, delete_files, patch_list, verbatim_targets = \
            intel_common.ComputeBootloaderPatch(OPTIONS.source_tmp,
                                                OPTIONS.target_tmp)

    for f in output_files:
        f.AddToZip(info.output_zip)


def MountEsp(info, copy):
    # AOSP edify generator in build/ does not support vfat.
    # So we need to generate the full command to mount here.
    fstab = info.script.info.get("fstab", None)
    if copy:
        info.script.script.append('copy_partition("%s", "%s");' %
                (fstab['/bootloader'].device, fstab['/bootloader2'].device))
    info.script.script.append('mount("vfat", "EMMC", "%s", "/bootloader");' % (fstab['/bootloader2'].device))

def IncrementalOTA_Assertions(info):
    IncrementalEspUpdateInit(info)
    MountEsp(info, True)


def IncrementalOTA_VerifyEnd(info):
    # Check ESP component patches
    for tf, sf in patch_list:
        info.script.PatchCheck("/"+tf.name, tf.sha1, sf.sha1)


def swap_entries(info):
    fstab = info.script.info.get("fstab", None)
    info.script.script.append('swap_entries("%s", "bootloader", "bootloader2");' %
            (fstab['/bootloader'].device,))
    # Microsoft allows to use the FAT32 filesystem for the ESP
    # partition only and in the context of a UEFI device.  We have to
    # get rid of this potential second FAT32 partition.
    info.script.script.append('wipe_block_device("%s", "4096");' % (fstab['/bootloader'].device))

def IncrementalOTA_InstallEnd(info):
    if delete_files:
        info.script.Print("Removing unnecessary bootloader files...")
        info.script.DeleteFiles(delete_files)

    if patch_list:
        info.script.Print("Patching bootloader files...")
        for tf, sf in patch_list:
            info.script.ApplyPatch("/"+tf.name, "-", tf.size, tf.sha1,
                                   sf.sha1, "patch/"+tf.name+".p")

    if verbatim_targets:
        info.script.Print("Adding new bootloader files...")
        info.script.UnpackPackageDir("bootloader", "/bootloader")

    info.script.script.append('copy_sfu("/bootloader/capsules/current.fv");')
    info.script.script.append('unmount("/bootloader");')
    #swap_entries(info)
    Get_verifydata(info,OPTIONS.target_tmp)


def FullOTA_InstallEnd(info):
    data = intel_common.GetBootloaderImageFromTFP(OPTIONS.input_tmp)
    common.ZipWriteStr(info.output_zip, "bootloader.img", data)
    info.script.Print("Writing updated bootloader image...")
    info.script.WriteRawImage("/bootloader2", "bootloader.img")
    #swap_entries(info)
    Get_verifydata(info,info.input_tmp)

