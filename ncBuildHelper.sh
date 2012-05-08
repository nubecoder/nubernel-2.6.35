#!/bin/bash
#
# ncBuildHelper.sh
# nubecoder 2012 - http://www.nubecoder.com/
#

#source includes
source "$PWD/include/includes"

#defaults
BUILD_TYPE="tw"
RECOVERY_TYPE="cwm"
TARGET="victory_nubernel"
CLEAN=n
DISTCLEAN=n
BUILD_MODULES=n
BUILD_KERNEL=n
CREATE_PACKAGES=n
WIFI_FLASH=n
WIRED_FLASH=n
USE_KEXEC=n
VERBOSE=n

#exports
export KBUILD_BUILD_VERSION

#functions
function SHOW_HELP()
{
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "Usage options for $0:"
	echo "-b : Build zImage."
	echo "-c : Run 'make clean'."
	echo "-d : Run 'make distclean'."
	echo "-h : Print this help info."
	echo "-m : Build and install modules."
	echo "-p : Create install packages."
	echo "-r : Define the recovery type."
	echo "     Recovery types are: <cwm|twrp>. (Defaults to cwm.)"
	echo "-t : Define the build type."
	echo "     Build types are: <tw|mtd|cm7|mod|bml8>. (Defaults to tw.)"
	echo "-u : Wired (USB) Flash, expects a device to be connected."
	echo "-v : Verbose script output."
	echo "-w : Wifi Flash, for use with adb wireless."
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	exit 1
}
function SHOW_SETTINGS()
{
	TIME_START=$(date +%s)
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "build type      == $BUILD_TYPE"
	echo "recovery type   == $RECOVERY_TYPE"
	echo "build version   == $KBUILD_BUILD_VERSION"
	echo "build target    == $TARGET"
	echo "cross compile   == $CROSS_COMPILE"
	echo "outfile         == $VERSION.$BUILD_TYPE.*"
	echo "modules path    == $INSTALL_MOD_PATH"
	echo "make threads    == $THREADS"
	echo "make clean      == $CLEAN"
	echo "make distclean  == $DISTCLEAN"
	echo "build modules   == $BUILD_MODULES"
	echo "build kernel    == $BUILD_KERNEL"
	echo "create packages == $CREATE_PACKAGES"
	echo "wifi flash      == $WIFI_FLASH"
	echo "wired flash     == $WIRED_FLASH"
	echo "verbose output  == $VERBOSE"
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "*"
}

#main
while getopts ":bcdhkmpr:t:uvw" flag
do
	case "$flag" in
		b)
			BUILD_KERNEL=y ;;
		c)
			CLEAN=y ;;
		d)
			DISTCLEAN=y ;;
		h)
			SHOW_HELP ;;
		k)
			USE_KEXEC=y ;;
		m)
			BUILD_MODULES=y ;;
		p)
			CREATE_PACKAGES=y ;;
		r)
			case "$OPTARG" in
				cwm)
					RECOVERY_TYPE="$OPTARG" ;;
				twrp)
					RECOVERY_TYPE="$OPTARG" ;;
				*)
					ERROR_MSG="Error:: problem with option '$OPTARG'"
					SHOW_ERROR
					SHOW_HELP ;;
			esac ;;
		t)
			case "$OPTARG" in
				tw)
					BUILD_TYPE="$OPTARG"
					TARGET=$TARGET_TW ;;
				mtd)
					BUILD_TYPE="$OPTARG"
					TARGET=$TARGET_MTD ;;
				cm7)
					BUILD_TYPE="$OPTARG"
					TARGET=$TARGET_CM7 ;;
				mod)
					BUILD_TYPE="$OPTARG"
					TARGET=$TARGET_MOD
					BUILD_MODULES=y ;;
				bml8)
					BUILD_TYPE="$OPTARG"
					TARGET=$TARGET_BML8 ;;
				*)
					ERROR_MSG="Error:: problem with option '$OPTARG'"
					SHOW_ERROR
					SHOW_HELP ;;
			esac ;;
		u)
			WIRED_FLASH=y ;;
		v)
			VERBOSE=y ;;
		w)
			WIFI_FLASH=y ;;
		*)
			ERROR_MSG="Error:: problem with option '$OPTARG'"
			SHOW_ERROR
			SHOW_HELP ;;
		esac
done

SHOW_SETTINGS

if [ "$CLEAN" = "y" ] ; then
	MAKE_CLEAN
fi
if [ "$DISTCLEAN" = "y" ] ; then
	MAKE_DISTCLEAN
fi

MAKE_DEFCONFIG

if [ "$BUILD_MODULES" = "y" ] ; then
	BUILD_MODULES
	INSTALL_MODULES
fi
if [ "$BUILD_KERNEL" = "y" ] ; then
	BUILD_ZIMAGE
	GENERATE_WARNINGS_FILE
fi
if [ "$CREATE_PACKAGES" = y ] ; then
	if [ "$BUILD_TYPE" != "mod" ] || [ "$BUILD_TYPE" != "bml8" ] ; then
		CREATE_INSTALL_PACKAGE
	fi
fi

if [ "$WIFI_FLASH" = y ] ; then
	if [ "$BUILD_TYPE" != "tw" ] ; then
		ERROR_MSG="Error:: Wifi flash is currently unsupported for: $BUILD_TYPE"
		SHOW_ERROR
		SHOW_HELP
	else
		if [ "$USE_KEXEC" = y ] ; then
			WIFI_KERNEL_LOAD_SCRIPT
		else
			WIFI_FLASH_SCRIPT
		fi
	fi
fi
if [ "$WIRED_FLASH" = y ] ; then
	if [ "$BUILD_TYPE" != "tw" ] ; then
		ERROR_MSG="Error:: Wired flash is currently unsupported for: $BUILD_TYPE"
		SHOW_ERROR
		SHOW_HELP
	else
		if [ "$USE_KEXEC" = y ] ; then
			WIRED_KERNEL_LOAD_SCRIPT
		else
			WIRED_FLASH_SCRIPT
		fi
	fi
fi

SHOW_COMPLETED

