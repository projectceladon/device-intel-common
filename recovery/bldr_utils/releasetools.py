import common

def WriteBldr(info, bldr_utils_img):
  common.ZipWriteStr(info.output_zip, "bldr_utils_img", bldr_utils_img)
  info.script.WriteRawImage("/bldr_utils", "bldr_utils.img")

def FullOTA_InstallEnd(info):
  try:
    bldr_utils_img = info.input_zip.read("RADIO/bldr_utils.img")
  except KeyError:
    print "no bldr_utils.img in target_files; skipping install"
  else:
    print "Add update for bldr_utils"
    WriteBldr(info, bldr_utils_img)

def IncrementalOTA_InstallEnd(info):
  try:
    target_bldr_utils_img = info.target_zip.read("RADIO/bldr_utils.img")
    try:
      source_bldr_utils_img = info.source_zip.read("RADIO/bldr_utils.img")
    except KeyError:
      source_bldr_utils_img = None

    if source_bldr_utils_img == target_bldr_utils_img:
      print "bldr_utils.img unchanged; skipping"
    else:
      print "bldr_utils.img changed; adding it"
      WriteBldr(info, target_bldr_utils_img)
  except KeyError:
    print "no bldr_utils.img in target target_files; skipping install"

