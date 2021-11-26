#!/bin/sh

# Steps for setting up the drivers of Huion Inspiroy H640P

# git clone https://github.com/Huion-Linux/DIGImend-kernel-drivers-for-Huion
# cd DIGImend-kernel-drivers-for-Huion
# sed -i 's/SUBDIRS=/M=/' Makefile
# sudo make dkms_install

# Make sure to install xf86-input-wacom (might have to restart)
# Add this script to autostart

xsetwacom --set 'HID 256c:006d Pen stylus' Button 2 "1"
xsetwacom --set 'HID 256c:006d Pen stylus' Button 3 "3"
xsetwacom --set 'HID 256c:006d Pad pad' Button 1 "1"
xsetwacom --set 'HID 256c:006d Pad pad' Button 2 "3"
xsetwacom --set 'HID 256c:006d Pad pad' Button 3 "4"
xsetwacom --set 'HID 256c:006d Pad pad' Button 8 "5"
xsetwacom --set 'HID 256c:006d Pad pad' Button 9 "key +ctrl +z -z -ctrl"
xsetwacom --set 'HID 256c:006d Pad pad' Button 10 "key +ctrl +y -y -ctrl"
