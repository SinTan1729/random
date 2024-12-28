#!/bin/sh

# Adapted from https://github.com/claabs/qbittorrent-port-forward-file/blob/master/main.sh

# set -e

qbt_username="${QBT_USERNAME:-sintan}"
qbt_password="${QBT_PASSWORD:-default_pass}"
qbt_addr="${QBT_ADDR:-http://localhost:8085}" # ex. http://10.0.1.48:8080

port_number="$1"
[ -z "$port_number" ] && port_number=$(cat /tmp/gluetun/forwarded_port)

if [ -z "$port_number" ]; then
    echo "Could not figure out which port to set."
    exit 1
fi

wget --save-cookies=/tmp/cookies.txt --keep-session-cookies --header="Referer: $qbt_addr" --header="Content-Type: application/x-www-form-urlencoded" \
  --post-data="username=$qbt_username&password=$qbt_password" --output-document /dev/null --quiet "$qbt_addr/api/v2/auth/login"

listen_port=$(wget --load-cookies=/tmp/cookies.txt --output-document - --quiet "$qbt_addr/api/v2/app/preferences" | grep -Eo '"listen_port":[0-9]+' | awk -F: '{print $2}')

if [ ! "$listen_port" ]; then
    echo "Could not get current listen port, exiting..."
    exit 1
fi

if [ "$port_number" = "$listen_port" ]; then
    echo "Port already set to $port_number, exiting..."
    exit 0
fi

echo "Updating port to $port_number"

wget --load-cookies=/tmp/cookies.txt --header="Content-Type: application/x-www-form-urlencoded" --post-data='json={"listen_port": "'$port_number'"}' \
  --output-document /dev/null --quiet "$qbt_addr/api/v2/app/setPreferences"

echo "Successfully updated port"

