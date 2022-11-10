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


mkernel() {
    local T=$(gettop)
    local KERNEL_MAKEFILE=$(\cd "$T" && find device -name ${TARGET_PRODUCT}.mk | sed -e "s/${TARGET_PRODUCT}\.mk/AndroidBoard\.mk/")
    local ARGS=$(echo "$*"; [ -z "$(echo $* | sed -e "s/-[^ ]*//g" -e "s/ //g")" ] && echo "kernel")
    local POKY_MAKEFILE=prebuilts/gcc/linux-x86/x86/x86_64-linux-poky/Android.mk

    if [ ! -f $T/$KERNEL_MAKEFILE ] ; then
        echo "Kernel makefile not found for TARGET_PRODUCT=$TARGET_PRODUCT. abort" 1>&2
        return 1
    fi
    ONE_SHOT_MAKEFILE="$KERNEL_MAKEFILE $POKY_MAKEFILE" make -C $T -f build/core/main.mk $ARGS
}

mbimg() {
    local T=$(gettop)

    mkernel kernel $* || return

    echo ===[ Generating Ramdisk and ${PRODUCT_OUT}/boot.img]===
    (\cd "$T" && make ramdisk-nodeps $* && make bootimage-nodeps $*)
}

export INTEL_PATH_COMMON=device/intel/common
export INTEL_PATH_SEPOLICY=device/intel/sepolicy
export INTEL_PATH_BUILD=device/intel/build
export INTEL_PATH_HARDWARE=hardware/intel
export INTEL_PATH_VENDOR=vendor/intel
export INTEL_PATH_TARGET_DEVICE=device/intel/project-celadon
