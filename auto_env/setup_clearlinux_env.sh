#!/bin/bash

reboot_required=0

function changes_require(){
	echo "If you run the installation first time, reboot is required"
	read -p "QEMU version may be updated, do you want to continue? [Y/n]" res
	if [ x$res = xn ]; then
		exit 0
	fi
}

function set_bundle_env_sh(){
	export http_proxy=http://child-prc.intel.com:913/
	export https_proxy=http://child-prc.intel.com:913/
	export ftp_proxy=ftp://child-prc.intel.com:913/
	[[ ! -d /var/cache/ca-certs ]] && clrtrust generate
}

function install_qemu(){
	swupd clean
	swupd bundle-add kvm-host
}

function enable_host_gvtg(){
	[[ ! -f /etc/kernel/cmdline.d/gvtg.conf ]] \
	&& mkdir -p /etc/kernel/cmdline.d/ \
	&& echo "i915.enable_gvt=1 kvm.ignore_msrs=1 intel_iommu=on" > /etc/kernel/cmdline.d/gvtg.conf \
	&& clr-boot-manager update \
	&& reboot_required=1
}

function ask_reboot(){
	if [ $reboot_required -eq 1 ];then
		read -p "Reboot is required, do you want to reboot it NOW? [y/N]" res
		if [ x$res = xy ]; then
			reboot
		else
			echo "Please reboot system later to take effect"
		fi
	fi
}

changes_require
set_bundle_env_sh
install_qemu
enable_host_gvtg
ask_reboot
