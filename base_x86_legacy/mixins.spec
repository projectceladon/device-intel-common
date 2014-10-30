[main]
mixinsdir: device/intel/mixins/groups

[mapping]
product.mk: device.mk

[groups]
boot-arch: syslinux32
kernel: gmin64(path=gmin,loglevel=5)
display-density: medium
dalvik-heap: tablet-7in-hdpi-1024
cpu-arch: x86
houdini: true
bugreport: default
graphics: software
storage: emulated
ethernet: dhcp
media: ufo
sensors: iio
usb: host
usb-gadget: none
touch: none
navigationbar: true
device-type: tablet
gms: true
debug-tools: true
factory-scripts: true
sepolicy: permissive
charger: false
disk-bus: sata-1f.2
