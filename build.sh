#!/bin/bash

set -e
WORKSPACE=$(dirname $(readlink -f $0))

BOARD_LIST=(king3399 lx-r3s tn3399-v3 tvi3315a zcube1-max)

# default value
BOARD=$1
BRANCH=current
RELEASE=bullseye
BUILD_MINIMAL=no
BUILD_DESKTOP=no
KERNEL_ONLY=no
KERNEL_CONFIGURE=no
COMPRESS_OUTPUTIMAGE=sha,gz
BOOT_LOGO=no

build_image() {
    local exists=0
    for i in ${BOARD_LIST[@]}; do
        if [ "${i}" = "${BOARD}" ]; then
            exists=1
        fi
    done
    if [ ${exists} -eq 0 ]; then
        echo "Invalid Board ${BOARD}"
        exit 1
    fi

    cd ${WORKSPACE}
    echo ./compile.sh docker BOARD=${BOARD} \
        BRANCH=${BRANCH} \
        RELEASE=${RELEASE} \
        BUILD_MINIMAL=${BUILD_MINIMAL} \
        BUILD_DESKTOP=${BUILD_DESKTOP} \
        KERNEL_ONLY=${KERNEL_ONLY} \
        KERNEL_CONFIGURE=${KERNEL_CONFIGURE} \
        COMPRESS_OUTPUTIMAGE=${COMPRESS_OUTPUTIMAGE} \
        BOOT_LOGO=${BOOT_LOGO}
}

if [ -n "${BOARD}" ]; then
    build_image
else
    echo "Board List:"
    no=0
    for i in ${BOARD_LIST[@]}; do
        echo "[${no}]. ${i}"
        let no+=1
    done
    read -p "Select Target [1-${#BOARD_LIST[*]}]: >> " select
    if [[ "${select}" -ge 0 ]] && [[ "${select}" -lt ${#BOARD_LIST[*]} ]]; then
        BOARD=${BOARD_LIST[${select}]}
        build_image
    else
        echo "Invalid Board No."
    fi
fi
