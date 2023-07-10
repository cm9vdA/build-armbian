#!/bin/bash

set -e
WORKSPACE=$(dirname $(readlink -f $0))

BOARD_LIST=(all tn3399-v3 zcube1-max dg3399 eaidk-610)

# default value
BOARD=$1
BRANCH=current
RELEASE=bookworm
BUILD_MINIMAL=no
BUILD_DESKTOP=no
KERNEL_CONFIGURE=no
COMPRESS_OUTPUTIMAGE=sha,xz
BOOT_LOGO=no
# GIT_BRANCH=$(git branch --show-current)

git switch main

build_image() {
    local exists=0
    local i
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
    if [ "${BOARD}" == "all" ]; then
        for ((i = 1; i < ${#BOARD_LIST[@]}; i++)); do
            ./compile.sh BOARD=${BOARD_LIST[i]} \
                BRANCH=${BRANCH} \
                RELEASE=${RELEASE} \
                BUILD_MINIMAL=${BUILD_MINIMAL} \
                BUILD_DESKTOP=${BUILD_DESKTOP} \
                KERNEL_CONFIGURE=${KERNEL_CONFIGURE} \
                COMPRESS_OUTPUTIMAGE=${COMPRESS_OUTPUTIMAGE} \
                BOOT_LOGO=${BOOT_LOGO}
            if [ $? -ne 0 ]; then
                exit 1
            fi
        done
    else
        ./compile.sh BOARD=${BOARD} \
            BRANCH=${BRANCH} \
            RELEASE=${RELEASE} \
            BUILD_MINIMAL=${BUILD_MINIMAL} \
            BUILD_DESKTOP=${BUILD_DESKTOP} \
            KERNEL_CONFIGURE=${KERNEL_CONFIGURE} \
            COMPRESS_OUTPUTIMAGE=${COMPRESS_OUTPUTIMAGE} \
            BOOT_LOGO=${BOOT_LOGO}
    fi
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
