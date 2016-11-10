if [ -f device/intel/mixins/mixin-update ]; then
    if ! device/intel/mixins/mixin-update --dry-run; then
        echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
        echo '+ Product configuration and mixins are out of sync                      +'
        echo '+ PLEASE RE-RUN device/intel/mixins/mixin-update and commit the result! +'
        echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
    fi
fi

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
