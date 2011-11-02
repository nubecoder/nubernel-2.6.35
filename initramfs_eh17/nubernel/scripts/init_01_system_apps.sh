#!/system/bin/sh
#
# init_01_system_apps.sh
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "init_01_system_apps : $1"
}
REMOVE_SYSTEM_APP()
{
	local APK="$1"
	local DATA="$2"
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
}

MOVE_SYSTEM_APP()
{
	local APK="$1"
	local DATA="$2"
	local CACHE="$3"
	if /sbin/busybox test -f "/system/app/$APK.odex"; then
		SEND_LOG "  Detected odex file, app will not be moved"
		return 1
	fi
	if /sbin/busybox test -f "/system/app/$APK.apk"; then
		SEND_LOG "  Detected apk file, moving app to /data/app"
		local EXISTING_APP_FIND=$(/sbin/busybox find /data/app -iname "${DATA}*")
		for EXISTING_APP in $EXISTING_APP_FIND ; do
			SEND_LOG "  rm -f $EXISTING_APP"
			/sbin/busybox rm -f "$EXISTING_APP"
		done
		SEND_LOG "  mv -f /system/app/$APK.apk /data/app/${DATA}-1.apk"
		/sbin/busybox mv -f /system/app/$APK.apk /data/app/${DATA}-1.apk
		/sbin/busybox chown system.system /data/app/${DATA}-1.apk
		/sbin/busybox chmod 0644 /data/app/${DATA}-1.apk
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
	# do nothing
else
	SEND_LOG "Ensuring there is room for busybox and root"

	SEND_LOG "  Moving market downloadable apps to /data/app"
	MOVE_SYSTEM_APP "amazonmp3" "com.amazon.mp3" "system@app@amazonmp3.apk@classes.dex"
	MOVE_SYSTEM_APP "BooksPhone" "com.google.android.apps.books" "system@app@BooksPhone.apk@classes.dex"
	MOVE_SYSTEM_APP "FBAndroid-1.5.4" "com.facebook.katana" "system@app@FBAndroid-1.5.4.apk@classes.dex"
	MOVE_SYSTEM_APP "Gmail" "com.google.android.gm" "system@app@Gmail.apk@classes.dex"
	MOVE_SYSTEM_APP "install_flash_player" "com.adobe.flashplayer" "system@app@install_flash_player.apk@classes.dex"
	MOVE_SYSTEM_APP "Maps" "com.google.android.apps.maps" "system@app@Maps.apk@classes.dex"
	MOVE_SYSTEM_APP "MediaHubV126" "com.sdgtl.mediahub.spr" "system@app@MediaHubV126.apk@classes.dex"
	MOVE_SYSTEM_APP "qik-8.66-release-ffc" "com.qikffc.android" "system@app@qik-8.66-release-ffc.apk@classes.dex"
	MOVE_SYSTEM_APP "Street" "com.google.android.street" "system@app@Street.apk@classes.dex"
	MOVE_SYSTEM_APP "YouTube" "com.google.android.youtube" "system@app@YouTube.apk@classes.dex"

	SEND_LOG "  Removing 5 copys of Term.apk (why Samsung, why?)"
	REMOVE_SYSTEM_APP "Term1" "com.android.term1"
	REMOVE_SYSTEM_APP "Term2" "com.android.term2"
	REMOVE_SYSTEM_APP "Term3" "com.android.term3"
	REMOVE_SYSTEM_APP "Term4" "com.android.term4"
	REMOVE_SYSTEM_APP "Term5" "com.android.term5"

	SEND_LOG "Sync filesystem"
	/system/xbin/busybox sync
fi

SEND_LOG "End"

