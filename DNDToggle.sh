#!/usr/bin/env bash

# Toggles DND
 
dnd=$(pgrep DND.py)
if [[ $dnd ]];
then
    kill $dnd
else
	/home/sintan/.local/bin/personal/DND.py &
fi
