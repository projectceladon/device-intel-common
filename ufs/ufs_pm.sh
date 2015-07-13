for lun in /sys/devices/pci0000\:00/0000\:00\:1d.0/host0/target0\:0\:0/0*; do
    if [[ -d $lun/power ]]; then
	echo 500  > $lun/power/autosuspend_delay_ms
	echo auto > $lun/power/control
    fi
done

