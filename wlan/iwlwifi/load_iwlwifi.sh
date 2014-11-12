
insmod system/lib/modules/compat.ko
insmod system/lib/modules/iwl-cfg80211.ko
insmod system/lib/modules/iwl-mac80211.ko

if [ $1 == "--ptest-boot" ]; then
        insmod system/lib/modules/iwlwifi.ko nvm_file=nvmData xvt_default_mode=1
        insmod system/lib/modules/iwlxvt.ko
else
        insmod system/lib/modules/iwlwifi.ko nvm_file=nvmData d0i3_debug=1
        insmod system/lib/modules/iwlmvm.ko power_scheme=1
        # set driver wifi driver property so hal will know that it is loaded
        setprop wlan.driver.status "ok"

fi
