#!/system/bin/sh

modules=`getprop ro.boot.moduleslocation`

insmod $modules/compat.ko

# Support building of stack-dev, that will build cfg80211.ko
# and mac80211.ko instade of iwl-cfg80211.ko and  iwl-mac80211.ko.
if [ -f $modules/iwl-cfg80211.ko ]; then
        insmod $modules/iwl-cfg80211.ko
        insmod $modules/iwl-mac80211.ko
else
        insmod $modules/cfg80211.ko
        insmod $modules/mac80211.ko
fi

if [ $1 == "--ptest-boot" ]; then
        insmod $modules/iwlwifi.ko nvm_file=nvmData xvt_default_mode=1
        insmod $modules/iwlxvt.ko
else
        insmod $modules/iwlwifi.ko
fi

insmod $modules/iwlmvm.ko
