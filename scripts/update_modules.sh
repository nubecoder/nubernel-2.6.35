#!/bin/bash
#
# update_modules.sh
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#


#define base paths
INITRAMFS_PATH="initramfs_eh17/lib/modules"
STAND_ALONE_PATH="stand-alone modules"
CC_STRIP="/home/nubecoder/android/kernel_dev/toolchains/arm-2011.03-41/bin/arm-none-linux-gnueabi-strip -d --strip-unneeded"

#defines
STAND_ALONE="n"

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
	if [ $STAND_ALONE = "y" ]; then
		local MOD_PATH="stand-alone modules/lib/modules/2.6.35.7-stand-alone+"
		echo "Copying $SRC to $STAND_ALONE_PATH/"
		cp "$MOD_PATH/$SRC" "$STAND_ALONE_PATH/"
	else
		local MOD_PATH="stand-alone modules/lib/modules/2.6.35.7-nubernel+"
		echo "Copying $SRC to $INITRAMFS_PATH/"
		cp "$MOD_PATH/$SRC" "$INITRAMFS_PATH/"
	fi
}
STRIP_WITH_ECHO()
{
	local DST=$1
	if [ $STAND_ALONE = "y" ]; then
		echo "Stripping $STAND_ALONE_PATH/$DST"
		$CC_STRIP "$STAND_ALONE_PATH/$DST"
	else
		echo "Stripping $INITRAMFS_PATH/$DST"
		$CC_STRIP "$INITRAMFS_PATH/$DST"
	fi
}
COPY_MODULES()
{
	if [ $STAND_ALONE = "y" ]; then
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
		local PARTS="kernel/crypto/ansi_cprng.ko"
		local PARTS="$PARTS kernel/drivers/misc/vibetonz/vibrator.ko"
		local PARTS="$PARTS kernel/drivers/net/wireless/bcm4329/victory/src/wl/sys/hotspot_event_monitoring.ko"
		local PARTS="$PARTS kernel/drivers/net/wireless/bcm4329/victory/dhd.ko"
		local PARTS="$PARTS kernel/drivers/net/wireless/wimax/cmc7xx_sdio.ko"
		local PARTS="$PARTS kernel/drivers/net/wireless/wimaxgpio/wimax_gpio.ko"
		local PARTS="$PARTS kernel/drivers/onedram/dpram/dpram.ko"
		local PARTS="$PARTS kernel/drivers/onedram/dpram_recovery/dpram_recovery.ko"
		local PARTS="$PARTS kernel/drivers/scsi/scsi_wait_scan.ko"
		local PARTS="$PARTS kernel/drivers/staging/android/logger.ko"
		#local PARTS="$PARTS kernel/drivers/bluetooth/bthid/bthid.ko"
		#local PARTS="$PARTS kernel/drivers/onedram_svn/victory/modemctl/modemctl.ko"
		#local PARTS="$PARTS kernel/drivers/onedram_svn/victory/onedram/onedram.ko"
		#local PARTS="$PARTS kernel/drivers/onedram_svn/victory/svnet/svnet.ko"
		#local PARTS="$PARTS kernel/drivers/samsung/fm_si4709/Si4709_driver.ko"
		for PART in $PARTS; do
			COPY_WITH_ECHO "$PART"
		done
	fi
}
STRIP_MODULES()
{
	if [ $STAND_ALONE = "y" ]; then
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
		local PARTS="ansi_cprng.ko"
		local PARTS="$PARTS vibrator.ko"
		local PARTS="$PARTS hotspot_event_monitoring.ko"
		local PARTS="$PARTS dhd.ko"
		local PARTS="$PARTS cmc7xx_sdio.ko"
		local PARTS="$PARTS wimax_gpio.ko"
		local PARTS="$PARTS dpram.ko"
		local PARTS="$PARTS dpram_recovery.ko"
		local PARTS="$PARTS scsi_wait_scan.ko"
		local PARTS="$PARTS logger.ko"
		#local PARTS="$PARTS bthid.ko"
		#local PARTS="$PARTS modemctl.ko"
		#local PARTS="$PARTS onedram.ko"
		#local PARTS="$PARTS svnet.ko"
		#local PARTS="$PARTS Si4709_driver.ko"
		for PART in $PARTS; do
			STRIP_WITH_ECHO "$PART"
		done
	fi
}

#main
if [ "$2" == "sa" ] || [ "$2" == "stand-alone" ] ; then
	STAND_ALONE="y"
fi

if [ "$1" == "cp" ] || [ "$1" == "copy" ] ; then
	pushd .. > /dev/null
		COPY_MODULES
	popd > /dev/null
	exit 0
fi

if [ "$1" == "st" ] || [ "$1" == "strip" ] ; then
	pushd .. > /dev/null
		STRIP_MODULES
	popd > /dev/null
	exit 0
fi

SHOW_HELP

