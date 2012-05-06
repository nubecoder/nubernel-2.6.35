#!/sbin/busybox sh
#
# install_modules.sh
# backup originals and install 2.6.35.13 modules
#

SRC_PATH="/tmp"
DST_PATH="/system/lib/modules"
MODULES_LIST="bcm4329.ko cmc7xx_sdio.ko logger.ko vibrator.ko"

# remove old log
rm -rf /sdcard/install_modules.log
# everything is logged into /sdcard/install_modules.log
exec >> /sdcard/install_modules.log 2>&1
set -x
busybox cat <<EOF
########################################################################################
#
# Installing 2.6.35.13 modules
#
########################################################################################
EOF

for MODULE in $MODULES_LIST ; do
	if busybox test -f "$SRC_PATH/$MODULE" ; then
		if busybox test -f "$DST_PATH/$MODULE" ; then
			echo "$MODULE found, making backup."
			busybox mv "$DST_PATH/$MODULE" "$DST_PATH/$MODULE.bak"
			echo "Installing :$MODULE."
			busybox mv "$SRC_PATH/$MODULE" "$DST_PATH/$MODULE"
			busybox chown 0.2000 "$DST_PATH/$MODULE"
			busybox chmod 755 "$DST_PATH/$MODULE"
			echo "Success:: $MODULE."
		else
			# no backup can be made, just install
			echo "$MODULE not found, cannot backup."
			busybox mkdir -p "$DST_PATH"
			echo "Installing :$MODULE."
			busybox mv "$SRC_PATH/$MODULE" "$DST_PATH/$MODULE"
			busybox chown 0.2000 "$DST_PATH/$MODULE"
			busybox chmod 755 "$DST_PATH/$MODULE"
			echo "Success:: $MODULE."
		fi
	else
		echo "Error:: /tmp/$MODULE not found!"
	fi
done

exit
