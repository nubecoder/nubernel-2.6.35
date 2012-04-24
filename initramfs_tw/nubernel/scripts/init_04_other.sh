#!/system/bin/sh
#
# init_04_other
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "init_04_other : $1"
}

#main
SEND_LOG "Start"

SEND_LOG "Installing scripts into /vendor/bin"
busybox mv -f /nubernel/bin/* /vendor/bin/

SEND_LOG "Preventing certain malware apps (DroidDream)"
. >/system/bin/profile
busybox chmod 0400 /system/bin/profile

SEND_LOG "Ensuring KB timer_delay is set up properly"
if [ ! -f "/data/local/timer_delay" ] ; then
	SEND_LOG "  Setting KB timer_delay to 5"
	echo 5 >/data/local/timer_delay
fi
busybox cat /data/local/timer_delay >/sys/devices/platform/s3c-keypad/timer_delay
busybox cat /data/local/timer_delay >/sys/devices/platform/s3c-keypad/column_delay

SEND_LOG "Ensuring bootanimation.zip gets played"
if [ -f "/system/media/bootanimation.zip" ] && [ ! -f "/system/media/sanim.zip" ] ; then
	SEND_LOG "  Symlinking sanim.zip to bootanimation.zip"
	busybox ln -s /system/media/bootanimation.zip /system/media/sanim.zip
fi

SEND_LOG "Sync filesystem"
busybox sync

SEND_LOG "End"

