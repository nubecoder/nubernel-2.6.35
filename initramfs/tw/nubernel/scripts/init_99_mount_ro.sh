#!/system/bin/sh
#
# init_99_mount_ro.sh
# nubecoder 2012 - http://www.nubecoder.com/
#

#defines
FIRST_BOOT_FILE="/data/local/.first_boot"

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "init_99_mount_ro : $1"
}

#main
SEND_LOG "Start"

SEND_LOG "Cleaning up other init scripts before Remount ro"
busybox rm -f "nubernel/scripts/init_00_mount_rw.sh"
busybox rm -f "nubernel/scripts/init_01_prep.sh"
busybox rm -f "nubernel/scripts/init_02_busybox.sh"
busybox rm -f "nubernel/scripts/init_03_root.sh"
busybox rm -f "nubernel/scripts/init_04_other.sh"
busybox rm -f "nubernel/scripts/init_05_permissions.sh"
busybox rm -f "nubernel/scripts/init_98_clean.sh"

SEND_LOG "Checking for $FIRST_BOOT_FILE"
if [ -f "$FIRST_BOOT_FILE" ] ; then
	SEND_LOG "  Found: $FIRST_BOOT_FILE"
	SEND_LOG "    Skipping creation of $FIRST_BOOT_FILE"
else
	echo "nubernel" >"$FIRST_BOOT_FILE"
	SEND_LOG "  Created: $FIRST_BOOT_FILE"
fi

SEND_LOG "Sync filesystem"
/system/xbin/busybox sync

SEND_LOG "Remount ro"
busybox mount -o remount,ro /
busybox mount -o remount,ro /system

SEND_LOG "End"

