#!/bin/sh

# this is a script to set my external monitor's brightness
# to high (70%) or low (40%) automatically according to day/night.
# it uses ddcutil to access the monitor's settings and sunwait to know
# if it's day or night. It expects a file in the following format in
# the .config directory (the values should be according to location)

# ~/.config/latlong.toml
# latitude="0.000000N"
# longitude="0.000000E"
# scriptdir=<location-of-this-script>
# high=70
# low=40

# just run this script one manually to set it up to run perpetually (hopefully) using 'at'
# (some distros don't come with 'at' preinstalled, so you might need to install 'at' and enable the 'atd' service.)

# it might also be a good idea to add '<location-of-this-script> scheduler wait' to your DE's autostart list, or to '.profile' so that it launches on system login
# (sometimes I forget to turn on the monitor when I start my PC, so this is better than having a crontab)

# location of the config file
confdir="/home/sintan/.config"

# read from the config file
if test -f $confdir/latlong.toml ; then
    source $confdir/latlong.toml
else
    echo "No location config found!"
    exit
fi

# get sun status
sun_status=$(sunwait poll $latitude $longitude)
[ $sun_status == "DAY" ] && target=$high || target=$low

# do the brightness adjustment using ddcutil
ddcutil setvcp 10 $target
echo "Monitor brightness set to $target%, since it's $(echo $sun_status | tr '[:upper:]' '[:lower:]') time"

# check if we want to access the scheduler. If yes, create a schedule using `at`
if [ "$1" == "scheduler" ]; then
    if [ $sun_status == "DAY" ]; then
        time_next=$(sunwait report 35.221050N 97.445938W | grep "Daylight:" | awk '{print $6}')
    else
        time_next=$(sunwait report 35.221050N 97.445938W | grep "Daylight:" | awk '{print $4}')
    fi
    task_list=$(atq | grep $time_next | awk '{print $1}')

    # loop through all `at` entries to see if a task already exists
    flag=true
    for item in $task_list
    do
        [ "$(at -c $item | sed 'x;$!d')" == "$scriptdir/brightness-by-daylight.sh scheduler wait" ] && flag=false
    done

    # sometimes we need to wait a minute so that the next schedule is set up properly (or sunwait reports day/night in a misleading way)
    [ "$2" == "wait" ] && sleep 60

    # actually create the schedule
    $flag && at -m $time_next <<< "$scriptdir/brightness-by-daylight.sh scheduler wait"
fi