#!/system/bin/sh
#
# init_04_other.sh
# nubecoder 2012 - http://www.nubecoder.com/
#

#defines
FIRST_BOOT_FILE="/data/local/.first_boot"
BASH_VER="3.2.51"

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "init_04_other : $1"
}
FORCE_MOVE_FILE()
{
	local SOURCE_FILE="$1"
	local DEST_FILE="$2"
	SEND_LOG "    Moving $SOURCE_FILE to $DEST_FILE"
	busybox mv -f "$SOURCE_FILE" "$DEST_FILE"
}
INSTALL_RESOURCE_FILE()
{
	local SOURCE_FILE="$1"
	local DEST_FILE="$2"
	if [ ! -f "$DEST_FILE" ]; then
		SEND_LOG "  Installing $DEST_FILE"
		busybox mv "$SOURCE_FILE" "$DEST_FILE"
	fi
}
ENSURE_BASH_INSTALL()
{
	if [ ! -f "/system/bin/bash" ]; then
		SEND_LOG "  Installing Bash to /system/bin/"
		FORCE_MOVE_FILE "/nubernel/files/bash-$BASH_VER" "/system/bin/bash"
	fi
	SEND_LOG "  Ensuring permissions for /system/bin/bash"
	busybox chmod 0755 /system/bin/bash
	busybox chown 0.2000 /system/bin/bash
}
ENSURE_RESOURCES_INSTALL()
{
	# /data/local/
	local SOURCE_FILE="/nubernel/files/res/dotbash_aliases"
	local DEST_FILE="/data/local/.bash_aliases"
	INSTALL_RESOURCE_FILE "$SOURCE_FILE" "$DEST_FILE"
	local SOURCE_FILE="/nubernel/files/res/dotbashrc"
	local DEST_FILE="/data/local/.bashrc"
	INSTALL_RESOURCE_FILE "$SOURCE_FILE" "$DEST_FILE"
	local SOURCE_FILE="/nubernel/files/res/dotinputrc"
	local DEST_FILE="/data/local/.inputrc"
	INSTALL_RESOURCE_FILE "$SOURCE_FILE" "$DEST_FILE"
	local SOURCE_FILE="/nubernel/files/res/dotprofile"
	local DEST_FILE="/data/local/.profile"
	INSTALL_RESOURCE_FILE "$SOURCE_FILE" "$DEST_FILE"
	# /system/etc/
	if [ ! -d "/system/etc/bash" ] ; then
		busybox mkdir -p "/system/etc/bash"
	fi
	local SOURCE_FILE="/nubernel/files/res/bash_logout"
	local DEST_FILE="/system/etc/bash/bash_logout"
	INSTALL_RESOURCE_FILE "$SOURCE_FILE" "$DEST_FILE"
	local SOURCE_FILE="/nubernel/files/res/bashrc"
	local DEST_FILE="/system/etc/bash/bashrc"
	INSTALL_RESOURCE_FILE "$SOURCE_FILE" "$DEST_FILE"
	local SOURCE_FILE="/nubernel/files/res/profile"
	local DEST_FILE="/system/etc/profile"
	INSTALL_RESOURCE_FILE "$SOURCE_FILE" "$DEST_FILE"
}
ENSURE_BASH_DEFAULT_ADB_SHELL()
{
	if [ -x "/system/bin/bash" ]; then
		if [ ! -f "/system/bin/sh.bak" ]; then
			SEND_LOG "  Backing up /system/bin/sh to /system/bin/sh.bak"
			local SOURCE_FILE="/system/bin/sh"
			local DEST_FILE="/system/bin/sh.bak"
			FORCE_MOVE_FILE "$SOURCE_FILE" "$DEST_FILE"
		else
			SEND_LOG "  Found /system/bin/sh.bak, skipping backup"
		fi
		SEND_LOG "  Installing loading script to /system/bin/sh"
		local SOURCE_FILE="/nubernel/files/bash-loader"
		local DEST_FILE="/system/bin/sh"
		FORCE_MOVE_FILE "$SOURCE_FILE" "$DEST_FILE"
	else
		SEND_LOG "  Executable /system/bin/bash not found"
		if [ -f "/system/bin/sh.bak" ]; then
			SEND_LOG "    Found /system/bin/sh.bak, restoring backup"
			local SOURCE_FILE="/system/bin/sh.bak"
			local DEST_FILE="/system/bin/sh"
			FORCE_MOVE_FILE "$SOURCE_FILE" "$DEST_FILE"
		else
			SEND_LOG "    Could not find /system/bin/sh.bak, nothing to do..."
		fi
	fi
	SEND_LOG "  Ensuring permissions for /system/bin/sh.bak"
	busybox chmod 0755 /system/bin/sh.bak
	busybox chown 0.2000 /system/bin/sh.bak
	SEND_LOG "  Ensuring permissions for /system/bin/sh"
	busybox chmod 0755 /system/bin/sh
	busybox chown 0.2000 /system/bin/sh
}


#main
SEND_LOG "Start"

SEND_LOG "Moving custom scripts to /data/local/bin/"
if [ ! -d "/data/local/bin" ] ; then
	busybox mkdir -p "/data/local/bin"
fi
for FILE in /nubernel/bin/* ; do
	SEND_LOG "  Moving $FILE to /data/local/bin/"
	busybox mv -f "$FILE" "/data/local/bin/"
done

SEND_LOG "Checking for $FIRST_BOOT_FILE"
if [ -f "$FIRST_BOOT_FILE" ] ; then
	SEND_LOG "  Found: $FIRST_BOOT_FILE"
	SEND_LOG "    Skipping bash installation"
else
	SEND_LOG "Ensuring bash is installed"
	ENSURE_BASH_INSTALL

	SEND_LOG "Ensuring bash resources are installed"
	ENSURE_RESOURCES_INSTALL

	SEND_LOG "Ensuring bash as default adb shell"
	ENSURE_BASH_DEFAULT_ADB_SHELL
fi

SEND_LOG "Preventing certain malware apps (DroidDream)"
. >/system/bin/profile
busybox chmod 0400 /system/bin/profile

SEND_LOG "Ensuring KB timer_delay is set up properly"
if [ ! -f "/data/local/timer_delay" ] ; then
	SEND_LOG "  Setting KB timer_delay to 5"
	echo 5 >/data/local/timer_delay
fi
busybox cat /data/local/timer_delay >/sys/devices/platform/s3c-keypad/timer_delay
busybox cat /data/local/timer_delay >/sys/devices/platform/s3c-keypad/column_delay

SEND_LOG "Ensuring bootanimation.zip gets played"
if [ -f "/system/media/bootanimation.zip" ] && [ ! -f "/system/media/sanim.zip" ] ; then
	SEND_LOG "  Symlinking sanim.zip to bootanimation.zip"
	busybox ln -s /system/media/bootanimation.zip /system/media/sanim.zip
fi

SEND_LOG "Sync filesystem"
busybox sync

SEND_LOG "End"

