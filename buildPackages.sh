#!/bin/bash
#
# buildPackages.sh
# nubecoder 2012 - http://www.nubecoder.com/
#

#defines
ARGS="$@"
START_TIME=$(date +%s)

#main
echo "Begin building all packagable types."
./ncBuildHelper.sh $ARGS "-mbpt" "tw-bml"
./ncBuildHelper.sh $ARGS "-mbpt" "tw-mtd"
./ncBuildHelper.sh $ARGS "-mbpt" "cm7"
./ncBuildHelper.sh $ARGS "-mbpt" "dbg-bml"
./ncBuildHelper.sh $ARGS "-mbpt" "dbg-mtd"
echo "Finished building all packagable types. ($(date +%r))"

END_TIME=$(date +%s)
echo "buildAll took $(($END_TIME - $START_TIME)) seconds."

