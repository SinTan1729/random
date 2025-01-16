#!/usr/bin/env bash

# Toggles DND
 
dnd=$(pgrep DND.py)
if [[ $dnd ]];
then
    kill $dnd
    pactl set-sink-mute @DEFAULT_SINK@ false
else
	/home/sintan/.local/bin/personal/DND.py &
    pactl set-sink-mute @DEFAULT_SINK@ true
fi
