import common
import fnmatch
import os
import sys
import tempfile
import subprocess

sys.path.append("device/intel/build/releasetools")
import intel_common

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
    info.script.script.append('swap_entries("%s", "android_bootloader", "android_bootloader2");' %
            (fstab['/bootloader'].device,))

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
    swap_entries(info)


def FullOTA_InstallEnd(info):
    data = intel_common.GetBootloaderImageFromTFP(OPTIONS.input_tmp)
    common.ZipWriteStr(info.output_zip, "bootloader.img", data)
    info.script.Print("Writing updated bootloader image...")
    info.script.WriteRawImage("/bootloader2", "bootloader.img")
    swap_entries(info)


