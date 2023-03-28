#!/bin/bash

RELEASE=$1
LINUXFAMILY=$2
BOARD=$3
BUILD_DESKTOP=$4
ARCH=$5

set -e

# Freeze armbian/kernel version
apt-mark hold armbian-firmware
apt-mark hold armbian-bsp-cli-${BOARD}
apt-mark hold linux-image-*-${LINUXFAMILY}
apt-mark hold linux-u-boot-${BOARD}-*

# Set mirrors to USTC
sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sed -i 's|security.debian.org|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list
sed -i 's|apt.armbian.com|mirrors.ustc.edu.cn/armbian|g' /etc/apt/sources.list.d/armbian.list

# ZCube1 Max no have WiFi
if [ "${BOARD}" = "zcube1-max" ]; then
    systemctl disable wpa_supplicant.service
fi
