#!/system/bin/sh
#
# mount_ro.sh
# nubecoder 2012 - http://www.nubecoder.com/
#

#defines
FIRST_BOOT_FILE="/data/local/.first_boot"

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "mount_ro : $1"
}

#main
SEND_LOG "Start"

SEND_LOG "Cleaning up init scripts before remount ro"
busybox rm -rf "/nubernel/"

SEND_LOG "Checking for $FIRST_BOOT_FILE"
if [ -f "$FIRST_BOOT_FILE" ] ; then
	SEND_LOG "  Found: $FIRST_BOOT_FILE"
	SEND_LOG "    Skipping creation of $FIRST_BOOT_FILE"
else
	echo "nubernel" >"$FIRST_BOOT_FILE"
	SEND_LOG "  Created: $FIRST_BOOT_FILE"
fi

SEND_LOG "Sync filesystem"
busybox sync

SEND_LOG "Remount ro"
busybox mount -o remount,ro /
busybox mount -o remount,ro /system

SEND_LOG "End"

