#!/bin/bash

# A very simple script to send message using Gotify whenever a torrent is added/completed
# in qBittorrent. Just call the script from qBittorrent's external script option
# using <script> "%N" "%Z" (add/fin)

name="$1"
size="$(echo $2 | numfmt --to=iec --format %.2f)B"
url="https://example.com/message?token=<token>"

if [ "$3" == "add" ]; then
    curl -X POST "$url" -F "title=qBittorrent" -F "message=The torrent '$name' has been added." -F "priority=4"
elif [ "$3" == "fin" ]; then
    size="$(echo $2 | numfmt --to=iec --format %.2f)B"
    curl -X POST "$url" -F "title=qBittorrent" -F "message=The torrent '$name' ($size) has finished downloading."
fi
