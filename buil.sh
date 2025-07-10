#!/bin/bash -x

SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
mkdir -p output

export KERNEL_OUTPUT=/home/om/workspace/nvidia-SDK/ITB-18D/porting/itb18d-AGX-Orin/output

export INSTALL_MOD_PATH=../Linux_for_Tegra/rootfs


export KERNEL_HEADERS=/home/om/workspace/nvidia-SDK/ITB-18D/porting/itb18d-AGX-Orin/kernel/kernel-jammy-src

# Disable the RT configuration
./generic_rt_build.sh disable

# Build the kernel and in-tree modules
export CROSS_COMPILE=/opt/toolchain/bin/aarch64-buildroot-linux-gnu-
make -C kernel
# Install the kernel and in-tree modules
#export INSTALL_MOD_PATH=../Linux_for_Tegra/rootfs
make install -C kernel
cp -f ${KERNEL_OUTPUT}/arch/arm64/boot/Image ../Linux_for_Tegra/kernel/


# Building the NVIDIA Out-of-Tree Modules
make modules
# Install Out-of-Tree Modules
make modules_install

# Update the initramfs
cd ../Linux_for_Tegra/
./tools/l4t_update_initrd.sh

# Build DTBs
cd ../itb18d-AGX-Orin
make dtbs
cp -arf kernel-devicetree/generic-dts/dtbs/* ../Linux_for_Tegra/kernel/dtb


