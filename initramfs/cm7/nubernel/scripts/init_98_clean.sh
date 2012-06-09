#!/system/bin/sh
#
# init_98_clean.sh
# nubecoder 2012 - http://www.nubecoder.com/
#

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "init_98_clean : $1"
}

#main
SEND_LOG "Start"

SEND_LOG "Moving mount_ro.sh to /data/local/tmp/"
	if [ ! -d "/data/local/tmp" ] ; then
		busybox mkdir -p "/data/local/tmp"
	fi
busybox mv -f "/nubernel/scripts/mount_ro.sh" "/data/local/tmp/"

SEND_LOG "Sync filesystem"
busybox sync

SEND_LOG "End"

