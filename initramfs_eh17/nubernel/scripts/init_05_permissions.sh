#!/system/bin/sh
#
# init_05_permissions
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "init_05_permissions : $1"
}

#main
SEND_LOG "Start"
if [ "$1" = "recovery" ]; then
	SEND_LOG "Fixing permissions and ownership"
	SEND_LOG "chmod 0755 /sbin/*"
	busybox chmod 0755 /sbin/*
	for FILE in default.prop init init.sh init.smdkc110.rc ; do
		SEND_LOG "  chown root.system /$FILE"
		busybox chown root.system /$FILE
	done
	for FOLDER in conf lib lib/modules res res/images sbin ; do
		SEND_LOG "  chown root.system /$FOLDER"
		busybox chown root.system /$FOLDER
		SEND_LOG "  chown root.system /$FOLDER/*"
		busybox chown root.system /$FOLDER/*
	done
	SEND_LOG "chown root.root /sbin/kexec"
	busybox chown root.root /sbin/kexec
	SEND_LOG "chmod 6755 /sbin/kexec"
	busybox chmod 6755 /sbin/kexec
else
	SEND_LOG "Fixing permissions and ownership"
	SEND_LOG "chmod 0755 /sbin/*"
	busybox chmod 0755 /sbin/*
	SEND_LOG "chmod 0755 /vendor/bin/*"
	busybox chmod 0755 /vendor/bin/*
	for FILE in default.prop init init.sh ; do
		SEND_LOG "  chown root.system /$FILE"
		busybox chown root.system /$FILE
	done
	for FOLDER in lib lib/modules sbin ; do
		SEND_LOG "  chown root.system /$FOLDER"
		busybox chown root.system /$FOLDER
		SEND_LOG "  chown root.system /$FOLDER/*"
		busybox chown root.system /$FOLDER/*
	done
	SEND_LOG "chown root.root /sbin/kexec"
	busybox chown root.root /sbin/kexec
	SEND_LOG "chmod 6755 /sbin/kexec"
	busybox chmod 6755 /sbin/kexec
fi

SEND_LOG "Sync filesystem"
busybox sync

SEND_LOG "End"
