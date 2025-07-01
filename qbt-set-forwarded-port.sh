#!/bin/sh

# Adapted from https://github.com/claabs/qbittorrent-port-forward-file/blob/master/main.sh

# set -e

qbt_username="${QBT_USERNAME:-sintan}"
qbt_password="${QBT_PASSWORD}"
qbt_addr="${QBT_ADDR:-http://localhost:8085}"

if [ -z ${qbt_password} ]; then
    echo "You need to provide a password by the QBT_PASSWORD env variable"
    exit 1
fi

port_number="$1"
if [ -z "$port_number" ]; then
    port_number=$(cat /tmp/gluetun/forwarded_port)
fi

if [ -z "$port_number" ]; then
    echo "Could not figure out which port to set."
    exit 1
fi

wait_time=1
while [ $wait_time -le 512 ]; do
    wget --save-cookies=/tmp/cookies.txt --keep-session-cookies --header="Referer: $qbt_addr" --header="Content-Type: application/x-www-form-urlencoded" \
      --post-data="username=$qbt_username&password=$qbt_password" --output-document /dev/null --quiet "$qbt_addr/api/v2/auth/login"

    listen_port=$(wget --load-cookies=/tmp/cookies.txt --output-document - --quiet "$qbt_addr/api/v2/app/preferences" | grep -Eo '"listen_port":[0-9]+' | awk -F: '{print $2}')

    if [ ! "$listen_port" ]; then
        echo "Could not get current listen port, trying again after $wait_time second(s)..."
        sleep $wait_time
        wait_time=$(( wait_time*2 ))
        continue
    fi

    if [ "$port_number" = "$listen_port" ]; then
        echo "Port already set to $port_number, exiting..."
        exit 0
    fi

    echo "Updating port to $port_number"

    wget --load-cookies=/tmp/cookies.txt --header="Content-Type: application/x-www-form-urlencoded" --post-data='json={"listen_port": "'$port_number'"}' \
      --output-document /dev/null --quiet "$qbt_addr/api/v2/app/setPreferences"

    echo "Successfully updated port"
    exit 0
done

echo "Failed after 10 attempts!"
exit 2
