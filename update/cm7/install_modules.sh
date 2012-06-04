#!/sbin/busybox sh
#
# install_modules.sh
# backup original and install newer modules
# nubecoder 2012 - http://www.nubecoder.com/
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
# Installing 2.6.35.14 modules
#
########################################################################################
EOF

for MODULE in $MODULES_LIST ; do
	if busybox test -f "$SRC_PATH/$MODULE" ; then
		if busybox test -f "$DST_PATH/$MODULE" ; then
			if busybox test "$MODULE" != "logger.ko" ; then
				if busybox test ! -f "$DST_PATH/$MODULE.bak" ; then
					echo "$MODULE found, making backup."
					busybox mv "$DST_PATH/$MODULE" "$DST_PATH/$MODULE.bak"
				else
					echo "$MODULE.bak found, skipping backup."
				fi
			fi
		else
			if busybox test "$MODULE" != "logger.ko" ; then
				# no backup can be made, just install
				echo "$MODULE not found, cannot backup."
				busybox mkdir -p "$DST_PATH"
			fi
		fi
		echo "Installing :$MODULE."
		busybox mv "$SRC_PATH/$MODULE" "$DST_PATH/$MODULE"
		busybox chown 0.2000 "$DST_PATH/$MODULE"
		busybox chmod 755 "$DST_PATH/$MODULE"
		echo "Success:: $MODULE."
	else
		echo "Error:: $SRC_PATH/$MODULE not found!"
	fi
done

exit
