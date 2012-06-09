#!/bin/bash
#
# menuConfig.sh
# nubecoder 2012 - http://www.nubecoder.com/
#

#source includes
source "$PWD/include/includes"

#exports
export KBUILD_BUILD_VERSION

#functions
function SHOW_SETTINGS()
{
	TIME_START=$(date +%s)
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "cross compile   == $CROSS_COMPILE"
	echo "make threads    == $THREADS"
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "*"
}

#main
SHOW_SETTINGS

MAKE_MENUCONFIG

SHOW_COMPLETED

