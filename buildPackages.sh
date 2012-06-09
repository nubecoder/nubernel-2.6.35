#!/bin/bash
#
# buildPackages.sh
# nubecoder 2012 - http://www.nubecoder.com/
#

#source includes
source "$PWD/include/includes"

#defaults
RECOVERY_TYPE="cwm"
CLEAN=n
DISTCLEAN=n
VERBOSE=n

#defines
START_TIME=$(date +%s)

#functions
function SHOW_HELP()
{
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "Usage options for $0:"
	echo "-c : Run 'make clean'."
	echo "-d : Run 'make distclean'."
	echo "-h : Print this help info."
	echo "-r : Define the recovery type."
	echo "     Recovery types are: <cwm|twrp> (defaults to cwm)."
	echo "-v : Verbose script output."
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	exit 1
}

#main
while getopts ":cdhr:v" flag
do
	case "$flag" in
		c)
			CLEAN=y ;;
		d)
			DISTCLEAN=y ;;
		h)
			SHOW_HELP ;;
		r)
			case "$OPTARG" in
				cwm)
					RECOVERY_TYPE="$OPTARG" ;;
				twrp)
					RECOVERY_TYPE="$OPTARG" ;;
				*)
					ERROR_MSG="Error:: problem with option '$OPTARG'"
					SHOW_ERROR
					SHOW_HELP ;;
			esac ;;
		v)
			VERBOSE=y ;;
		*)
			ERROR_MSG="Error:: problem with option '$OPTARG'"
			SHOW_ERROR
			SHOW_HELP ;;
		esac
done

if [ "$CLEAN" = "y" ] ; then
	ARGS="${ARGS}c"
fi
if [ "$DISTCLEAN" = "y" ] ; then
	ARGS="${ARGS}d"
fi
if [ "$VERBOSE" = "y" ] ; then
	ARGS="${ARGS}v"
fi

echo "Begin building all packagable types."
if [ "$ARGS" = "" ] ; then
	./ncBuildHelper.sh "-mbpt" "tw-bml"
	./ncBuildHelper.sh "-mbpt" "dbg-bml"
	./ncBuildHelper.sh "-mbpt" "tw-mtd" "-r" "$RECOVERY_TYPE"
	./ncBuildHelper.sh "-mbpt" "dbg-mtd" "-r" "$RECOVERY_TYPE"
	./ncBuildHelper.sh "-mbpt" "cm7" "-r" "$RECOVERY_TYPE"
else
	./ncBuildHelper.sh "-$ARGS" "-mbpt" "tw-bml"
	./ncBuildHelper.sh "-$ARGS" "-mbpt" "dbg-bml"
	./ncBuildHelper.sh "-$ARGS" "-mbpt" "tw-mtd" "-r" "$RECOVERY_TYPE"
	./ncBuildHelper.sh "-$ARGS" "-mbpt" "dbg-mtd" "-r" "$RECOVERY_TYPE"
	./ncBuildHelper.sh "-$ARGS" "-mbpt" "cm7" "-r" "$RECOVERY_TYPE"
fi
echo "Finished building all packagable types. ($(date +%r))"

END_TIME=$(date +%s)
echo "buildAll took $(($END_TIME - $START_TIME)) seconds."

