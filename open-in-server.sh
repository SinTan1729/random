#!/usr/bin/env bash

# This script opens supported locations in my server by appropriately changing the
# mount locations for it to work over ssh.

ROOTDIR="$(echo $PWD | cut -d/ -f-2,3)"

if [ "$ROOTDIR" == "/mnt/server" ]; then
    ssh -t server-ts-rsync "cd \"/mnt/storage/$(echo $PWD | cut -d/ -f4-)\"; fish -l"
elif [[ "$ROOTDIR" == "/tank1/personal" || "$ROOTDIR" == "/tank1/media" ]]; then
    ssh -t server-ts-rsync "cd \"$PWD\"; fish -l"
else
    echo "Unsupported directory."
    echo "Only /mnt/server/*, /tank1/* are supported."
fi

