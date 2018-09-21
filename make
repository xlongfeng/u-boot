#! /bin/bash

export ARCH=arm
export CROSS_COMPILE=/home/skynet/buildroot/output/host/usr/bin/arm-linux-

cpus=`grep -c '^processor' /proc/cpuinfo`
jobs=`expr $cpus + 2`

if [ $# == 0 ]; then
	make -j $jobs
	exit
fi

function savedefconfig()
{
	make savedefconfig
	mv defconfig configs/mx6sabresd_defconfig
}

UUU=/home/skynet/build-mfgtools/uuu/uuu

function uuu()
{
	make -j $jobs
	sudo $UUU SDP: boot -f SPL
	sleep 1
	sudo $UUU SDPU: write -f u-boot.bin -addr 0x17800000
	sleep 1
	sudo $UUU SDPU: jump -addr 0x17800000
}

case $1 in
	"config") make mx6sabresd_defconfig;;
	"menuconfig") make menuconfig;;
	"savedefconfig") savedefconfig;;
	"cscope") make cscope;;
	"uuu") uuu;;
	*) echo "Unknown args $1";;
esac
