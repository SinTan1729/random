#!/bin/sh

# I have st up qBittorrent to save the .torrent files for both incomplete and complete
# torrents in the same folder, so it creates duplicate files.
# This script removes duplicate .torrent files form qBittorrent's .torrent backup folder.
# I run this as a cronjob on my server.

[ -z "$1" ] && echo "No folder provided!" && exit 1

find "$1" -name '* 1.torrent' -print0 | while read -d $'\0' f
do
    if [ -f "$(echo "$f" | sed 's/ 1.torrent/.torrent/')" ]; then
        rm "$f"
    fi
done
