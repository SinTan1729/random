#!/bin/sh

# This is to update all apps installed on my server using lure
# The regular upgrade function of lure doesn't suffice since
# I use automatically updating version names in my install scripts

GREEN='\033[0;32m'
NC='\033[0m'

! command -v lure>/dev/null && echo "lure is not installed" && exit
! [ -f "$1" ] && echo "Please pass location of a list with github repo names" && exit

lure_list=$(lure list --installed 2>/dev/null | grep -v 'INF')

for f in $(cat "$1" | tr '\n' ' ')
do
	pkg="$(echo $f | cut -d '/' -f 2)"
	version_new=$(lure info $pkg 2>/dev/null | grep version | awk '{printf $2}' | sed 's/[a-zA-Z]*//g')
	[ "$version_new" == "" ] && version_new="$(curl -sL "https://api.github.com/repos/${f}/releases/latest" | jq -r '.tag_name' | sed 's/[a-zA-Z]*//g')"
	version_present=$(echo "$lure_list" | grep $pkg | cut -d' ' -f2 | cut -d- -f1 | sed 's/[a-zA-Z]*//g')
	[ "$version_present" == "" ] && echo "$pkg isn't installed, skipping" && continue
	if [ $(echo $version_present$'\n'$version_new | sort -V | tail -n1) != $version_present ]; then
		echo "Upgrading $pkg ($version_present -> $version_new)"
		lure install $pkg
	else
		echo -e "$pkg is ${GREEN}up-to-date${NC}"
	fi
done
