#!/bin/bash
#
# wifiKernelLoader.sh
# For use with adb wireless.
#
#	Usage:
#		Change the IP variable below to match the IP given in adb wireless.
#		Run the script.
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

#define variables
IP="192.168.1.168"

#define paths
TMP_PATH="/data/local/tmp"
ZIMAGE_SRC="$PWD/../Kernel/arch/arm/boot/zImage"
ZIMAGE_DEST="$TMP_PATH/zImage"
KERNELLOAD_SRC="$PWD/kernelLoad"
KERNELLOAD_DEST="$TMP_PATH/kernelLoad"

#define cmds
ADB_KILL="adb kill-server"
ADB_CONNECT="adb connect"
ADB_DISCONNECT="adb disconnect"
ADB_SHELL="adb shell"
ADB_PUSH="adb push"
ADB_STATE="adb get-state"
ADB_KERNEL_LOAD="su -c \"/data/local/tmp/kernelLoad $ZIMAGE_DEST\""

#error
ERROR="no"

echo
echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
echo "Begin."
echo "*"

#kill adb, start, and connect to wireless
echo "Killing adb server."
$ADB_KILL >/dev/null
echo "Connect to $IP."
$ADB_CONNECT $IP >/dev/null

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
	echo "Disconnect from $IP."
	$ADB_DISCONNECT $IP
else
	echo "Please enable wireless adb and verify the IP matches: $IP."
fi

echo "*"
echo "End."
echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
echo

exit

