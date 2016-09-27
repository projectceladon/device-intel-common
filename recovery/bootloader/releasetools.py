import common

def WriteBldr(info, bootloader_img):
  common.ZipWriteStr(info.output_zip, "bootloader.img", bootloader_img)
  info.script.WriteRawImage("/bootloader", "bootloader.img")

def FullOTA_InstallEnd(info):
  try:
    bootloader_img = info.input_zip.read("RADIO/bootloader.img")
  except KeyError:
    print "no bootloader.img in target_files; skipping install"
  else:
    print "Add update for bootloader"
    WriteBldr(info, bootloader_img)

def IncrementalOTA_InstallEnd(info):
  try:
    target_bootloader_img = info.target_zip.read("RADIO/bootloader.img")
    try:
      source_bootloader_img = info.source_zip.read("RADIO/bootloader.img")
    except KeyError:
      source_bootloader_img = None

    if source_bootloader_img == target_bootloader_img:
      print "bootloader.img unchanged; skipping"
    else:
      print "bootloader.img changed; adding it"
      WriteBldr(info, target_bootloader_img)
  except KeyError:
    print "no bootloader.img in target target_files; skipping install"

