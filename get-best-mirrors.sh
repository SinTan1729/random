#!/bin/env bash

# This is a simple script to fetch and update Arch and EndeavourOS mirrors
# using rate-mirrors.
# Syntax get-best-mirrors.sh <arch|eos|both> (nothing means both)
# I run it weekly using anacron.

update_arch() {
    # Create temporary file to output to
    TMPFILE_ARCH="$(mktemp)"

    # Rank Arch mirrors
    echo "===================================================================================================="
    echo "Ranking Arch mirrors"
    echo "===================================================================================================="

    rate-mirrors --protocol=https --save=$TMPFILE_ARCH arch

    # Create backup directory if not present already
    sudo mkdir -p /etc/pacman.d/mirrorlist-backup

    # Place the new mirrorlist and do a backup
    sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup/mirrorlist.$TIME
    sudo mv $TMPFILE_ARCH /etc/pacman.d/mirrorlist
}

update_eos() {
    # Create temporary file to output to
    TMPFILE_EOS="$(mktemp)"

    # Rank EndeavourOS mirrors
    echo $'\n'"===================================================================================================="
    echo "Ranking EndeavourOS mirrors"
    echo "===================================================================================================="

    rate-mirrors --protocol=https --save=$TMPFILE_EOS endeavouros

    # Create backup directory if not present already
    sudo mkdir -p /etc/pacman.d/mirrorlist-backup

    # Place the new mirrorlist and do a backup
    sudo mv /etc/pacman.d/endeavouros-mirrorlist /etc/pacman.d/mirrorlist-backup/endeavouros-mirrorlist.$TIME
    sudo mv $TMPFILE_EOS /etc/pacman.d/endeavouros-mirrorlist

    # Remove files created by eos-rankmirror, if any
    sudo find /etc/pacman.d/ -maxdepth 1 -type f -name "endeavouros-mirrorlist\.*" -exec rm -v {} \;
}

# Get the current time
TIME="$(date '+%Y.%m.%d-%H.%M.%S')"

if [ "$1" == "arch" ]; then
    update_arch
elif [ "$1" == "eos" ]; then
    update_eos
else
    update_arch
    update_eos
fi

# Do some cleanup, keep only the last 3 backups
echo $'\n'"===================================================================================================="
echo "Cleaning up old backups to keep only the latest 3"

find /etc/pacman.d/mirrorlist-backup/ -maxdepth 1 -type f -name "mirrorlist\.[[:digit:]]*" -printf '%Ts\t%P\n' |
    sort -rn |
    tail -n +4 |
    cut -f2- |
    sudo xargs -r -I {} rm -v "/etc/pacman.d/mirrorlist-backup/{}"
find /etc/pacman.d/mirrorlist-backup/ -maxdepth 1 -type f -name "endeavouros-mirrorlist\.[[:digit:]]*" -printf '%Ts\t%P\n' |
    sort -rn |
    tail -n +4 |
    cut -f2- |
    sudo xargs -r -I {} rm -v "/etc/pacman.d/mirrorlist-backup/{}"

echo "Done!"
