#!/bin/bash

RELEASE=$1
LINUXFAMILY=$2
BOARD=$3
BUILD_DESKTOP=$4
ARCH=$5

FIRST_RUN=/root/first_run.sh

set -e

# Freeze armbian/kernel/dtb version
apt-mark hold armbian-firmware
apt-mark hold armbian-bsp-cli-*
apt-mark hold linux-image-*
apt-mark hold linux-dtb-*
apt-mark hold linux-u-boot-*

cat <<EOF >${FIRST_RUN}
#!/bin/bash

# Set mirrors to USTC
sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sed -i 's|security.debian.org|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list
sed -i 's|apt.armbian.com|mirrors.ustc.edu.cn/armbian|g' /etc/apt/sources.list.d/armbian.list

EOF
chmod +x ${FIRST_RUN}

# htoprc
mkdir -p /etc/skel/.config/htop
cat <<EOF >/etc/skel/.config/htop/htoprc
show_cpu_usage=1
show_cpu_frequency=1
show_cpu_temperature=1
tree_view=1

EOF

# ZCube1 Max no have WiFi
if [ "${BOARD}" = "zcube1-max" ]; then
    systemctl disable wpa_supplicant.service
fi
