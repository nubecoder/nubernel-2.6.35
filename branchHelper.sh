#!/bin/bash
#
# branchHelper.sh
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

#define version string
VERSION_STRING="nubernel-2.6.35_v"
CURRENT_VERSION="0.0.2"

# defaults
RELEASE="n"
FEATURE="n"
VERBOSE="n"

# define vars
NEW_VERSION=
FEATURE_NAME=
ERROR_MSG=

# functions
SHOW_HELP()
{
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "Usage options for $0:"
	echo "-f : Checkout a new feature branch."
	echo "     Example: -f overclock"
	echo "-h : Print this help info."
	echo "-r : Checkout a new release branch."
	echo "     Example: -r 0.0.1."
	echo "-v : Verbose mode."
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	exit 1
}
SHOW_SETTINGS()
{
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	if [ "$RELEASE" = "y" ]; then
		echo "Old Version  == ${VERSION_STRING}$CURRENT_VERSION"
		echo "Vew Version  == ${VERSION_STRING}$NEW_VERSION"
		echo "Verbose Mode == $VERBOSE"
	fi
	if [ "$FEATURE" = "y" ]
	then
		echo "Feature Name == $FEATURE_NAME"
		echo "Verbose Mode == $VERBOSE"
	fi
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "*"
}
SHOW_COMPLETED()
{
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "Script completed."
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	exit
}
SHOW_ERROR()
{
	if [ -n "$ERROR_MSG" ]; then
		echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
		echo "$ERROR_MSG"
	fi
}
BRANCH_RELEASE()
{
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	# start time
	local T1=$(date +%s)
	echo "Begin release branch..." && echo ""
	# checkout new branch (always from dev)
	local RESULT=$(git checkout -b release-v${NEW_VERSION} dev 2>&1 >/dev/null)
	# check for errors
	local FIND_ERR="error: "
	if [ "$RESULT" != "${RESULT/$FIND_ERR/}" ]; then
		ERROR_MSG=${RESULT/$FIND_ERR/}
		SHOW_ERROR
		SHOW_COMPLETED
	fi
	# update files
	local PATTERN="${VERSION_STRING}$CURRENT_VERSION"
	local REPLACEMENT="${VERSION_STRING}$NEW_VERSION"
	if [ "$VERBOSE" = "y" ]; then
		sed -i "s/$PATTERN/$REPLACEMENT/g" changelog
		sed -i "s/$PATTERN/$REPLACEMENT/g" update/cm7/META-INF/com/google/android/updater-script
		sed -i "s/$PATTERN/$REPLACEMENT/g" update/cm7/META-INF/com/android/metadata
		sed -i "s/$PATTERN/$REPLACEMENT/g" update/tw/META-INF/com/google/android/updater-script
		sed -i "s/$PATTERN/$REPLACEMENT/g" update/tw/META-INF/com/android/metadata
		sed -i "s/$PATTERN/$REPLACEMENT/g" update/mtd/META-INF/com/google/android/updater-script
		sed -i "s/$PATTERN/$REPLACEMENT/g" update/mtd/META-INF/com/android/metadata
		sed -i "s/$PATTERN/$REPLACEMENT/g" firmware.info
		sed -i "s/$PATTERN/$REPLACEMENT/g" README
		sed -i "s/$PATTERN/$REPLACEMENT/g" include/includes
		sed -i "s/$PATTERN/$REPLACEMENT/g" featurelist
	else
		sed -i "s/$PATTERN/$REPLACEMENT/g" changelog >/dev/null 2>&1
		sed -i "s/$PATTERN/$REPLACEMENT/g" update/cm7/META-INF/com/google/android/updater-script >/dev/null 2>&1
		sed -i "s/$PATTERN/$REPLACEMENT/g" update/cm7/META-INF/com/android/metadata >/dev/null 2>&1
		sed -i "s/$PATTERN/$REPLACEMENT/g" update/tw/META-INF/com/google/android/updater-script >/dev/null 2>&1
		sed -i "s/$PATTERN/$REPLACEMENT/g" update/tw/META-INF/com/android/metadata >/dev/null 2>&1
		sed -i "s/$PATTERN/$REPLACEMENT/g" update/mtd/META-INF/com/google/android/updater-script >/dev/null 2>&1
		sed -i "s/$PATTERN/$REPLACEMENT/g" update/mtd/META-INF/com/android/metadata >/dev/null 2>&1
		sed -i "s/$PATTERN/$REPLACEMENT/g" firmware.info >/dev/null 2>&1
		sed -i "s/$PATTERN/$REPLACEMENT/g" README >/dev/null 2>&1
		sed -i "s/$PATTERN/$REPLACEMENT/g" include/includes >/dev/null 2>&1
		sed -i "s/$PATTERN/$REPLACEMENT/g" featurelist >/dev/null 2>&1
	fi

	local PATTERN="LOCALVERSION=\".nubernel_v${CURRENT_VERSION}\""
	local REPLACEMENT="LOCALVERSION=\".nubernel_v${NEW_VERSION}\""
	if [ "$VERBOSE" = "y" ]; then
		sed -i "s/$PATTERN/$REPLACEMENT/g" include/includes
	else
		sed -i "s/$PATTERN/$REPLACEMENT/g" include/includes >/dev/null 2>&1
	fi

	local PATTERN="CURRENT_VERSION=\"$CURRENT_VERSION\""
	local REPLACEMENT="CURRENT_VERSION=\"$NEW_VERSION\""
	if [ "$VERBOSE" = "y" ]; then
		sed -i "s/$PATTERN/$REPLACEMENT/g" $0
	else
		sed -i "s/$PATTERN/$REPLACEMENT/g" $0 >/dev/null 2>&1
	fi
	# git add changes
	if [ "$VERBOSE" = "y" ]
	then
		git add changelog
		git add update/cm7/META-INF/com/google/android/updater-script
		git add update/cm7/META-INF/com/android/metadata
		git add update/tw/META-INF/com/google/android/updater-script
		git add update/tw/META-INF/com/android/metadata
		git add update/mtd/META-INF/com/google/android/updater-script
		git add update/mtd/META-INF/com/android/metadata
		git add firmware.info
		git add README
		git add include/includes
		git add featurelist
		git add $0
	else
		git add changelog >/dev/null 2>&1
		git add update/cm7/META-INF/com/google/android/updater-script >/dev/null 2>&1
		git add update/cm7/META-INF/com/android/metadata >/dev/null 2>&1
		git add update/tw/META-INF/com/google/android/updater-script >/dev/null 2>&1
		git add update/tw/META-INF/com/android/metadata >/dev/null 2>&1
		git add update/mtd/META-INF/com/google/android/updater-script >/dev/null 2>&1
		git add update/mtd/META-INF/com/android/metadata >/dev/null 2>&1
		git add firmware.info >/dev/null 2>&1
		git add README >/dev/null 2>&1
		git add include/includes >/dev/null 2>&1
		git add featurelist >/dev/null 2>&1
		git add $0 >/dev/null 2>&1
	fi
	# show some info
	echo "git status -s:"
	git status -s
	echo "git branch:"
	git branch
	# git commit
	local BRANCH_MSG="Branched to 'release-v${NEW_VERSION}'."
	echo "Commit:"
	git commit -m "$BRANCH_MSG"
	echo "$BRANCH_MSG"
	# end time
	local T2=$(date +%s)
	echo "" && echo "Release branch took $(($T2 - $T1)) seconds."
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "*"
}
BRANCH_FEATURE()
{
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	# start time
	local T1=$(date +%s)
	echo "Begin feature branch..." && echo ""
	# checkout new branch (always from dev)
	local RESULT=$(git checkout -b feature-${FEATURE_NAME} dev 2>&1 >/dev/null)
	# check for errors
	local FIND_ERR="error: "
	if [ "$RESULT" != "${RESULT/$FIND_ERR/}" ]; then
		ERROR_MSG=${RESULT/$FIND_ERR/}
		SHOW_ERROR
		SHOW_COMPLETED
	fi
	# show some info
	echo "git status -s:"
	git status -s
	echo "git branch:"
	git branch
	echo "Branched to 'feature-${FEATURE_NAME}'."
	# end time
	local T2=$(date +%s)
	echo "" && echo "Feature branch took $(($T2 - $T1)) seconds."
	echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
	echo "*"
}


# main
while getopts  ":f:hr:v" flag; do
	case "$flag" in
	f)
		FEATURE="y"
		RELEASE="n"
		FEATURE_NAME="$OPTARG"
		;;
	h)
		SHOW_HELP
		;;
	r)
		FEATURE="n"
		RELEASE="y"
		NEW_VERSION="$OPTARG"
		;;
	v)
		VERBOSE="y"
		;;
	*)
		ERROR_MSG="Error:: problem with option '$OPTARG'"
		SHOW_ERROR
		SHOW_HELP
		;;
	esac
done

if [ "$RELEASE" = "y" ]; then
	SHOW_SETTINGS
	BRANCH_RELEASE
fi
if [ "$FEATURE" = "y" ]; then
	SHOW_SETTINGS
	BRANCH_FEATURE
fi

if [ "$RELEASE" = "n" -a "$FEATURE" = "n" ]; then
	SHOW_HELP
fi

SHOW_COMPLETED

