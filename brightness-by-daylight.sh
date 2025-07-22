#!/bin/bash

# this is a script to set my external monitor's brightness
# to high (70% is my personal preference) or low (40% is my personal preference)
# automatically according to day/night.
# it uses ddcutil to access the monitor's settings and sunwait to know
# if it's day or night. It expects a file in the following format in
# the .config directory (the values should be according to location)

## ~/.config/brightness-by-daylight.conf
## Setup for brightness-by-daylight.sh
# latitude="0.000000N"
# longitude="0.000000E"
# scriptdir=<location-of-this-script>
# high=70
# low=40

# just run this script one manually to set it up to run perpetually (hopefully) using 'at'
# (some distros don't come with 'at' preinstalled, so you might need to install 'at' and enable the 'atd' service.)

# it might also be a good idea to add '<location-of-this-script> scheduler' to your DE's autostart list, or to '.profile' so that it launches on system login
# (sometimes I forget to turn on the monitor when I start my PC, so this is better than having a crontab)

# avoid running two concurrent processes
[ "${BRTNESSLOCKER}" != "running" ] && exec env BRTNESSLOCKER="running" flock -en "/tmp/brightness-by-daylight.lock" "$0" "$@" || :

# set location of the config file
[ -z "$XDG_CONFIG_HOME" ] && confdir="$HOME/.config" || confdir="$XDG_CONFIG_HOME"

# read from the config file
if [ -f $confdir/brightness-by-daylight.conf ]; then
    source $confdir/brightness-by-daylight.conf
else
    echo "No config file found!"
    echo "It should be located at [config-dir]/brightness-by-daylight.conf"
    exit
fi

# get sun status
sun_status=$(sunwait poll $latitude $longitude)

# check if we want to access the scheduler. If yes, create a schedule using `at`
if [ "$1" == "scheduler" ]; then
    # get the timings for twilight events and current time
    sunrise_time=$(sunwait report 35.221050N 97.445938W | grep "Daylight:" | awk '{print $4}')
    sunset_time=$(sunwait report 35.221050N 97.445938W | grep "Daylight:" | awk '{print $6}')
    now_time=$(date "+%H:%M")

    # try to figure out if it's twilight right now, then need to adjust sun_status
    [ $sunrise_time == $now_time ] && sun_status="DAY"
    [ $sunset_time == $now_time ] && sun_status="NIGHT"

    # figure out the time of the next twilight
    [ $sun_status == "DAY" ] && time_next=$sunset_time || time_next=$sunrise_time

    # query all `at` tasks
    task_list=$(atq | grep $time_next | awk '{print $1}')

    # loop through all `at` entries to see if a task already exists
    flag=true
    for item in $task_list; do
        [ "$(at -c $item | sed 'x;$!d')" == "$scriptdir/brightness-by-daylight.sh scheduler" ] && flag=false
    done

    # create the schedule
    $flag && at -m $time_next <<<"$scriptdir/brightness-by-daylight.sh scheduler"
fi

# do the brightness adjustment using ddcutil
[ $sun_status == "DAY" ] && target=$high || target=$low
qdbus6 org.kde.Solid.PowerManagement /org/kde/Solid/PowerManagement/Actions/BrightnessControl \
    org.kde.Solid.PowerManagement.Actions.BrightnessControl.setBrightness $(( $target * 100 ))
echo "Monitor brightness set to $target%, since it's $(echo $sun_status | tr '[:upper:]' '[:lower:]') time"
DISPLAY=:0 XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send -i brightness -a "Brightness by Daylight" "Brightness was set to $target%."
