#!/system/bin/sh

# WifiMonitor gives up after 5 seconds
sleep 3
exec /system/bin/wpa_supplicant "$@"
