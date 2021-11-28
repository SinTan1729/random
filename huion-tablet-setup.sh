#!/bin/bash

# Steps for setting up the drivers of Huion Inspiroy H640P

# git clone https://github.com/Huion-Linux/DIGImend-kernel-drivers-for-Huion
# cd DIGImend-kernel-drivers-for-Huion
# sed -i 's/SUBDIRS=/M=/' Makefile
# sudo make dkms_install

# Make /etc/udev/rules.d/00-usb-huion.rules with this content (to run it whenever the tabler is conencted):
# ACTION=="add", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="006d", ENV{XAUTHORITY}="/home/<user>/.Xauthority", ENV{DISPLAY}=":0", OWNER=<user>, RUN+="/usr/local/bin/huion-tablet-mount"

# Make /usr/local/bin/huion-tablet-mount with this content :
# #!/bin/bash
# <location-of-this-script> & exit

# Make sure to install xf86-input-wacom (might have to restart)
# Add this script to autostart

sleep 1

xsetwacom --set 'HID 256c:006d Pen stylus' Button 2 "1"
xsetwacom --set 'HID 256c:006d Pen stylus' Button 3 "3"
xsetwacom --set 'HID 256c:006d Pad pad' Button 1 "key +ctrl +s -s -ctrl"
xsetwacom --set 'HID 256c:006d Pad pad' Button 2 "key +ctrl +e -e -ctrl"
xsetwacom --set 'HID 256c:006d Pad pad' Button 3 "4"
xsetwacom --set 'HID 256c:006d Pad pad' Button 8 "5"
xsetwacom --set 'HID 256c:006d Pad pad' Button 9 "key +ctrl +z -z -ctrl"
xsetwacom --set 'HID 256c:006d Pad pad' Button 10 "key +ctrl +y -y -ctrl"
