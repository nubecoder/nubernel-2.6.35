#!/system/bin/sh
#
# init_99_mount_ro.sh
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

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

SEND_LOG "Remount ro"
busybox mount -o remount,ro /
busybox mount -o remount,ro /system

SEND_LOG "End"

