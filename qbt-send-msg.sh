#!/bin/bash

# A very simple script to send message using telegram.sh whenever a torrent is added/completed
# in qBittorrent. Just call the script from qBittorrent's external script option
# using <script> "%N" "%Z" (add/fin)

name="$1"
size="$(echo $2 | numfmt --to=iec --format %.2f)B"

if [ "$3" == "add" ]; then
    /downloads/.telegram/telegram.sh -T "qBittorrent" -M "The torrent '$name' ($size) has been added."
elif [ "$3" == "fin" ]; then
    /downloads/.telegram/telegram.sh -T "qBittorrent" -M "The torrent '$name' ($size) has finished downloading."
fi
