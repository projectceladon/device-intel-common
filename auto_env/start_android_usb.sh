#!/bin/bash
g_file="/sys/bus/pci/devices/0000:00:02.0/4ec1ff92-81d7-11e9-aed4-5bf6a9a2bb0a"

if [ ! -d $g_file ]; then
	echo "Create VGPU at first!"
	sudo sh -c "echo 4ec1ff92-81d7-11e9-aed4-5bf6a9a2bb0a > /sys/bus/pci/devices/0000:00:02.0/mdev_supported_types/i915-GVTg_V5_8/create"
fi

echo "VGPU has been created already. Launch QEMU!"

/usr/bin/qemu-system-x86_64 \
  -m 2048 -smp 2 -M q35 \
  -name aaas-vm \
  -enable-kvm \
  -vga none \
  -display gtk,gl=on \
  -device vfio-pci,sysfsdev=/sys/bus/pci/devices/0000:00:02.0/4ec1ff92-81d7-11e9-aed4-5bf6a9a2bb0a,display=on,x-igd-opregion=on \
  -k en-us \
  -machine kernel_irqchip=on \
  -global PIIX4_PM.disable_s3=1 -global PIIX4_PM.disable_s4=1 \
  -cpu host \
  -usb \
  -device usb-mouse \
  -device usb-kbd \
  -bios ./OVMF.fd \
  -chardev socket,id=charserial0,path=./kernel-console,server,nowait \
  -device isa-serial,chardev=charserial0,id=serial0 \
  -device qemu-xhci,id=xhci,addr=0x8 \
  -device usb-host,bus=xhci.0,vendorid=0x0781,productid=0x5591 \
  -device usb-host,bus=xhci.0,vendorid=0x8087,productid=0x0a2b \
  -device e1000,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::5555-:5555 \
  -device intel-hda -device hda-duplex \

