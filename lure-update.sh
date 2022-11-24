#!/bin/sh

# This is to update all apps installed on my server using lure
# The regular upgrade function of lure doesn't suffice since
# I use automatically updating version names in my install scripts

[ -f "$1" ] || echo "Please pass location of a list with github repo names"

for f in $(cat "$1" | tr '\n' ' ')
do
	pkg="$(echo $f | cut -d '/' -f 2)"
	version_new=$(lure info $pkg | grep version | awk '{printf $2}' | sed 's/[a-zA-Z]*//g')
	[ "$version_new" == "" ] && version_new="$(curl -sL "https://api.github.com/repos/${f}/releases/latest" | jq -r '.tag_name' | sed 's/[a-zA-Z]*//g')"
	version_present="$(dnf info $pkg 2>/dev/null | grep Version | awk '{printf $3}' | sed 's/[a-zA-Z]*//g')"
	[ "$version_present" == "" ] && echo "$pkg isn't installed, skipping" && continue
	if [ $(echo $version_present$'\n'$version_new | sort -V | tail -n1) != $version_present ]; then
		echo "Upgrading $pkg"
		lure install $pkg
	else
		echo "$pkg is up-to-date"
	fi
done
