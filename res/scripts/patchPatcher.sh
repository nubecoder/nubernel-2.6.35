#!/bin/bash
#
# patchPatcher.sh
# nubecoder 2012 - http://www.nubecoder.com/
#

#functions
PATCH_FILE()
{
  local PATTERN=" a\/"
  local REPLACEMENT=" a\/Kernel\/"
  sed -i "s/$PATTERN/$REPLACEMENT/g" "$1"

  local PATTERN=" b\/"
  local REPLACEMENT=" b\/Kernel\/"
  sed -i "s/$PATTERN/$REPLACEMENT/g" "$1"

  local LIST="arch block crypto Documentation drivers firmware fs include init ipc"
  local LIST="$LIST kernel lib mm net samples scripts security sound tools usr virt"
  local LIST="$LIST COPYING CREDITS Kbuild MAINTAINERS Makefile README REPORTING-BUGS"

  for ITEM in $LIST ; do
    local PATTERN="^ $ITEM"
    local REPLACEMENT=" Kernel\/$ITEM"
    sed -i "s/$PATTERN/$REPLACEMENT/g" "$1"
  done
}

#main
if [ "$1" != "" ] && [ -f "$1" ] ; then
  echo "Patching file: $1"
  PATCH_FILE "$1"
else
  echo "Usage: $0 <file to patch>"
fi

echo "Done!"

