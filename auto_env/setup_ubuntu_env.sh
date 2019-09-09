#!/bin/bash

reboot_required=0

function changes_require(){
	echo "If you run the installation first time, reboot is required"
	read -p "QEMU version will be replaced, do you want to continue? [Y/n]" res
	if [ x$res = xn ]; then
		exit 0
	fi
}

function set_apt_env_sh(){
	export http_proxy=http://child-prc.intel.com:913/
	export https_proxy=https://child-prc.intel.com:913/
	export ftp_proxy=ftp://child-prc.intel.com:913/

	[[ ! `cat /etc/apt/apt.conf` =~ "http://child-prc.intel.com:913/" ]] \
	&& echo 'Acquire::http::proxy "http://child-prc.intel.com:913/";' > /etc/apt/apt.conf \
	&& echo 'Acquire::https::proxy "https://child-prc.intel.com:913/";' >> /etc/apt/apt.conf \
	&& echo 'Acquire::ftp::proxy "ftp://child-prc.intel.com:913/";' >> /etc/apt/apt.conf

	[[ ! `cat /etc/apt/sources.list` =~ "http://mirrors.aliyun.com/ubuntu/" ]] \
	&& sed -i "1i\deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" /etc/apt/sources.list \
	&& sed -i "1i\deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" /etc/apt/sources.list \
	&& sed -i "1i\deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" /etc/apt/sources.list \
	&& sed -i "1i\deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" /etc/apt/sources.list \
	&& sed -i "1i\deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" /etc/apt/sources.list \
	&& sed -i "1i\deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" /etc/apt/sources.list \
	&& sed -i "1i\deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" /etc/apt/sources.list \
	&& sed -i "1i\deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" /etc/apt/sources.list \
	&& sed -i "1i\deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" /etc/apt/sources.list \
	&& sed -i "1i\deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" /etc/apt/sources.list \
	&& apt update \
	&& apt install -y openssh-server
}

function install_qemu(){
	apt purge -y "qemu*"
	apt autoremove -y

	dpkg -i qemu-2.12-gvtg_2.12-gvtg-1_amd64.deb
	if [ $? = 1 ]; then
		echo "Try to fix the dependence..."
		apt -f -y install
		dpkg -i qemu-2.12-gvtg_2.12-gvtg-1_amd64.deb
	fi

}

function enable_host_gvtg(){
	[[ ! `cat /etc/default/grub` =~ "i915.enable_gvt=1 intel_iommu=on" ]] \
	&& sed -i "s/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"i915.enable_gvt=1 intel_iommu=on /g" /etc/default/grub \
	&& update-grub \
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
set_apt_env_sh
install_qemu
enable_host_gvtg
ask_reboot
