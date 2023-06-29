#!/bin/bash

RELEASE=$1
LINUXFAMILY=$2
BOARD=$3
BUILD_DESKTOP=$4
ARCH=$5

set -e

# Freeze armbian/kernel/dtb version
apt-mark hold armbian-firmware
apt-mark hold armbian-bsp-cli-*
apt-mark hold linux-image-*
apt-mark hold linux-source-*
apt-mark hold linux-headers-*
apt-mark hold linux-dtb-*
apt-mark hold linux-u-boot-*

# Set mirrors to USTC
sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sed -i 's|security.debian.org|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list
sed -i 's|apt.armbian.com|mirrors.ustc.edu.cn/armbian|g' /etc/apt/sources.list.d/armbian.list

# modules-load.d
echo i2c_dev > /etc/modules-load.d/i2c_dev.conf

# htoprc
mkdir -p /etc/skel/.config/htop
cat <<EOF >/etc/skel/.config/htop/htoprc
show_cpu_usage=1
show_cpu_frequency=1
show_cpu_temperature=1
tree_view=1
highlight_threads=0

EOF

# ZCube1 Max no have WiFi
if [ "${BOARD}" = "zcube1-max" ]; then
    systemctl disable wpa_supplicant.service
fi
