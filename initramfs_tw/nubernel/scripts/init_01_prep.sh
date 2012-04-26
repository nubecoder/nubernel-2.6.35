#!/system/bin/sh
#
# init_01_prep.sh
# nubecoder 2012 - http://www.nubecoder.com/
#

#defines
FIRST_BOOT_FILE="/data/local/.first_boot"
RM_LIST_FILE="/data/local/.rm_file_list"

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "init_01_prep : $1"
}
REMOVE_FILE()
{
	local FILE="$1"
	SEND_LOG "  test -f $FILE"
	if /sbin/busybox test -f "$FILE" ; then
		SEND_LOG "  rm -f $FILE"
		/sbin/busybox rm -f "$FILE"
	fi
}

#main
SEND_LOG "Start"

SEND_LOG "Checking for $FIRST_BOOT_FILE"
if /sbin/busybox test -f "$FIRST_BOOT_FILE" ; then
	SEND_LOG "  Found: $FIRST_BOOT_FILE"
	SEND_LOG "    Skipping removal of files listed in: $RM_LIST_FILE"
else
	SEND_LOG "Ensuring there is room for busybox and root"
	SEND_LOG "  Looking for $RM_LIST_FILE"
	if /sbin/busybox test -f "$RM_LIST_FILE" ; then
		SEND_LOG "    Using: $RM_LIST_FILE"
	else
		echo "/system/etc/PowerOn.snd" >"$RM_LIST_FILE"
		echo "/system/etc/PowerOn.wav" >>"$RM_LIST_FILE"
		echo "/system/media/bootani.qmg" >>"$RM_LIST_FILE"
		echo "/system/media/bootsamsungloop.qmg" >>"$RM_LIST_FILE"
		SEND_LOG "    Created: $RM_LIST_FILE"
	fi
	SEND_LOG "  Removing files listed in: $RM_LIST_FILE"
	while read LINE ; do
		REMOVE_FILE "$LINE"
	done <"$RM_LIST_FILE"
fi

SEND_LOG "Sync filesystem"
/system/xbin/busybox sync

SEND_LOG "End"

