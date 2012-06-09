#!/sbin/busybox sh
#
# restore_modules.sh
# restore backed up modules
# nubecoder 2012 - http://www.nubecoder.com/
#

DST_PATH="/system/lib/modules"
MODULES_LIST="bcm4329.ko cmc7xx_sdio.ko vibrator.ko"

# remove old log
rm -rf /sdcard/restore_modules.log
# everything is logged into /sdcard/restore_modules.log
exec >> /sdcard/restore_modules.log 2>&1
set -x
busybox cat <<EOF
########################################################################################
#
# Restoring backed up modules
#
########################################################################################
EOF

for MODULE in $MODULES_LIST ; do
	if busybox test -f "$DST_PATH/$MODULE.bak" ; then
		echo "$MODULE.bak found, restoring backup."
		busybox rm -rf "$DST_PATH/$MODULE"
		busybox mv "$DST_PATH/$MODULE.bak" "$DST_PATH/$MODULE"
		busybox chown 0.2000 "$DST_PATH/$MODULE"
		busybox chmod 755 "$DST_PATH/$MODULE"
		echo "Success:: $MODULE."
	else
		echo "$MODULE.bak not found, skipping restore."
		echo "Error:: $MODULE.bak not found!"
	fi
done

exit
