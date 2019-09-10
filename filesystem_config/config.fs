#
# Copyright (C) 2015 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied. See the License for the specific language governing
# permissions and limitations under the License.
#

#
# NO NEW ENTRIES **DEPRECATED**
# Modules should define there own config.fs file and add it to
# TARGET_FS_CONFIG_GEN in their BoardConfig.mk per the README mentioned
# below.
#
# Information on this file can be found in: build/make/tools/fs_config/README
# This file should not be modified, mixins should add a TARGET_FS_CONFIG_GEN to
# there BoardConfig.mk

[AID_VENDOR_PSTORE]
value: 5001

[AID_VENDOR_INTEL_PROP]
value: 5002

[AID_VENDOR_WLAN_PROV]
value: 5003

#
# XXX: This patch was found not to be applied: https://android.intel.com/#/c/319973 note that this patch is not needed anymore see the README:
# build/make/tools/fs_config/README
# likely be removed.
#ifndef AID_TELEMETRY
#warning AID_TELEMETRY not defined, omitting telemetry entries from filesystem_config. The patch: https://android.intel.com/#/c/319973 may be missing."
#endif

#static const struct fs_path_config android_device_dirs[] = {
#ifdef AID_TELEMETRY
#    {	00550, AID_ROOT,   AID_TELEMETRY,	0, "system/etc/tm" },
#endif
#};
#
# XXX: This patch was found not to be applied: https://android.intel.com/#/c/319973
# This for android_device_files:
#ifdef AID_TELEMETRY
#	{ 00440, AID_ROOT,      AID_TELEMETRY, 0, "system/etc/tm/*" },
#endif

[system/vendor/gfx/ufo_byt/bin/]
mode: 0755
user: root
group: shell
caps: 0

[vendor/bin/storageproxyd]
mode: 0755
user: system
group: system
caps: sys_rawio

[system/bin/keymaster_meid]
mode: 0755
user: keystore
group: keystore
caps: block_suspend

[system/vendor/wifi/aosp/wpa_*]
mode: 0755
user: root
group: shell
caps: 0

[system/vendor/gfx/ufo_byt/bin/*]
mode: 0755
user: root
group: shell
caps: 0

[system/vendor/wifi/brcm/wpa_*]
mode: 0755
user: root
group: shell
caps: 0

[system/vendor/wifi/rtk/wpa_*]
mode: 0755
user: root
group: shell
caps: 0

[vendor/bin/esif_ufd]
mode: 0755
user: system
group: system
caps: net_raw sys_boot

[system/vendor/bin/coreu]
mode: 0755
user: root
group: shell
caps: sys_nice

[vendor/bin/coreu]
mode: 0755
user: root
group: shell
caps: sys_nice

[system/bin/audioserver]
mode: 0755
user: root
group: shell
caps: sys_nice
