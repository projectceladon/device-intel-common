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
target_data = None
bootloader_update = False
source_data = None
OPTIONS = common.OPTIONS

sfu_path = "SYSTEM/etc/firmware/BIOSUPDATE.fv"

def LoadBootloaderFiles(tfpdir):
    out = {}
    data = intel_common.GetBootloaderImageFromTFP(tfpdir)
    image = common.File("bootloader.img", data).WriteToTemp()

    # Extract the contents of the VFAT bootloader image so we
    # can compute diffs on a per-file basis
    esp_root = tempfile.mkdtemp(prefix="bootloader-")
    OPTIONS.tempfiles.append(esp_root)
    intel_common.add_dir_to_path("/sbin")
    subprocess.check_output(["mcopy", "-s", "-i", image.name, "::*", esp_root]);
    image.close();

    for dpath, dname, fnames in os.walk(esp_root):
        for fname in fnames:
            # Capsule update file -- gets consumed and deleted by the firmware
            # at first boot, shouldn't try to patch it
            if (fname == "BIOSUPDATE.fv"):
                continue
            abspath = os.path.join(dpath, fname)
            relpath = os.path.relpath(abspath, esp_root)
            data = open(abspath).read()
            print relpath
            out[relpath] = common.File("bootloader/" + relpath, data)

    return out

def IncrementalEspUpdateInit(info):
    global target_data
    global source_data
    global delete_files
    global bootloader_update

    target_data = LoadBootloaderFiles(OPTIONS.target_tmp)
    source_data = LoadBootloaderFiles(OPTIONS.source_tmp)

    diffs = []

    for fn in sorted(target_data.keys()):
        tf = target_data[fn]
        sf = source_data.get(fn, None)

        if sf is None:
            tf.AddToZip(info.output_zip)
            verbatim_targets.append(fn)
        elif tf.sha1 != sf.sha1:
            diffs.append(common.Difference(tf, sf))

    common.ComputeDifferences(diffs)

    for diff in diffs:
        tf, sf, d = diff.GetPatch()
        if d is None or len(d) > tf.size * 0.95:
            tf.AddToZip(info.output_zip)
            verbatim_targets.append(tf.name)
        else:
            common.ZipWriteStr(info.output_zip, "patch/" + tf.name + ".p", d)
            patch_list.append((tf.name, tf, sf, tf.size, common.sha1(d).hexdigest()))

    delete_files = (["/"+i[0] for i in verbatim_targets] +
                     ["/"+i for i in sorted(source_data) if i not in target_data])

    if (delete_files or patch_list or verbatim_targets or
            os.path.exists(os.path.join(OPTIONS.target_tmp, sfu_path))):
        print "EFI System Partition will be updated"
        bootloader_update = True


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
    if bootloader_update:
        MountEsp(info, True)


def IncrementalOTA_VerifyEnd(info):
    # Check ESP component patches
    for fn, tf, sf, size, patch_sha in patch_list:
        info.script.PatchCheck("/"+fn, tf.sha1, sf.sha1)


def swap_entries(info):
    fstab = info.script.info.get("fstab", None)
    info.script.script.append('swap_entries("%s", "android_bootloader", "android_bootloader2");' %
            (fstab['/bootloader'].device,))

def HasRecoveryPatch(outdir):
    return os.path.exists(os.path.join(outdir, "SYSTEM/recovery-from-boot.p"))

def is_block_ota(info, incremental):
    if not OPTIONS.block_based:
        return False

    if incremental:
        return HasRecoveryPatch(OPTIONS.source_tmp) and HasRecoveryPatch(OPTIONS.target_tmp)
    else:
        return HasRecoveryPatch(OPTIONS.input_tmp)

def IncrementalOTA_InstallEnd(info):
    if not bootloader_update:
        return

    if delete_files:
        info.script.Print("Removing unnecessary bootloader files...")
        info.script.DeleteFiles(delete_files)

    if patch_list:
        info.script.Print("Patching bootloader files...")
        for item in patch_list:
            fn, tf, sf, size, _ = item
            info.script.ApplyPatch("/"+fn, "-", tf.size, tf.sha1, sf.sha1, "patch/"+fn+".p")

    if verbatim_targets:
        info.script.Print("Adding new bootloader files...")
        info.script.UnpackPackageDir("bootloader", "/bootloader")

    info.script.script.append('copy_shim();')
    if is_block_ota(info, True):
        print "This is a block-level OTA, mounting /system before SFU copy"
        info.script.Mount("/system");
    info.script.script.append('copy_sfu();')
    info.script.script.append('unmount("/bootloader");')
    swap_entries(info)


def FullOTA_InstallEnd(info):
    data = intel_common.GetBootloaderImageFromTFP(OPTIONS.input_tmp)
    common.ZipWriteStr(info.output_zip, "bootloader.img", data)
    info.script.Print("Writing updated bootloader image...")
    info.script.WriteRawImage("/bootloader2", "bootloader.img")
    swap_entries(info)


