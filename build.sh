#!/bin/bash -x

SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
SCRIPT_DIR=$(realpath "$SCRIPT_DIR")
# echo "${SCRIPT_DIR}"

echo "${SCRIPT_DIR}"
if [ -d ${SCRIPT_DIR}/output ]; then
        mkdir -p ${SCRIPT_DIR}/output
fi

export KERNEL_OUTPUT=${SCRIPT_DIR}/output
export SOURCE_DIR=${SCRIPT_DIR}/kernel/kernel-jammy-src

export UEFI_STMM_PATH="${SCRIPT_DIR}/../18F-BSP/Linux_for_Tegra/bootloader/standalonemm_optee_t234.bin"


export CROSS_COMPILE="/opt/toolchain/bin/aarch64-buildroot-linux-gnu-"
export KERNEL_HEADERS="${SCRIPT_DIR}/kernel/kernel-jammy-src"

export INSTALL_MOD_PATH="/home/om/workspace/nvidia-SDK/JP6.2/18F-BSP/Linux_for_Tegra/rootfs"
export install_dir="/home/om/workspace/nvidia-SDK/JP6.2/18F-BSP"

./generic_rt_build.sh "disable"

# build kernel and install
make -C kernel

sudo -E make install -C kernel

cp kernel/kernel-jammy-src/arch/arm64/boot/Image ${install_dir}/Linux_for_Tegra/kernel/Image

# Building the NVIDIA Out-of-Tree Modules
make modules

sudo -E make modules_install

cd ${install_dir}/Linux_for_Tegra

sudo ./tools/l4t_update_initrd.sh

cd ${SCRIPT_DIR}

# Building the DTBs
make dtbs

cp kernel-devicetree/generic-dts/dtbs/* ${install_dir}/Linux_for_Tegra/kernel/dtb/

