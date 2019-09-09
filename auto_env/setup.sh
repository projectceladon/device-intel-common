#!/bin/bash

version=`cat /proc/version`

if [[ $version =~ "Ubuntu" ]]; then
	case $version in
		*"18.04"*)
			source ./setup_ubuntu_env.sh
			;;
		*"19.04"*)
			source ./setup_ubuntu_env.sh
			;;
		*)
			echo "Ubuntu 18.04 or higher version is supported"
			;;
	esac
elif [[ $version =~ "Clear Linux OS" ]]; then
	source setup_clearlinux_env.sh
else
	echo "only clearlinux or Ubuntu 18.04 or higher version is supported"
fi
