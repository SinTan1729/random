#!/bin/sh

# this is a script to push scripts from the folder with git
# to actual locations where I use them

if [ -z "$1" ]; then
    echo "Provide a script or pass --help to see syntax"
    exit

elif [ "$1" == "--help" ];then
    echo "The syntax is as follows:"$'\n'"push_script_to <script-location> <destination> (additional destinations separated by space)"
    exit

elif ! [ -f "$1" ]; then
    echo "The given script doesn't exist"
    exit
fi

[ -z "$2" ] && echo "Provide destination(s) or pass --help to see syntax" && exit

for i in "${@:2}"
do
    if [ "$i" == "personal_script_dir" ]; then
        cp "$1" "/home/sintan/.local/bin/personal/"
        chmod +x "/home/sintan/.local/bin/personal/$(basename "$1")"

    elif [ "$i" == "cron_daily" ]; then
        sudo cp "$1" "/etc/cron.daily/"
        sudo chmod +x "/etc/cron.daily/$(basename "$1")"
        
    elif [ "$i" == "cron_weekly" ]; then
        sudo cp "$1" "/etc/cron.weekly/"
        sudo chmod +x "/etc/cron.weekly/$(basename "$1")"

    elif [ "$i" == "cron_monthly" ]; then
        sudo cp "$1" "/etc/cron.monthly/"
        sudo chmod +x "/etc/cron.monthly/$(basename "$1")"

    else echo "Unrecognized destination: $i"
    fi
done