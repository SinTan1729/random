#!/bin/sh

# This is a script to set my external monitor's brightness
# to high (70%) or low (40%) easily. It uses ddcutil to access
# the monitor's settings. When used in conjunction with heliocron,
# it can manage the monitor brightness based on sunrise or sunset,
# which can be useful if you like to work in natural light.

if [ $1 == "high" ]; then
    ddcutil setvcp 10 70 && echo "Monitor brightness set to 70%"
elif [ $1 == "low" ]; then
    ddcutil setvcp 10 40 && echo "Monitor brightness set to 40%"
else
    echo "Please pass high/low"
fi
