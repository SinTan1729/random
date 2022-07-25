#!/bin/sh

# This is a script to set my external monitor's brightness
# to high (70%) or low (40%) automatically according to day/night.
# It uses ddcutil to access the monitor's settings and sunwait to know
# if it's day or night. It expects a file in the following format in
# the .config directory (the values should be according to location)

# ~/.config/latlong.toml
# latitude="0.000000N"
# longitude="0.000000E"
# scriptdir=<location-of-this-script>
# high=70
# low=40

# Just run this script one manually to set it up to run perpetually (hopefully) using 'at'
# (Some distros don't come with 'at' preinstalled, so you might need to install 'at' and enable the 'atd' service.)

# It might also be a good idea to add '<location-of-this-script> scheduler' to your DE's autostart list, or to '.profile' so that it launches on system login
# (Sometimes I forget to turn on the monitor when I start my PC, so this is better than having a crontab)

confdir="/home/sintan/.config"

if test -f $confdir/latlong.toml ; then
    source $confdir/latlong.toml
else
    echo "No location config found!"
    exit
fi

sun_status=$(sunwait poll $latitude $longitude)

if [ $sun_status == "DAY" ]; then
        target=$high
    else
        target=$low
    fi

ddcutil setvcp 10 $target
echo "Monitor brightness set to $target%, since it's $(echo $sun_status | tr '[:upper:]' '[:lower:]') time"

# Check if we want to access the scheduler. If yes, create a schedule using `at`

if [ "$1" == "scheduler" ]; then
    if [ $sun_status == "DAY" ]; then
        time_next=$(sunwait report 35.221050N 97.445938W | grep "Daylight:" | awk '{print $6}')
    else
        time_next=$(sunwait report 35.221050N 97.445938W | grep "Daylight:" | awk '{print $4}')
    fi
    task_list=$(atq | grep $time_next | awk '{print $1}')

    for item in $task_list
    do
        if ! [ $(at -c $item | sed 'x;$!d' | awk '{print $4}') == "$scriptdir/brightness-by-daylight.sh" ]; then
            # we wait a minute so that the next schedule is set up properly (or sunwait reports day/night in a misleading way)
            at -m $time_next <<< "sleep 60 && $scriptdir/brightness-by-daylight.sh scheduler"
        fi
    done

    if [ -z "$task_list" ]; then # in case there's no at entry
        at -m $time_next <<< "sleep 60 && $scriptdir/brightness-by-daylight.sh scheduler"
    fi
fi