#!/bin/bash

# this is a script to push scripts from the folder with git
# to actual locations where I use them

if [ -z "$1" ]; then
    echo "Provide a script or pass --help to see syntax"
    exit

elif [ "$1" == "--help" ]; then
    echo "The syntax is as follows:"$'\n'"push_script_to <script-location> <destination> (additional destinations separated by space)"
    exit

elif ! [ -f "$1" ]; then
    echo "The given script doesn't exist"
    exit
fi

[ -z "$2" ] && echo "Provide destination(s) or pass --help to see syntax" && exit

for i in "${@:2}"; do
    if [ "$i" == "personal_script_dir" ]; then
        dest="$HOME/.local/bin/personal/"
        echo Copying to "$dest"...
        cp "$1" "$dest"
        echo Making it executable...
        chmod +x "$dest$(basename "$1")"

    elif [ "$i" == "cron_daily" ]; then
        dest="/etc/cron.daily/"
        echo Copying to "$dest"...
        sudo cp "$1" "$dest"
        echo Making it executable...
        sudo chmod +x "$dest$(basename "$1")"

    elif [ "$i" == "cron_weekly" ]; then
        dest="/etc/cron.weekly/"
        echo Copying to "$dest"...
        sudo cp "$1" "$dest"
        echo Making it executable...
        sudo chmod +x "$dest$(basename "$1")"

    elif [ "$i" == "cron_monthly" ]; then
        dest="/etc/cron.monthly/"
        echo Copying to "$dest"...
        sudo cp "$1" "$dest"
        echo Making it executable...
        sudo chmod +x "$dest$(basename "$1")"

    elif [ "$i" == "root_scripts" ]; then
        dest="/usr/local/bin/"
        echo Copying to "$dest"...
        sudo cp "$1" "$dest"
        echo Making it executable...
        sudo chmod +x "$dest$(basename "$1")"

    else
        echo "Unrecognized destination: $i"
        echo "Available destinations are: personal_script_dir, cron_daily, cron_weekly, cron_monthly, root_scripts"
    fi
done
