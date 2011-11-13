#!/bin/bash
#
# ncBuildHelper.sh
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

# define envvars
TARGET="victory_nubernel"
KBUILD_BUILD_VERSION="nubernel-2.6.35_v0.0.1"
INSTALL_MOD_PATH="../stand-alone\ modules"
CROSS_COMPILE="/home/nubecoder/android/kernel_dev/toolchains/arm-2011.03-41/bin/arm-none-linux-gnueabi-"
LOCALVERSION=".nubernel_v0.0.1"
#sammy recommended below
#CROSS_COMPILE="/home/nubecoder/android/kernel_dev/toolchains/arm-2009q3-68/bin/arm-none-eabi-"

# define defaults
BUILD_KERNEL=n
BUILD_MODULES=n
MODULE_ARGS=
CLEAN=n
DEFCONFIG=n
DISTCLEAN=n
PRODUCE_TAR=n
PRODUCE_ZIP=n
VERBOSE=n
WIFI_FLASH=n
WIRED_FLASH=n

# define vars
MKZIP='7z -mx9 -mmt=1 a "$OUTFILE" .'
THREADS=$(expr 1 + $(grep processor /proc/cpuinfo | wc -l))
VERSION=$(date +%m-%d-%Y)
ERROR_MSG=
TIME_START=
TIME_END=

# exports
export KBUILD_BUILD_VERSION

#source functions
source $PWD/functions

# main
while getopts ":bcCd:hj:m:tuvwz" flag
do
	case "$flag" in
	b)
		BUILD_KERNEL=y
		;;
	c)
		CLEAN=y
		;;
	C)
		DISTCLEAN=y
		;;
	d)
		DEFCONFIG=y
		TARGET="$OPTARG"
		;;
	h)
		SHOW_HELP
		;;
	j)
		THREADS=$OPTARG
		;;
	m)
		BUILD_MODULES=y
		MODULE_ARGS="$OPTARG"
		;;
	t)
		PRODUCE_TAR=y
		;;
	u)
		WIRED_FLASH=y
		;;
	v)
		VERBOSE=y
		;;
	w)
		WIFI_FLASH=y
		;;
	z)
		PRODUCE_ZIP=y
		;;
	*)
		ERROR_MSG="Error:: problem with option '$OPTARG'"
		SHOW_ERROR
		SHOW_HELP
		;;
	esac
done

# show current settings
SHOW_SETTINGS

# force MAKE_DEFCONFIG below
REMOVE_DOTCONFIG

if [ "$CLEAN" = "y" ] ; then
	MAKE_CLEAN
fi
if [ "$DISTCLEAN" = "y" ] ; then
	MAKE_DISTCLEAN
fi
if [ "$DEFCONFIG" = "y" -o ! -f "Kernel/.config" ] ; then
	MAKE_DEFCONFIG
fi
if [ "$BUILD_MODULES" = "y" ] ; then
	BUILD_MODULES
	if [ "$MODULE_ARGS" != "${MODULE_ARGS/c/}" ] ; then
		INSTALL_MODULES
		COPY_MODULES
	fi
	if [ "$MODULE_ARGS" != "${MODULE_ARGS/s/}" ] ; then
		STRIP_MODULES
	fi
fi
if [ "$BUILD_KERNEL" = "y" ] ; then
	BUILD_ZIMAGE
	GENERATE_WARNINGS_FILE
fi
if [ "$PRODUCE_TAR" = y ] ; then
	CREATE_TAR
fi
if [ "$PRODUCE_ZIP" = y ] ; then
	CREATE_ZIP
fi
if [ "$WIFI_FLASH" = y ] ; then
	WIFI_FLASH_SCRIPT
fi
if [ "$WIRED_FLASH" = y ] ; then
	WIRED_FLASH_SCRIPT
fi

# fix for module changing every build.
if [ "$DEFCONFIG" != "y" ] ; then
	git co -- initramfs_tw/lib/modules/dhd.ko
fi

# show completed message
SHOW_COMPLETED

