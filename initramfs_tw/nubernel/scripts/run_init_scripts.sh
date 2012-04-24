#!/system/bin/sh
#
# run_init_scripts.sh
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "run_init_scripts : $1"
}

#main
SEND_LOG "Start"

for x in /nubernel/scripts/init* ; do
	SEND_LOG "Running: $x"
	/system/bin/logwrapper "$x"
done
SEND_LOG "Running: /nubernel/scripts/run_parts.sh"
/system/bin/logwrapper /nubernel/scripts/run_parts.sh

SEND_LOG "End"

