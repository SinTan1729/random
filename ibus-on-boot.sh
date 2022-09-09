#!/bin/sh

# this is a script to start the ibus-daemon on startup
# set it up to run automatically on startup somehow

export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
sleep 10
ibus-daemon -drxR
