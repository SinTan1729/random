#!/bin/sh

# This is a script to set my external monitor's brightness
# to high (70%) or low (40%) automatically according to day/night.
# It uses ddcutil to access the monitor's settings and sunwait to know
# if it's day or night. It expects a file in the following format in
# the .config directory (the values should be according to location)

# ~/.config/latlong.toml
# latitude="0.000000N"
# longitude="0.000000E"

# Add the following to crontab to make it run automatically and properly

# @reboot <location-of-this-script> crontab
# 0 0,12 * * * <location-of-this-script> crontab

# It might also be a good idea to add this script's location to your DE's autostart list, or to '.profile' so that it launches on system login

# To run this script whenever and HDMI cable is connected, copy this file to /usr/local/bin/ and run 'chmod +x /usr/local/bin/brightness-by-daylight.sh'
# Then create the file /etc/udev/rules.d/89-hdmi_brightness.rules with the following content :
# KERNEL=="card0", SUBSYSTEM=="drm", ACTION=="add", RUN+="/usr/local/bin/brightness-by-daylight.sh"
# Then run 'udevadm control --reload-rules' and reboot

confdir="/home/sintan/.config"

if test -f $confdir/latlong.toml ; then
    source $confdir/latlong.toml
else
    echo "No location config found!"
    exit
fi

# Check if called by crontab as routine. If yes, start waiting,
# otherwise adjust brightness immediately

if [ "$1" == "crontab" ]; then
    if test -f /tmp/brightness-crontab; then
        exit
    else
        if [ $(sunwait poll $latitude $longitude) == "DAY" ]; then
            echo "Waiting for sunset at" $(sunwait report 35.221050N 97.445938W | grep "Daylight:" | awk '{print $6}') > /tmp/brightness-crontab
            sunwait wait set offset 10 $latitude $longitude && ddcutil setvcp 10 40
        else
            echo "Waiting for sunrise at" $(sunwait report 35.221050N 97.445938W | grep "Daylight:" | awk '{print $4}') > /tmp/brightness-crontab
            sunwait wait rise offset 10 $latitude $longitude && ddcutil setvcp 10 70
        fi
        rm /tmp/brightness-crontab
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