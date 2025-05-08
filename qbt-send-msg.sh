#!/bin/bash

# A very simple script to send message using ntfy.sh whenever a torrent is added/completed
# in qBittorrent. Just call the script from qBittorrent's external script option
# using <script> "%N" "%Z" fin "%L" "%F"

name="$1"
size="$2"
status="$3"
category="$4"
path="$5"

if [ "$status" == "add" ]; then
    message="Added: $name"
elif [ "$status" == "fin" ]; then
    size="$(echo $size | numfmt --to=iec --format %.2f)B"
    message="Finished: [$size] $name"
    if [ "$category" == "movie" ]; then
        cp -lR "$path" /downloads/Temp/movie/
    fi
else
   exit
fi

curl -H "Icon: https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/New_qBittorrent_Logo.svg/240px-New_qBittorrent_Logo.svg.png" \
     -u :tk_8tdkqzsjaauqnngy9bc33wcuh3xq6 \
     -H "Title: qBittorrent" \
     -H "Priority: low" \
     -d "$message" \
     https://ntfy.sintan1729.uk/qbittorrent

