#!/bin/sh

# this is a script to backup crontab data
# put this inside /etc/cron.daily

# define location for output
DIR=/home/sintan/Documents/Backup/pkglists

# make sure that the folder exists
mkdir -p $DIR

ls /etc/cron.hourly/ /etc/cron.daily/ /etc/cron.weekly/ /etc/cron.monthly/ > $DIR/crontab
echo "-----------------" >> $DIR/crontab
crontab -l >> $DIR/crontab
