#!/bin/bash
#
# buildAll.sh
# nubecoder 2012 - http://www.nubecoder.com/
#

#TODO: Add args support to pass args along to build script.
START_TIME=$(date +%s)
echo "Begin building all packagable types."
./ncBuildHelper.sh -cbmpt tw
./ncBuildHelper.sh -cbmpt mtd
./ncBuildHelper.sh -cbmpt cm7
if [ "$1" = "twrp" ] ; then
	./ncBuildHelper.sh -cbmpt mtd -r twrp
	./ncBuildHelper.sh -cbmpt cm7 -r twrp
fi

echo "Finished building all packagable types. ($(date +%r))"
END_TIME=$(date +%s)
echo "buildAll took $(($END_TIME - $START_TIME)) seconds."

