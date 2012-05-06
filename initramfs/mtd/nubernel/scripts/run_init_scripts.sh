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

temp=/nubernel/scripts/run_parts.sh
SEND_LOG "Setting permissions: $temp"
chown root system "$temp"
chmod 0755 "$temp"
unset temp

for x in /nubernel/scripts/init* ; do
	SEND_LOG "Running: $x"
	/system/bin/logwrapper "$x"
done
SEND_LOG "Running: /nubernel/scripts/run_parts.sh"
/system/bin/logwrapper /nubernel/scripts/run_parts.sh

SEND_LOG "End"

