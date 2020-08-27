#!/bin/bash

export ARCH=arm64
export CROSS_COMPILE=/target/gcc-linaro-7.5.0/bin/aarch64-linux-gnu-
export ANDROID_MAJOR_VERSION=q
export ANDROID_PLATFORM_VERSION=10
export CCACHE_DIR=/target/.ccache

read -p "Clean source (y/n) > " yn
if [ "$yn" = "Y" -o "$yn" = "y" ]; then
     echo "Clean Build"
     CLEAN="1"
else
     echo "Dirty Build"
     CLEAN="0"
fi

for device in $*; do
  case $device in
    A320X) DVNAME=exynos7870-a3y17lte_defconfig
	   ;;
    A600X) DVNAME=exynos7870-a6lte_defconfig
  	   ;;
    J530X) DVNAME=exynos7870-j5y17lte_defconfig
	   ;;
    J600X) DVNAME=exynos7870-j6lte_defconfig
	   ;;
    J701X) DVNAME=exynos7870-j7velte_defconfig
	   ;;
    J710X) DVNAME=exynos7870-j7xelte_defconfig
	   ;;
    J730X) DVNAME=exynos7870-j7y17lte_defconfig
	   ;;
    G610X) DVNAME=exynos7870-on7xelte_defconfig
	   ;;
  esac
  echo Building kernel for $device...
  if [ $CLEAN = 1 ] ; then
	echo Cleaning build dir
  	make clean && make mrproper ;
  	rm -rf ./Yumi/Out ;
  fi
  make O=./Yumi/Out $DVNAME ;
  make O=./Yumi/Out -j$(nproc --all) ;
  ./Yumi/AIK/cleanup.sh
  sudo cp -r ./Yumi/Q/ramdisk ./Yumi/AIK/ramdisk ;
  cp -r ./Yumi/Q/split_img ./Yumi/AIK/split_img ;
  mv ./Yumi/Out/arch/arm64/boot/Image ./Yumi/AIK/split_img/boot.img-zImage ;
  mv ./Yumi/Out/arch/arm64/boot/dtb.img ./Yumi/AIK/split_img/boot.img-dt ;
  sudo ./Yumi/AIK/repackimg.sh ;
  mkdir ./Yumi/Product
  mv ./Yumi/AIK/image-new.img ./Yumi/Product/YumiKernel-V1.0-$device-$(date +'%Y%m%d').img ;
  ./Yumi/AIK/cleanup.sh ;
  echo Kernel build complete for $device
done
