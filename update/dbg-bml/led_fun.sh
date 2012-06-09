#!/sbin/busybox sh
#
# led_fun.sh (fun with leds)
# nubecoder 2012 - http://www.nubecoder.com/
#

#defines
RED_PATH="/sys/class/leds/red"
BLUE_PATH="/sys/class/leds/blue"
ARG="$1"

#functions
SET_LED_TRIGGER_TIMER()
{
	local COLOR_PATH="$1"
	# if no color is set default to both
	if [ "$COLOR_PATH" = "" ] ; then
		if [ -e "$RED_PATH/trigger" ] ; then
			busybox echo "timer" >"$RED_PATH/trigger"
		fi
		if [ -e "$BLUE_PATH/trigger" ] ; then
			busybox echo "timer" >"$BLUE_PATH/trigger"
		fi
	else
		if [ -e "$COLOR_PATH/trigger" ] ; then
			busybox echo "timer" >"$COLOR_PATH/trigger"
		fi
	fi
}
SET_LED_TRIGGER_NONE()
{
	local COLOR_PATH="$1"
	# if no color is set default to both
	if [ "$COLOR_PATH" = "" ] ; then
		if [ -e "$RED_PATH/trigger" ] ; then
			busybox echo "none" >"$RED_PATH/trigger"
		fi
		if [ -e "$BLUE_PATH/trigger" ] ; then
			busybox echo "none" >"$BLUE_PATH/trigger"
		fi
	else
		if [ -e "$COLOR_PATH/trigger" ] ; then
			busybox echo "none" >"$COLOR_PATH/trigger"
		fi
	fi
}
SET_LED_DELAY_ON()
{
	local DELAY="$1"
	local COLOR_PATH="$2"
	# if no delay is set default to 250ms
	if [ "$DELAY" = "" ] ; then
		local DELAY="250"
	fi
	# if no color is set default to both
	if [ "$COLOR_PATH" = "" ] ; then
		if [ -e "$RED_PATH/delay_on" ] ; then
			busybox echo $DELAY >"$RED_PATH/delay_on"
		fi
		if [ -e "$BLUE_PATH/delay_on" ] ; then
			busybox echo $DELAY >"$BLUE_PATH/delay_on"
		fi
	else
		if [ -e "$COLOR_PATH/delay_on" ] ; then
			busybox echo $DELAY >"$COLOR_PATH/delay_on"
		fi
	fi
}
SET_LED_DELAY_OFF()
{
	local DELAY="$1"
	local COLOR_PATH="$2"
	# if no delay is set default to 250ms
	if [ "$DELAY" = "" ] ; then
		local DELAY="250"
	fi
	# if no color is set default to both
	if [ "$COLOR_PATH" = "" ] ; then
		if [ -e "$RED_PATH/delay_off" ] ; then
			busybox echo $DELAY >"$RED_PATH/delay_off"
		fi
		if [ -e "$BLUE_PATH/delay_off" ] ; then
			busybox echo $DELAY >"$BLUE_PATH/delay_off"
		fi
	else
		if [ -e "$COLOR_PATH/delay_off" ] ; then
			busybox echo $DELAY >"$COLOR_PATH/delay_off"
		fi
	fi
}

#main
case "$ARG" in
	start)
		SET_LED_TRIGGER_TIMER
		SET_LED_DELAY_OFF "200" "$RED_PATH"
		SET_LED_DELAY_OFF "100" "$BLUE_PATH"
		SET_LED_DELAY_ON "200" "$RED_PATH"
		SET_LED_DELAY_ON "100" $BLUE_PATH
		;;
	stop)
		SET_LED_TRIGGER_NONE
		;;
	*)
		echo "Usage: $0 <start|stop>" ;;
esac

