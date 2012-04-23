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
KBUILD_BUILD_VERSION="nubernel-2.6.35_v0.0.2"
LOCALVERSION=".nubernel_v0.0.2"
INSTALL_MOD_PATH="../stand-alone\ modules"
CROSS_COMPILE="/home/nubecoder/android/toolchains/arm-eabi-4.4.3/bin/arm-eabi-"

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
USE_KEXEC=n
USE_MTD=n

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
while getopts ":bcCd:hj:km:Mtuvwz" flag
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
	k)
		USE_KEXEC=y
		;;
	m)
		BUILD_MODULES=y
		MODULE_ARGS="$OPTARG"
		;;
	M)
		USE_MTD=y
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
if [ "$DEFCONFIG" = "y" ] || [ ! -f "Kernel/.config" ] ; then
	MAKE_DEFCONFIG
fi
if [ "$BUILD_MODULES" = "y" ] ; then
	BUILD_MODULES
	if [ "$MODULE_ARGS" != "${MODULE_ARGS/c/}" ] ; then
		INSTALL_MODULES
		COPY_ARG="nubernel"
		if [ $TARGET = "victory_nubernel" ]; then
			COPY_ARG="nubernel"
		elif [ $TARGET = "victory_modules" ]; then
			COPY_ARG="stand-alone"
		elif [ $TARGET = "cyanogenmod_epic" ]; then
			COPY_ARG="cyanogenmod"
		fi
		COPY_MODULES $COPY_ARG
	fi
	if [ "$MODULE_ARGS" != "${MODULE_ARGS/s/}" ] ; then
		STRIP_ARG="nubernel"
		if [ $TARGET = "victory_nubernel" ]; then
			STRIP_ARG="nubernel"
		elif [ $TARGET = "victory_modules" ]; then
			STRIP_ARG="stand-alone"
		elif [ $TARGET = "cyanogenmod_epic" ]; then
			STRIP_ARG="cyanogenmod"
		fi
		STRIP_MODULES $STRIP_ARG
	fi
fi
if [ "$BUILD_KERNEL" = "y" ] ; then
	ZIMAGE_ARG="$LOCALVERSION"
	if [ $TARGET = "cyanogenmod_epic" ]; then
		ZIMAGE_ARG="$LOCALVERSION.cm7"
	else
		ZIMAGE_ARG="$LOCALVERSION"
	fi
	BUILD_ZIMAGE $ZIMAGE_ARG
	GENERATE_WARNINGS_FILE
	ZIMAGE_UPDATE
fi
if [ "$USE_MTD" = y ] ; then
	# CyanogenMod,   Touchwiz,     Recovery
	# initramfs_cm7, initramfs_tw, initramfs_cwm
	#
	# default to initramfs_tw
	KERNEL_INITRD="$PWD/initramfs_tw"
	RECOVERY_INITRD="$PWD/initramfs_cwm"
	if [ $TARGET = "victory_nubernel" ]; then
		KERNEL_INITRD="$PWD/initramfs_tw"
	elif [ $TARGET = "cyanogenmod_epic" ]; then
		KERNEL_INITRD="$PWD/initramfs_cm7"
	fi
	PACKAGE_BOOTIMG "$KERNEL_INITRD" "$RECOVERY_INITRD"
	if [ $? != 0 ] ; then
		SHOW_ERROR
		SHOW_COMPLETED
	fi
fi
if [ "$PRODUCE_TAR" = y ] ; then
	CREATE_TAR
fi
if [ "$PRODUCE_ZIP" = y ] ; then
	CREATE_ZIP
fi
if [ "$WIFI_FLASH" = y ] ; then
	if [ "$USE_KEXEC" = y ] ; then
		WIFI_KERNEL_LOAD_SCRIPT
	else
		WIFI_FLASH_SCRIPT
	fi
fi
if [ "$WIRED_FLASH" = y ] ; then
	if [ "$USE_KEXEC" = y ] ; then
		WIRED_KERNEL_LOAD_SCRIPT
	else
		WIRED_FLASH_SCRIPT
	fi
fi

# fix for module changing every build.
if [ "$DEFCONFIG" != "victory_modules" ] && [ "$BUILD_MODULES" = "y" ]; then
	git co -- initramfs_tw/lib/modules/dhd.ko
	git co -- initramfs_cm7/lib/modules/dhd.ko
fi

# show completed message
SHOW_COMPLETED

