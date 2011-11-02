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
REMOVE_SYSTEM_APP()
{
	local APK="$1"
	local DATA="$2"
	local CACHE="$3"
	if /sbin/busybox test -f "/system/app/$APK.apk"; then
		SEND_LOG "  rm -f /system/app/$APK.apk"
		/sbin/busybox rm -f /system/app/$APK.apk
	fi
	if /sbin/busybox test -f "/system/app/$APK.odex"; then
		SEND_LOG "  rm -f /system/app/$APK.odex"
		/sbin/busybox rm -f /system/app/$APK.odex
	fi
	if /sbin/busybox test -d "/data/data/$DATA"; then
		SEND_LOG "  rm -rf /data/data/$DATA"
		/sbin/busybox rm -rf /data/data/$DATA
	fi
	if /sbin/busybox test -f "/data/dalvik-cache/$CACHE"; then
		SEND_LOG "  rm -f /data/dalvik-cache/$CACHE"
		/sbin/busybox rm -f /data/dalvik-cache/$CACHE
	fi
}

#main
SEND_LOG "Start"

if /sbin/busybox test "$1" = "recovery"; then
	SEND_LOG "Installing busybox to /sbin"
	/sbin/busybox --install -s /sbin

	SEND_LOG "Sync filesystem"
	sync
else
	SEND_LOG "Ensuring there is room for busybox and root"
	SEND_LOG "  Removing market downloadable apps from /system/app"
	REMOVE_SYSTEM_APP "amazonmp3" "com.amazon.mp3" "system@app@amazonmp3.apk@classes.dex"
	REMOVE_SYSTEM_APP "BooksPhone" "com.google.android.apps.books" "system@app@BooksPhone.apk@classes.dex"
	REMOVE_SYSTEM_APP "FBAndroid-1.5.4" "com.facebook.katana" "system@app@FBAndroid-1.5.4.apk@classes.dex"
	REMOVE_SYSTEM_APP "Gmail" "com.google.android.gm" "system@app@Gmail.apk@classes.dex"
	REMOVE_SYSTEM_APP "install_flash_player" "com.adobe.flashplayer" "system@app@install_flash_player.apk@classes.dex"
	REMOVE_SYSTEM_APP "Maps" "com.google.android.apps.maps" "system@app@Maps.apk@classes.dex"
	REMOVE_SYSTEM_APP "MediaHubV126" "com.sdgtl.mediahub.spr" "system@app@MediaHubV126.apk@classes.dex"
	REMOVE_SYSTEM_APP "qik-8.66-release-ffc" "com.qikffc.android" "system@app@qik-8.66-release-ffc.apk@classes.dex"
	REMOVE_SYSTEM_APP "Street" "com.google.android.street" "system@app@Street.apk@classes.dex"
	REMOVE_SYSTEM_APP "Talk" "com.google.android.talk" "system@app@Talk.apk@classes.dex"
	REMOVE_SYSTEM_APP "Term1" "com.android.term1"
	REMOVE_SYSTEM_APP "Term2" "com.android.term2"
	REMOVE_SYSTEM_APP "Term3" "com.android.term3"
	REMOVE_SYSTEM_APP "Term4" "com.android.term4"
	REMOVE_SYSTEM_APP "Term5" "com.android.term5"
	REMOVE_SYSTEM_APP "YouTube" "com.google.android.youtube" "system@app@YouTube.apk@classes.dex"

	SEND_LOG "Setting BB_PATH"
	BB_PATH=/data/local/tmp

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

