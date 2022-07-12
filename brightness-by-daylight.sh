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

# Just run this script one manually to set it up to run perpetually (hopefully) using 'at'
# (Some distros don't come with 'at' preinstalled, so you might need to install 'at' and enable the 'atd' service.)

# It might also be a good idea to add this script's location to your DE's autostart list, or to '.profile' so that it launches on system login
# (Sometimes I forget to turn on the monitor when I start my PC, so this is better than having a crontab)

confdir="/home/sintan/.config"

if test -f $confdir/latlong.toml ; then
    source $confdir/latlong.toml
else
    echo "No location config found!"
    exit
fi

# Check if called by crontab as routine. If yes, create a schedule using `at`,
# otherwise adjust brightness immediately

if [ "$1" == "crontab" ]; then
    if [ $(sunwait poll $latitude $longitude) == "DAY" ]; then
        # +1 minute is so that the next schedule is set up properly (or sunwait reports day/night in a misleading way)
        at -m $(sunwait report 35.221050N 97.445938W | grep "Daylight:" | awk '{print $6}') +1 minute <<< "ddcutil setvcp 10 40 && $scriptdir/brightness-by-daylight.sh crontab"
    else
        at -m $(sunwait report 35.221050N 97.445938W | grep "Daylight:" | awk '{print $4}') +1 minute <<< "ddcutil setvcp 10 70 && $scriptdir/brightness-by-daylight.sh crontab"
    fi
else
    if [ $(sunwait poll $latitude $longitude) == "DAY" ]; then
        ddcutil setvcp 10 70
        echo "Monitor brightness set to 70%, since it's day time."
    else
        ddcutil setvcp 10 40
        echo "Monitor brightness set to 40%, since it's night time."
    fi
fi