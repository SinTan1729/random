#!/usr/bin/env bash

# For backing up files with OneDrive, from my server.
# Assumes that the backup target is set up as encrypted-onedrive in rclone.
# I usually run it once a week by a cronjob.

# force script to run as specific user
if [ "$(id -u)" -eq 0 ]; then
    exec sudo -H -u sintan $0 "$@"
fi

# Exit the whole script when ctrl+c is pressed
set -e

# Run only one instance of this script at one time
[ "${BKLOCKER}" != "running" ] && exec env BKLOCKER="running" flock -en "/tmp/onedrivebk.lock" "$0" "$@" || :

# List of backups

LOGFILE="/home/sintan/TempStorage/OneDriveBk.log"

echo "Starting Backup at $(date)" | tee -a $LOGFILE
echo "-----------------------------"$'\n' | tee -a $LOGFILE

echo "Syncing Pictures..." | tee -a $LOGFILE
echo "-----------------------------"$'\n' | tee -a $LOGFILE
rclone -v --fast-list --size-only --links --bwlimit 4M sync "/home/sintan/Pictures" encrypted-onedrive:"Pictures" |& tee -a $LOGFILE

echo "Syncing Videos..." | tee -a $LOGFILE
echo "-----------------------------"$'\n' | tee -a $LOGFILE
rclone -v --fast-list --size-only --links --bwlimit 4M sync "/home/sintan/Videos" encrypted-onedrive:"Videos" |& tee -a $LOGFILE

echo "Syncing Academics..." | tee -a $LOGFILE
echo "-----------------------------"$'\n' | tee -a $LOGFILE
rclone -v --fast-list --size-only --links --bwlimit 4M sync --exclude=".stversions/**" "/mnt/storage/Academics" encrypted-onedrive:"Academics" |& tee -a $LOGFILE

echo "Syncing Zotero..." | tee -a $LOGFILE
echo "-----------------------------"$'\n' | tee -a $LOGFILE
rclone -v --fast-list --size-only --links --bwlimit 4M sync "/mnt/storage/Zotero" encrypted-onedrive:"Zotero" |& tee -a $LOGFILE

echo "Syncing Music..." | tee -a $LOGFILE
echo "-----------------------------"$'\n' | tee -a $LOGFILE
rclone -v --fast-list --size-only --links --bwlimit 4M sync "/mnt/storage/Music" encrypted-onedrive:"Music" |& tee -a $LOGFILE

echo "Syncing Documents..." | tee -a $LOGFILE
echo "-----------------------------"$'\n' | tee -a $LOGFILE
rclone -v --fast-list --size-only --links --bwlimit 4M sync --exclude=".stversions/**" --exclude="/CalibreLibrary/**" \
    "/mnt/storage/Documents" encrypted-onedrive:"Documents" |& tee -a $LOGFILE

echo "Syncing dotfiles..." | tee -a $LOGFILE
echo "-----------------------------"$'\n' | tee -a $LOGFILE
rclone -v --fast-list --size-only --links --exclude="**/menus/**" --exclude="**/unity3d/**" \
    --exclude="**/libreoffice/**" --ignore-errors --bwlimit 4M sync "/mnt/storage/dotfiles" encrypted-onedrive:"dotfiles" |& tee -a $LOGFILE

echo "Syncing DCIM..." | tee -a $LOGFILE
echo "-----------------------------"$'\n' | tee -a $LOGFILE
rclone -v --fast-list --size-only --links --bwlimit 4M --exclude="**/.stfolders/**" \
    --exclude="**/.trashed**" --delete-excluded sync "/home/sintan/TempStorage/DCIM" encrypted-onedrive:"DCIM" |& tee -a $LOGFILE

echo "Syncing Programs..." | tee -a $LOGFILE
echo "-----------------------------"$'\n' | tee -a $LOGFILE
rclone -v --fast-list --size-only --links --bwlimit 4M --exclude="*-config/**" sync "/mnt/storage/Programs" \
    encrypted-onedrive:"Programs" |& tee -a $LOGFILE

echo "Syncing Code..." | tee -a $LOGFILE
echo "-----------------------------"$'\n' | tee -a $LOGFILE
rclone -v --fast-list --size-only --links --bwlimit 4M --exclude="**/.git/**" --exclude="**/.venv/**" \
    sync "/mnt/storage/Code" encrypted-onedrive:"Code" |& tee -a $LOGFILE

echo "Done at $(date)" | tee -a $LOGFILE
echo $'\n'"-----------------------------" | tee -a $LOGFILE
echo "-----------------------------" | tee -a $LOGFILE

