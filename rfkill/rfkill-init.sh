#!/system/bin/sh

BT_DEV_ID="OBDA8723"
GPS_DEV_ID="BCM4752E"
RFKILL_ROOT_DIR="/sys/class/rfkill"

# Look for the rfkill associated to BT device
cd ${RFKILL_ROOT_DIR}
rfkill_dirs=`/system/bin/ls -d rfkill*`
for rfkill in ${rfkill_dirs}
do
    # Extract dev id from alias
    alias=`cat ${rfkill}/device/modalias 2> /dev/null`
    dev_id="${alias%:*}"
    dev_id="${dev_id#*:}"

    if [ "${BT_DEV_ID}" = "${dev_id}" ]; then
        rfkill_id=${rfkill}
    fi

    if [ "${GPS_DEV_ID}" = "${dev_id}" ]; then
        gps_rfkill_id=${rfkill}
    fi
done

# Force disable BT chip if needed
bt_state=`getprop bluetooth.hwcfg`
if [ ! -z "${rfkill_id}" ] && [ "${bt_state}" = "stop" ]; then
    echo 0 > ${rfkill_id}/state
fi

if [ ! -z "${gps_rfkill_id}" ]; then
    echo 0 > ${gps_rfkill_id}/state
fi
