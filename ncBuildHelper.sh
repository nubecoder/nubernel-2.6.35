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
CREATE_PACKAGE=n
KEXEC_ZIMAGE=n
WIFI_KEXEC=n
INSTALL_PACKAGE=n
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
	echo "-i : Install zip via recovery."
	echo "-k : Kexec the current zImage."
	echo "     Options are: <u|usb|wifi|w> (defaults to usb)."
	echo "-m : Build and install modules."
	echo "-p : Create install packages."
	echo "-r : Define the recovery type."
	echo "     Recovery types are: <cwm|twrp> (defaults to cwm)."
	echo "-t : Define the build type."
	echo "     Build types are: <tw|mtd|cm7|dbg-bml|dbg-mtd|mod|bml8> (defaults to tw)."
	echo "-v : Verbose script output."
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
	echo "create package  == $CREATE_PACKAGE"
	echo "install package == $INSTALL_PACKAGE"
	echo "kexec zimage    == $KEXEC_ZIMAGE"
	echo "wifi kexec      == $WIFI_KEXEC"
	echo "verbose output  == $VERBOSE"
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "*"
}

#main
while getopts ":bcdhik:mpr:t:v" flag
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
		i)
			INSTALL_PACKAGE=y ;;
		k)
			KEXEC_ZIMAGE=y
			case "$OPTARG" in
				u|usb)
					WIFI_KEXEC=n ;;
				w|wifi)
					WIFI_KEXEC=y ;;
				*)
					ERROR_MSG="Error:: problem with option '$OPTARG'"
					SHOW_ERROR
					SHOW_HELP ;;
			esac ;;
		m)
			BUILD_MODULES=y ;;
		p)
			CREATE_PACKAGE=y ;;
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
				dbg-bml)
					BUILD_TYPE="$OPTARG"
					TARGET=$TARGET_DBG_BML ;;
				dbg-mtd)
					BUILD_TYPE="$OPTARG"
					TARGET=$TARGET_DBG_MTD ;;
				mod)
					BUILD_TYPE="$OPTARG"
					TARGET=$TARGET_MOD ;;
#					BUILD_MODULES=y ;;
				bml8)
					BUILD_TYPE="$OPTARG"
					TARGET=$TARGET_BML8 ;;
				*)
					ERROR_MSG="Error:: problem with option '$OPTARG'"
					SHOW_ERROR
					SHOW_HELP ;;
			esac ;;
		v)
			VERBOSE=y ;;
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
if [ "$CREATE_PACKAGE" = "y" ] ; then
	if [ "$BUILD_TYPE" != "mod" ] || [ "$BUILD_TYPE" != "bml8" ] ; then
		CREATE_INSTALL_PACKAGE
	fi
fi

if [ "$KEXEC_ZIMAGE" = "y" ] ; then
	if [ "$WIFI_KEXEC" = "y" ] ; then
		WIFI_KERNEL_LOAD_SCRIPT
	else
		WIRED_KERNEL_LOAD_SCRIPT
	fi
fi

if [ "$INSTALL_PACKAGE" = "y" ] ; then
	INSTALL_ZIP_PACKAGE
fi

SHOW_COMPLETED

