#!/bin/bash
#
# wifiFlashHelper.sh
#  -Adjust the WIFI_IP value below to the device's IP.
# nubecoder 2012 - http://www.nubecoder.com/
#

#source includes
source "$PWD/../../include/includes"

#defines
WIFI_IP="192.168.1.156"

#error
ERROR="no"

echo
echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
echo "Begin."
echo "*"

# kill adb, start, and connect to wireless
echo "Killing adb server."
$ADB_KILL >/dev/null
echo "Connect to $WIFI_IP."
$ADB_CONNECT $WIFI_IP >/dev/null

# check for device (taken from the OneClickRoot: http://forum.xda-developers.com/showthread.php?t=897612)
CURSTATE=$($ADB_STATE | tr -d '\r\n[:blank:]')
while [ "$CURSTATE" != device ] ; do
	CURSTATE=$($ADB_STATE | tr -d '\r\n[:blank:]')
	echo "Phone is not connected."
	CURSTATE="device"
	ERROR="yes"
done

if [ "$ERROR" != "yes" ] ;
then
	# remove previous files
	echo "Removing previous files."
	$ADB_SHELL "rm $DEVICE_TMP_PATH/zImage" >/dev/null 2>&1
	$ADB_SHELL "rm $DEVICE_TMP_PATH/redbend_ua" >/dev/null 2>&1
	$ADB_SHELL "rm $DEVICE_TMP_PATH/kernelFlash" >/dev/null 2>&1

	# push new kernel to phone
	echo "Pushing zImage, this may take a minute."
	$ADB_PUSH $ZIMAGE_SRC "$DEVICE_TMP_PATH/zImage" >/dev/null 2>&1
	# push redbend_ua to phone and set permissions
	echo "Pushing redbend_ua, this may take a minute."
	$ADB_PUSH $REDBEND_SRC "$DEVICE_TMP_PATH/redbend_ua" >/dev/null 2>&1
	echo "Setting permissions on redbend_ua (0755)."
	$ADB_SHELL "chmod 0755 $DEVICE_TMP_PATH/redbend_ua"

	# push kernelFlash to phone and set permissions
	echo "Pushing kernelFlash, this may take a minute."
	$ADB_PUSH $KERNELFLASH_SRC "$DEVICE_TMP_PATH/kernelFlash" >/dev/null 2>&1
	echo "Setting permissions on kernelFlash (0755)."
	$ADB_SHELL "chmod 0755 $DEVICE_TMP_PATH/kernelFlash"
	# flash kernel with kernelFlash script
	echo "Flashing kernel with kernelFlash -k."
	echo "*"
	$ADB_SHELL $ADB_KERNEL_FLASH

	# cleanup adb wireless by disconnecting
	echo "Disconnect from $WIFI_IP."
	$ADB_DISCONNECT $WIFI_IP
else
	echo "Please enable wireless adb and verify the WIFI_IP matches: $WIFI_IP."
fi

echo "*"
echo "End."
echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
echo

exit

