#!/bin/bash
#
# ncBuildHelper.sh
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

# source includes
source "$PWD/include/includes"

# define defaults
TARGET="victory_nubernel"
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

# exports
export KBUILD_BUILD_VERSION

# functions
function SHOW_HELP()
{
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "Usage options for $0:"
	echo "-b : Build zImage (kernel)."
	echo "-c : Run 'make clean'."
	echo "-C : Run 'make distclean'."
	echo "-d : Use specified config."
	echo "     For example, use -d myconfig to 'make myconfig_defconfig'."
	echo "-h : Print this help info."
	echo "-j : Number of threads (auto detected by default)."
	echo "     For example, use -j4 to make with 4 threads."
	echo "-m : Build, copy and / or strip modules."
	echo "     To copy use 'c', to strip use 's', for both use 'cs'."
	echo "-t : Produce tar file suitable for flashing with Odin."
	echo "-u : Wired (USB) Flash, expects a device to be connected."
	echo "-v : Show verbose output while building zImage (kernel)."
	echo "-w : Wifi Flash, for use with adb wireless."
	echo "-z : Produce zip file suitable for flashing via Recovery."
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	exit 1
}
function SHOW_SETTINGS()
{
	TIME_START=$(date +%s)
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "build version  == $KBUILD_BUILD_VERSION"
	echo "modules path   == $INSTALL_MOD_PATH"
	echo "cross compile  == $CROSS_COMPILE"
	echo "outfile path   == $PWD/$TARGET-$VERSION.*"
	echo "make clean     == $CLEAN"
	echo "make distclean == $DISTCLEAN"
	echo "use defconfig  == $DEFCONFIG"
	echo "build target   == $TARGET"
	echo "make threads   == $THREADS"
	echo "verbose output == $VERBOSE"
	echo "build modules  == $BUILD_MODULES"
	echo "build kernel   == $BUILD_KERNEL"
	echo "create tar     == $PRODUCE_TAR"
	echo "create zip     == $PRODUCE_ZIP"
	echo "wifi flash     == $WIFI_FLASH"
	echo "wired flash    == $WIRED_FLASH"
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "*"
}

# main
while getopts ":bcCd:hj:km:Mtuvwz" flag
do
	case "$flag" in
	b)
		BUILD_KERNEL=y ;;
	c)
		CLEAN=y ;;
	C)
		DISTCLEAN=y ;;
	d)
		DEFCONFIG=y
		TARGET="$OPTARG" ;;
	h)
		SHOW_HELP ;;
	j)
		THREADS=$OPTARG ;;
	k)
		USE_KEXEC=y ;;
	m)
		BUILD_MODULES=y
		MODULE_ARGS="$OPTARG" ;;
	M)
		USE_MTD=y ;;
	t)
		PRODUCE_TAR=y ;;
	u)
		WIRED_FLASH=y ;;
	v)
		VERBOSE=y ;;
	w)
		WIFI_FLASH=y ;;
	z)
		PRODUCE_ZIP=y ;;
	*)
		ERROR_MSG="Error:: problem with option '$OPTARG'"
		SHOW_ERROR
		SHOW_HELP ;;
	esac
done

# show current settings
SHOW_SETTINGS

# force MAKE_DEFCONFIG below
REMOVE_DOTCONFIG

# force new timestamp
FORCE_NEW_TIMESTAMP

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
		elif [ $TARGET = "cyanogenmod_epicmtd" ]; then
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
		elif [ $TARGET = "cyanogenmod_epicmtd" ]; then
			STRIP_ARG="cyanogenmod"
		fi
		STRIP_MODULES $STRIP_ARG
	fi
fi
if [ "$BUILD_KERNEL" = "y" ] ; then
	ZIMAGE_ARG="$LOCALVERSION"
	if [ $TARGET = "cyanogenmod_epicmtd" ]; then
		ZIMAGE_ARG="$LOCALVERSION.cm7"
	else
		ZIMAGE_ARG="$LOCALVERSION"
	fi
	BUILD_ZIMAGE $ZIMAGE_ARG
	GENERATE_WARNINGS_FILE
	ZIMAGE_UPDATE
fi
if [ "$USE_MTD" = y ] ; then
	# CyanogenMod,   Touchwiz,     Recovery,      TWRP
	# initramfs/cm7, initramfs/tw, initramfs/cwm, initramfs/twrp
	#
	# default to initramfs/tw
	KERNEL_INITRD="$PWD/initramfs/tw"
	RECOVERY_INITRD="$PWD/initramfs/cwm"
	if [ $TARGET = "victory_nubernel" ]; then
		KERNEL_INITRD="$PWD/initramfs/tw"
	elif [ $TARGET = "cyanogenmod_epicmtd" ]; then
		KERNEL_INITRD="$PWD/initramfs/cm7"
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

# show completed message
SHOW_COMPLETED

