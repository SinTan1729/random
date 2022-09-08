#!/bin/sh

# this is a script to automatically connect to ethernet on boot

[ $(nmcli connect show --active | grep "ethernet\|wifi" | wc -l) == "0" ] && nmcli connect up "pi/3"

