#!/bin/env bash

# This is a script to update packages on AUR and LURE
# after I publish them.

# Syntax: update-aur-lure.sh <package-name> <new-version>

if [ "$#" -ne 2 ]; then
    echo "Invalid syntax!"
    echo "Use the following syntax: update-aur-lure.sh <package-name> <new-version>"
    exit -1
fi

# GITDIR env variable should be set for this to work
[ -z $GITDIR ] && exit -1
VERS="$2"

# Do the updates for AUR
echo "Updating AUR..."
cd "$GITDIR/AUR"
[ -d "$1" ] && PKG="$1" || PKG="$1-bin"

cd "$PKG"
sed -i -E "s/pkgver=[0-9\.]+/pkgver=$VERS/" PKGBUILD
updpkgsums
makepkg --printsrcinfo >.SRCINFO

# Remove downloaded files
ls | grep -v PKGBUILD | xargs -r -I {} rm "{}"
git add .
git commit -m "Bumped $PKG version to $VERS"
git push

# Update the GitHub backup repo as well
echo "Updating AUR backup repo..."
cd "$GITDIR/AUR Mirror GitHub/$PKG"
sed -i -E "s/pkgver=[0-9\.]+/pkgver=$VERS/" PKGBUILD
git add .
git commit -m "Bumped $PKG version to $VERS"
git push

# Do the updates for LURE
echo "Updating LURE repo..."
cd "$GITDIR/lure-repo"
[ -d "$1" ] && PKG="$1" || PKG="$1-bin"
cd "$PKG"
sed -i -E "s/version=[0-9\.]+/version=$VERS/" lure.sh
update-lure-checksums.py

# Remove downloaded files
ls | grep -v lure.sh | xargs -r -I {} rm "{}"
git add .
git commit -m "Bumped $PKG version to $VERS"
git push

echo "Done!"
