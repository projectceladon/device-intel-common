insmod system/lib/modules/compat.ko

# Support building of stack-dev, that will build cfg80211.ko
# and mac80211.ko instade of iwl-cfg80211.ko and  iwl-mac80211.ko.
if [ -f /system/lib/modules/iwl-cfg80211.ko ]; then
        insmod /system/lib/modules/iwl-cfg80211.ko
        insmod /system/lib/modules/iwl-mac80211.ko
else
        insmod /system/lib/modules/cfg80211.ko
        insmod /system/lib/modules/mac80211.ko
fi

insmod /system/lib/modules/iwlwifi.ko nvm_file=iwl_nvm.bin d0i3_debug=1
insmod /system/lib/modules/iwlmvm.ko always_on=1
