#!/bin/bash
#
# update_modules.sh
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#


#define base paths
P_DIR="$PWD/.."
SRC_BASE="$P_DIR/kernel/drivers"
DST_BASE="initramfs_eh17/lib/modules"
CC_STRIP="/home/nubecoder/android/kernel_dev/toolchains/arm-2011.03-41/bin/arm-none-linux-gnueabi-strip"

COPY_WITH_ECHO()
{
	local SRC=$1
	local DST=$2
	echo "Copying $SRC to $DST_BASE/$DST"
	cp "$SRC_BASE/$SRC" "$P_DIR/$DST_BASE/$DST" >/dev/null 2>&1
}
STRIP_WITH_ECHO()
{
	local DST=$1
	echo "Stripping $DST_BASE/$DST"
	$CC_STRIP -d --strip-unneeded "$P_DIR/$DST_BASE/$DST" >/dev/null 2>&1
}
SHOW_HELP()
{
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "Usage options for $0:"
	echo "cp | copy : Copy modules to initramfs."
	echo "st | strip : Strip modules in initramfs."
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	exit 1
}

if [ "$1" == "cp" ] || [ "$1" == "copy" ] ; then
	#copy modules
	#COPY_WITH_ECHO "bluetooth/bthid/bthid.ko" "bthid.ko"
	COPY_WITH_ECHO "net/wireless/bcm4329/victory/dhd.ko" "dhd.ko"
	COPY_WITH_ECHO "net/wireless/bcm4329/victory/src/wl/sys/hotspot_event_monitoring.ko" "hotspot_event_monitoring.ko"
	COPY_WITH_ECHO "net/wireless/wimax/cmc7xx_sdio.ko" "cmc7xx_sdio.ko"
	COPY_WITH_ECHO "net/wireless/wimaxgpio/wimax_gpio.ko" "wimax_gpio.ko"
	COPY_WITH_ECHO "onedram/dpram_recovery/dpram_recovery.ko" "dpram_recovery.ko"
	COPY_WITH_ECHO "onedram/dpram/dpram.ko" "dpram.ko"
	#COPY_WITH_ECHO "onedram_svn/victory/modemctl/modemctl.ko" "modemctl.ko"
	#COPY_WITH_ECHO "onedram_svn/victory/onedram/onedram.ko" "onedram.ko"
	#COPY_WITH_ECHO "onedram_svn/victory/svnet/svnet.ko" "svnet.ko"
	#COPY_WITH_ECHO "samsung/fm_si4709/Si4709_driver.ko" "Si4709_driver.ko"
	COPY_WITH_ECHO "misc/vibetonz/vibrator.ko" "vibrator.ko"
	COPY_WITH_ECHO "scsi/scsi_wait_scan.ko" "scsi_wait_scan.ko"
	COPY_WITH_ECHO "staging/android/logger.ko" "logger.ko"
	COPY_WITH_ECHO "net/tun.ko" "tun.ko"
	# special case below =[
	echo "Copying crypto/ansi_cprng.ko to $DST_BASE/ansi_cprng.ko"
	cp "$P_DIR/kernel/crypto/ansi_cprng.ko" "$P_DIR/$DST_BASE/ansi_cprng.ko" >/dev/null 2>&1
	echo "Copying fs/cifs/cifs.ko to $DST_BASE/cifs.ko"
	cp "$P_DIR/kernel/fs/cifs/cifs.ko" "$P_DIR/$DST_BASE/cifs.ko" >/dev/null 2>&1
	echo "Copying fs/fuse/fuse.ko to $DST_BASE/fuse.ko"
	cp "$P_DIR/kernel/fs/fuse/fuse.ko" "$P_DIR/$DST_BASE/fuse.ko" >/dev/null 2>&1
	echo "Copying kernel/slow-work.ko to $DST_BASE/slow-work.ko"
	cp "$P_DIR/kernel/kernel/slow-work.ko" "$P_DIR/$DST_BASE/slow-work.ko" >/dev/null 2>&1
	echo "Copying net/netfilter/xt_TCPMSS.ko to $DST_BASE/xt_TCPMSS.ko"
	cp "$P_DIR/kernel/net/netfilter/xt_TCPMSS.ko" "$P_DIR/$DST_BASE/xt_TCPMSS.ko" >/dev/null 2>&1
	echo "Copying net/netfilter/xt_tcpmss.ko to $DST_BASE/xt_tcpmss.ko"
	cp "$P_DIR/kernel/net/netfilter/xt_tcpmss.ko" "$P_DIR/$DST_BASE/xt_tcpmss.ko" >/dev/null 2>&1
	exit 0
fi

if [ "$1" == "st" ] || [ "$1" == "strip" ] ; then
	#strip modules
	STRIP_WITH_ECHO "ansi_cprng.ko"
	#STRIP_WITH_ECHO "bthid.ko"
	STRIP_WITH_ECHO "dhd.ko"
	STRIP_WITH_ECHO "hotspot_event_monitoring.ko"
	STRIP_WITH_ECHO "cmc7xx_sdio.ko"
	STRIP_WITH_ECHO "wimax_gpio.ko"
	STRIP_WITH_ECHO "dpram_recovery.ko"
	STRIP_WITH_ECHO "dpram.ko"
	#STRIP_WITH_ECHO "modemctl.ko"
	#STRIP_WITH_ECHO "onedram.ko"
	#STRIP_WITH_ECHO "svnet.ko"
	#STRIP_WITH_ECHO "Si4709_driver.ko"
	STRIP_WITH_ECHO "vibrator.ko"
	STRIP_WITH_ECHO "scsi_wait_scan.ko"
	STRIP_WITH_ECHO "logger.ko"
	STRIP_WITH_ECHO "tun.ko"
	STRIP_WITH_ECHO "cifs.ko"
	STRIP_WITH_ECHO "fuse.ko"
	STRIP_WITH_ECHO "slow-work.ko"
	STRIP_WITH_ECHO "xt_TCPMSS.ko"
	STRIP_WITH_ECHO "xt_tcpmss.ko"
	exit 0
fi

SHOW_HELP

