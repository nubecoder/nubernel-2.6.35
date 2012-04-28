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
SEND_LOG "  chmod 0755 /sbin/*"
busybox chmod 0755 /sbin/*
SEND_LOG "  chmod 0755 /vendor/bin/*"
busybox chmod 0755 /vendor/bin/*
for FILE in default.prop init ; do
	SEND_LOG "  chown 0.2000 /$FILE"
	busybox chown 0.2000 /$FILE
done
for FOLDER in lib lib/modules sbin ; do
	SEND_LOG "  chown 0.2000 /$FOLDER"
	busybox chown 0.2000 /$FOLDER
	SEND_LOG "  chown 0.2000 /$FOLDER/*"
	busybox chown 0.2000 /$FOLDER/*
done
SEND_LOG "  chown 0.0 /sbin/kexec"
busybox chown 0.0 /sbin/kexec
SEND_LOG "  chmod 6755 /sbin/kexec"
busybox chmod 6755 /sbin/kexec

SEND_LOG "Sync filesystem"
busybox sync

SEND_LOG "End"

