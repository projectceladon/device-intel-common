import common
import fnmatch
import os
import sys
import tempfile

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
    esp_root, esp_zip = common.UnzipTemp(os.path.join(tfpdir, "RADIO", "bootloader.zip"))

    for info in esp_zip.infolist():
        data = esp_zip.read(info.filename)
        out[info.filename] = common.File("bootloader/" + info.filename, data)
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


fastboot = {}

def IncrementalOTA_Assertions(info):
    fastboot["source"] = intel_common.GetFastbootImage(OPTIONS.source_tmp,
                OPTIONS.source_info_dict)
    fastboot["target"] = intel_common.GetFastbootImage(OPTIONS.target_tmp,
                OPTIONS.target_info_dict)
    # Policy: if both exist, try to do a patch update
    # if target but not source, write out the target verbatim
    # if source but not target, or neither, do nothing
    if fastboot["target"]:
        if fastboot["source"]:
            fastboot["updating"] = fastboot["source"].data != fastboot["target"].data
            fastboot["verbatim"] = False
        else:
            fastboot["updating"] = False
            fastboot["verbatim"] = True
    else:
        fastboot["updating"] = False
        fastboot["verbatim"] = False

    IncrementalEspUpdateInit(info)
    if bootloader_update:
        MountEsp(info, True)


def IncrementalOTA_VerifyEnd(info):
    # Check fastboot patch
    if fastboot["updating"]:
        target_boot = fastboot["target"]
        source_boot = fastboot["source"]
        d = common.Difference(target_boot, source_boot)
        _, _, d = d.ComputePatch()
        print "fastboot  target: %d  source: %d  diff: %d" % (
            target_boot.size, source_boot.size, len(d))

        common.ZipWriteStr(info.output_zip, "patch/fastboot.img.p", d)

        boot_type, boot_device = common.GetTypeAndDevice("/fastboot", OPTIONS.info_dict)
        info.script.PatchCheck("%s:%s:%d:%s:%d:%s" %
                          (boot_type, boot_device,
                           source_boot.size, source_boot.sha1,
                           target_boot.size, target_boot.sha1))
        fastboot["boot_type"] = boot_type
        fastboot["boot_device"] = boot_device

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
    if fastboot["updating"]:
        target_boot = fastboot["target"]
        source_boot = fastboot["source"]
        boot_type = fastboot["boot_type"]
        boot_device = fastboot["boot_device"]
        info.script.Print("Patching fastboot image...")
        info.script.ApplyPatch("%s:%s:%d:%s:%d:%s"
                          % (boot_type, boot_device,
                             source_boot.size, source_boot.sha1,
                             target_boot.size, target_boot.sha1),
                          "-",
                          target_boot.size, target_boot.sha1,
                          source_boot.sha1, "patch/fastboot.img.p")
        print "fastboot image changed; including."
    elif fastboot["verbatim"]:
        common.ZipWriteStr(info.output_zip, "fastboot.img", fastboot["target"].data)
        info.script.WriteRawImage("/fastboot", "fastboot.img")
        print "fastboot not present in source archive; including verbatim"
    else:
        print "skipping fastboot update"

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
    fastboot_img = intel_common.GetFastbootImage(OPTIONS.input_tmp, OPTIONS.info_dict)
    if fastboot_img:
        common.ZipWriteStr(info.output_zip, "fastboot.img", fastboot_img.data)
        info.script.WriteRawImage("/fastboot", "fastboot.img")
    else:
        print "No fastboot data found, skipping"

    bf = tempfile.NamedTemporaryFile(delete=False)
    bname = bf.name
    bf.close()
    size = int(open(os.path.join(OPTIONS.input_tmp, "RADIO", "bootloader-size.txt")).read().strip())
    intel_common.MakeVFATFilesystem(os.path.join(OPTIONS.input_tmp, "RADIO", "bootloader.zip"),
            bname, size=size)

    bf = open(bname)
    data = bf.read()
    bf.close()
    os.unlink(bname)
    common.ZipWriteStr(info.output_zip, "bootloader.img", data)
    info.script.Print("Writing updated bootloader image...")
    info.script.WriteRawImage("/bootloader2", "bootloader.img")

    if os.path.exists(os.path.join(OPTIONS.input_tmp, sfu_path)):
        MountEsp(info, False)
        if is_block_ota(info, False):
            print "This is a block-level OTA, mounting /system before SFU copy"
            info.script.Mount("/system");
        info.script.script.append('copy_sfu();')
        info.script.script.append('unmount("/bootloader");')

    swap_entries(info)


