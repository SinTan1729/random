#!/bin/sh

# Steps for setting up the drivers of Huion Inspiroy H640P

# git clone https://github.com/Huion-Linux/DIGImend-kernel-drivers-for-Huion
# cd DIGImend-kernel-drivers-for-Huion
# sed -i 's/SUBDIRS=/M=/' Makefile (only for arch or related)
# sudo make dkms_install

# Make /etc/udev/rules.d/00-usb-huion.rules with this content (to run it whenever the tabler is conencted):
# ACTION=="add", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="006d", ENV{XAUTHORITY}="/home/sintan/.Xauthority", ENV{DISPLAY}=":0", OWNER=<user>, RUN+="/usr/local/bin/huion-tablet-mount"

# Make /usr/local/bin/huion-tablet-mount with this content :
# #!/bin/sh
# <location-of-this-script> & exit

# Make sure to install xf86-input-wacom (might have to restart)
# Add this script to autostart of your DE or .profile or somehow make it run at boot (so that it works in case the tablet is connected at boot)

if [ $(xsetwacom --list | grep -c "HID 256c:006d") -ne "2" ]; then
	echo "No supported devices found!"
	exit
fi

sleep 1

xsetwacom --set 'HID 256c:006d Pen stylus' Button 2 "2" # middle mouse button
xsetwacom --set 'HID 256c:006d Pen stylus' Button 3 "3" # right mouse button
xsetwacom --set 'HID 256c:006d Pad pad' Button 1 "key +ctrl +s -s -ctrl" # save
xsetwacom --set 'HID 256c:006d Pad pad' Button 2 "key +alt +c -c -alt" # cycle colors in xournal++
xsetwacom --set 'HID 256c:006d Pad pad' Button 3 "4" # scroll up
xsetwacom --set 'HID 256c:006d Pad pad' Button 8 "5" # scroll down
xsetwacom --set 'HID 256c:006d Pad pad' Button 9 "key +ctrl +z -z -ctrl" # undo
xsetwacom --set 'HID 256c:006d Pad pad' Button 10 "key +ctrl +y -y -ctrl" # redo
