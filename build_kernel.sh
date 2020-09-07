#!/bin/bash

export ARCH=arm64
export CROSS_COMPILE=~/Android/Toolchains/linaro-7.5.0-aarch64-linux/bin/aarch64-linux-gnu-
export ANDROID_MAJOR_VERSION=q
export ANDROID_PLATFORM_VERSION=10

make O=./out exynos7870-on7xelte_defconfig
make O=./out -j64
