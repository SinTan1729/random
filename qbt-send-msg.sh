#!/bin/bash

# A very simple script to send message using ntfy.sh whenever a torrent is added/completed
# in qBittorrent. Just call the script from qBittorrent's external script option
# using <script> "%N" "%Z" (add/fin)
# It also adds trackers using https://github.com/Jorman/Scripts/blob/master/AddqBittorrentTrackers.sh

name="$1"

if [ "$3" == "add" ]; then
    message="Added: $name"
elif [ "$3" == "fin" ]; then
    size="$(echo $2 | numfmt --to=iec --format %.2f)B"
    message="Finished: [$size] $name"
else
   exit
fi

curl -H "Icon: https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/New_qBittorrent_Logo.svg/240px-New_qBittorrent_Logo.svg.png" \
     -H "Title: qBittorrent" \
     -H "Priority: low" \
     -d "$message" \
     https://ntfy.sh/topic-name
