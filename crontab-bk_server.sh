#!/bin/sh

# this is a script to backup crontab data
# This is the version for my home server

# put this inside /etc/cron.daily

# define location for output
DIR=/mnt/storage/Documents/Backup/pkglists_server

# make sure that the folder exists
mkdir -p $DIR

ls /etc/cron.hourly/ /etc/cron.daily/ /etc/cron.weekly/ /etc/cron.monthly/ > $DIR/crontab
echo "-----------------" >> $DIR/crontab
find /var/spool/cron/ -type f -exec sh -c "echo {} && cat {} && echo ---" \; >> $DIR/crontab
