#!/sbin/sh
# Dump, and kexec the recovery kernel
# This is to make reboot recovery consistant with 3-finger recovery
# - Tortel

# Dump the recovery kernel
dd if=/dev/block/bml8 of=/tmp/zImage
#Prevent odd permission errors
chmod 777 /tmp/zImage
#Load it
/sbin/kexec --load-hardboot --mem-min=0x50000000 --append=bootmode=2 /tmp/zImage
#Boot it
/sbin/kexec -e
