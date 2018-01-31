#!/vendor/bin/sh

SLOT_SUFFIX=$(getprop ro.boot.slot_suffix)

if [ "$SLOT_SUFFIX" = "_a" ]; then
    setprop ota.update.abl b
elif [ "$SLOT_SUFFIX" = "_b" ]; then
    setprop ota.update.abl a
fi

exit 0
