#!/bin/bash
#
# wifiKernelLoader.sh
# For use with adb wireless.
#
#	Usage:
#		Change the WIFI_IP variable below to match the WIFI_IP given in adb wireless.
#		Run the script.
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

# source includes
source "$PWD/../includes"

# defines
WIFI_IP="192.168.1.156"

# error
ERROR="no"

echo
echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
echo "Begin."
echo "*"

#kill adb, start, and connect to wireless
echo "Killing adb server."
$ADB_KILL >/dev/null
echo "Connect to $WIFI_IP."
$ADB_CONNECT $WIFI_IP >/dev/null

# check for device (taken from the OneClickRoot: http://forum.xda-developers.com/showthread.php?t=897612)
CURSTATE=$($ADB_STATE | tr -d '\r\n[:blank:]')
while [ "$CURSTATE" != device ]; do
	CURSTATE=$($ADB_STATE | tr -d '\r\n[:blank:]')
	echo "Phone is not connected."
	CURSTATE="device"
	ERROR="yes"
done

if [ "$ERROR" != "yes" ]; then
	#remove previous files
	echo "Removing previous files."
	$ADB_SHELL "rm " $ZIMAGE_DEST >/dev/null 2>&1
	$ADB_SHELL "rm " $KERNELLOAD_DEST >/dev/null 2>&1

	#push new kernel to phone
	echo "Pushing zImage, this may take a minute."
	$ADB_PUSH $ZIMAGE_SRC $ZIMAGE_DEST >/dev/null 2>&1

	#push kernelLoad to phone and set permissions
	echo "Pushing kernelLoad, this may take a minute."
	$ADB_PUSH $KERNELLOAD_SRC $KERNELLOAD_DEST >/dev/null 2>&1
	echo "Setting permissions on kernelLoad (0755)."
	$ADB_SHELL "chmod 0755" $KERNELLOAD_DEST
	#load kernel with kernelLoad script
	echo "Loading kernel with kernelLoad."
	echo "*"
	$ADB_SHELL $ADB_KERNEL_LOAD

	#cleanup adb wireless by disconnecting
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

