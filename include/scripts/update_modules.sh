#!/bin/bash
#
# update_modules.sh
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

# source includes
source "$PWD/../includes"

# define defaults
STAND_ALONE="n"
BUILD_CM="n"

#functions
SHOW_HELP()
{
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "Usage options for $0:"
	echo "cp | copy : Copy modules to initramfs."
	echo "st | strip : Strip modules in initramfs."
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	exit 1
}
COPY_WITH_ECHO()
{
	local SRC=$1
	local MOD_PATH="$INSTALL_MOD_PATH/$VERSION_PATH"
	if [ "$STAND_ALONE" = "y" ]; then
		echo "Copying $SRC to $INSTALL_MOD_PATH/"
		cp "$MOD_PATH/$SRC" "$INSTALL_MOD_PATH/"
	elif [ "$BUILD_CM" = "y" ]; then
		echo "Copying $SRC to $INITRAMFS_CM_PATH/"
		cp "$MOD_PATH/$SRC" "$INITRAMFS_CM_PATH/"
	else
		echo "Copying $SRC to $INITRAMFS_TW_PATH/"
		cp "$MOD_PATH/$SRC" "$INITRAMFS_TW_PATH/"
	fi
}
STRIP_WITH_ECHO()
{
	local DST=$1
	if [ "$STAND_ALONE" = "y" ]; then
		echo "Stripping $INSTALL_MOD_PATH/$DST"
		$CC_STRIP "$INSTALL_MOD_PATH/$DST"
	elif [ "$BUILD_CM" = "y" ]; then
		echo "Stripping $INITRAMFS_CM_PATH/$DST"
		$CC_STRIP "$INITRAMFS_CM_PATH/$DST"
	else
		echo "Stripping $INITRAMFS_TW_PATH/$DST"
		$CC_STRIP "$INITRAMFS_TW_PATH/$DST"
	fi
}
COPY_MODULES()
{
	if [ "$STAND_ALONE" = "y" ]; then
		local PARTS="kernel/drivers/net/tun.ko"
		local PARTS="$PARTS kernel/fs/cifs/cifs.ko"
		local PARTS="$PARTS kernel/fs/fuse/fuse.ko"
		local PARTS="$PARTS kernel/kernel/slow-work.ko"
		local PARTS="$PARTS kernel/net/netfilter/xt_TCPMSS.ko"
		local PARTS="$PARTS kernel/net/netfilter/xt_tcpmss.ko"
		for PART in $PARTS; do
			COPY_WITH_ECHO "$PART"
		done
	else
		local PARTS="kernel/drivers/misc/vibetonz/vibrator.ko"
		local PARTS="$PARTS kernel/drivers/net/wireless/wimax/cmc7xx_sdio.ko"
		if [ "$BUILD_CM" != "y" ]; then
			local PARTS="$PARTS kernel/drivers/net/wireless/bcm4329/victory/dhd.ko"
			local PARTS="$PARTS kernel/drivers/staging/android/logger.ko"
		else
			local PARTS="$PARTS kernel/drivers/net/wireless/bcm4329/bcm4329.ko"
		fi
		for PART in $PARTS; do
			COPY_WITH_ECHO "$PART"
		done
	fi
}
STRIP_MODULES()
{
	if [ "$STAND_ALONE" = "y" ]; then
		local PARTS="tun.ko"
		local PARTS="$PARTS cifs.ko"
		local PARTS="$PARTS fuse.ko"
		local PARTS="$PARTS slow-work.ko"
		local PARTS="$PARTS xt_TCPMSS.ko"
		local PARTS="$PARTS xt_tcpmss.ko"
		for PART in $PARTS; do
			STRIP_WITH_ECHO "$PART"
		done
	else
		local PARTS="vibrator.ko"
		local PARTS="$PARTS cmc7xx_sdio.ko"
		if [ "$BUILD_CM" != "y" ]; then
			local PARTS="$PARTS dhd.ko"
			local PARTS="$PARTS logger.ko"
		else
			local PARTS="$PARTS bcm4329.ko"
		fi
		for PART in $PARTS; do
			STRIP_WITH_ECHO "$PART"
		done
	fi
}

#main
if [ "$2" == "sa" ] || [ "$2" == "stand-alone" ]; then
	STAND_ALONE="y"
elif [ "$2" == "cm" ] || [ "$2" == "cyanogenmod" ]; then
	BUILD_CM="y"
fi

if [ "$1" == "cp" ] || [ "$1" == "copy" ]; then
	pushd $KERNEL_BASE > /dev/null
		COPY_MODULES
	popd > /dev/null
	exit 0
fi

if [ "$1" == "st" ] || [ "$1" == "strip" ]; then
	pushd $KERNEL_BASE > /dev/null
		STRIP_MODULES
	popd > /dev/null
	exit 0
fi

SHOW_HELP

