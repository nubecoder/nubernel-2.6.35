#!/system/bin/sh
#
# init_01_busybox.sh
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "init_01_busybox : $1"
}

#main
SEND_LOG "Start"

if /sbin/busybox test "$1" = "recovery"; then
	SEND_LOG "Installing busybox to /sbin"
	/sbin/busybox --install -s /sbin

	SEND_LOG "Sync filesystem"
	sync
else
	SEND_LOG "Setting BB_PATH"
	BB_PATH=/data/local/tmp

	SEND_LOG "Ensuring there is room for busybox and root"
	ITEMS="amazonmp3.apk"
	ITEMS="$ITEMS BooksPhone.apk"
	ITEMS="$ITEMS FBAndroid-1.5.4.apk"
	ITEMS="$ITEMS Gmail.apk"
	ITEMS="$ITEMS install_flash_player.apk"
	ITEMS="$ITEMS Maps.apk"
	ITEMS="$ITEMS MediaHubV126.apk"
	ITEMS="$ITEMS qik-8.66-release-ffc.apk"
	ITEMS="$ITEMS Street.apk"
	ITEMS="$ITEMS Talk.apk"
	ITEMS="$ITEMS Term1.apk"
	ITEMS="$ITEMS Term1.odex"
	ITEMS="$ITEMS Term2.apk"
	ITEMS="$ITEMS Term2.odex"
	ITEMS="$ITEMS Term3.apk"
	ITEMS="$ITEMS Term3.odex"
	ITEMS="$ITEMS Term4.apk"
	ITEMS="$ITEMS Term4.odex"
	ITEMS="$ITEMS Term5.apk"
	ITEMS="$ITEMS Term5.odex"
	ITEMS="$ITEMS YouTube.apk"
	SEND_LOG "  Removing market downloadable apps from /system/app"
	for ITEM in $ITEMS; do
		if /sbin/busybox test -f "/system/app/$ITEM"; then
			SEND_LOG "  rm -f /system/app/$ITEM"
			/sbin/busybox rm -f /system/app/$ITEM
		fi
	done

	SEND_LOG "Installing temporary busybox"
	/sbin/busybox ln -s /sbin/recovery $BB_PATH/busybox
	$BB_PATH/busybox --install -s $BB_PATH/

	SEND_LOG "Ensuring busybox is properly installed"
	if $BB_PATH/test ! -f "/system/xbin/busybox"; then
		SEND_LOG "  Creating /system/xbin/busybox symlink"
		$BB_PATH/ln -s /sbin/recovery /system/xbin/busybox
	else
		BB_LINK_FOUND=$($BB_PATH/ls -l "/system/xbin/busybox" | $BB_PATH/grep "/sbin/busybox")
		if $BB_PATH/test ! "$BB_LINK_FOUND" = ""; then
			SEND_LOG "  Removing /system/xbin/busybox symlink"
			$BB_PATH/rm -f /system/xbin/busybox
			SEND_LOG "  Creating /system/xbin/busybox symlink"
			$BB_PATH/ln -s /sbin/recovery /system/xbin/busybox
		fi
	fi

	SEND_LOG "Removing /sbin/busybox"
	$BB_PATH/rm -f /sbin/busybox

	SEND_LOG "Installing /system/xbin/busybox"
	/system/xbin/busybox --install -s /system/xbin/

	SEND_LOG "Removing temporary busybox"
	/system/xbin/busybox rm -f /data/local/tmp/*

	SEND_LOG "Sync filesystem"
	/system/xbin/busybox sync

	SEND_LOG "Ensuring busybox DNS is set up properly"
	if [ ! -f "/system/etc/resolv.conf" ]; then
		SEND_LOG "  Setting Busybox DNS"
		echo "nameserver 8.8.8.8" >> /system/etc/resolv.conf
		echo "nameserver 8.8.4.4" >> /system/etc/resolv.conf
	fi
fi

SEND_LOG "End"

