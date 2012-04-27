# /data/local/.bash_aliases
#

# aliases
#
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# NOTE:: !! not sure this works in android
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# taken from CM:
# Set up a ton of aliases to cover toolbox with the nice busybox
# equivalents of its commands
for i in cat chmod chown cp df insmod ln lsmod mkdir mount mv rm rmdir rmmod umount vi ; do
	eval alias ${i}=\"busybox ${i}\"
done
unset i

#some custom aliases
alias ls='busybox ls --color=auto'
alias l='busybox ls -CF --color=auto'
alias la='busybox ls -A --color=auto'
alias ll='busybox ls -AlF --color=auto'
# taken from CM:
alias sysro='mount -o remount,ro /system'
alias sysrw='mount -o remount,rw /system'
