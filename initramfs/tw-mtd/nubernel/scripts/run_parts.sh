#!/system/bin/sh
#
# run_parts.sh
# nubecoder 2012 - http://www.nubecoder.com/
#

#exports
export PATH=/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:/data/local/bin
export LD_LIBRARY_PATH=/vendor/lib:/system/lib:/system/lib/egl

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "run_parts : $1"
}

#main
SEND_LOG "Start"

if [ -d /system/etc/init.d ] ; then
	for x in /system/etc/init.d/* ; do
		SEND_LOG "Running: $x"
		/system/bin/logwrapper "$x"
	done
fi

SEND_LOG "End"

