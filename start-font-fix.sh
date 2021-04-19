# This was to fix an issue I was having where my terminal fonts were all over the place and tlp was autosuspending usb ports at startup.
# Anyone else probably won't need it.

#! /bin/sh

source ~/.profile
sudo ~/.local/bin/personal/usb-autosuspend-fix
