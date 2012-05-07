#!/system/bin/sh
#
# run_init_scripts.sh
# nubecoder 2012 - http://www.nubecoder.com/
#

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "run_init_scripts : $1"
}

#main
SEND_LOG "Start"

SEND_LOG "Remount as RW"
/sbin/busybox mount -o remount,rw /
/sbin/busybox mount -o remount,rw /system

for x in /nubernel/scripts/init* ; do
	SEND_LOG "Setting permissions: $x"
	chown root system "$x"
	chmod 0755 "$x"
done
for x in /nubernel/scripts/init* ; do
	SEND_LOG "Running: $x"
	/system/bin/logwrapper "$x"
done

temp=/nubernel/scripts/run_parts.sh
SEND_LOG "Setting permissions: $temp"
chown root system "$temp"
chmod 0755 "$temp"
SEND_LOG "Running: $temp"
/system/bin/logwrapper "$temp"

temp=/data/local/tmp/mount_ro.sh
SEND_LOG "Setting permissions: $temp"
chown root system "$temp"
chmod 0755 "$temp"
SEND_LOG "Invoking: $temp"
nohup /system/bin/logwrapper "$temp" &
unset temp

SEND_LOG "End"

