#!/system/bin/sh
#
# init_05_permissions
# nubecoder 2012 - http://www.nubecoder.com/
#

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "init_05_permissions : $1"
}

#main
SEND_LOG "Start"

SEND_LOG "Fixing permissions and ownership"
SEND_LOG "  chmod 0755 /data/local/bin/*"
busybox chmod 0755 /data/local/bin/*

SEND_LOG "Sync filesystem"
busybox sync

SEND_LOG "End"

