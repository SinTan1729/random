#!/bin/sh

# Adapted from https://github.com/claabs/qbittorrent-port-forward-file/blob/master/main.sh
# Until VPN_PORT_FORWARDING_UP_COMMAND is available, this could be run via a cronjob
# Might need to change the container name in the docker exec line

set -e

qbt_username="${QBT_USERNAME:-admin}"
qbt_password="${QBT_PASSWORD:-adminadmin}"
qbt_addr="${QBT_ADDR:-http://localhost:8085}" # ex. http://10.0.1.48:8080
gluetun_container="${GLUETUN_COMTAINER:-qbt-gluetun}"

port_number=$(docker exec "$gluetun_container" cat /tmp/gluetun/forwarded_port)

if [ -z "$port_number" ]; then
    echo "Could not figure out which port to set."
    exit 1
fi

curl --fail --silent --show-error --cookie-jar /tmp/cookies.txt --cookie /tmp/cookies.txt --header "Referer: $qbt_addr" --data "username=$qbt_username" --data "password=$qbt_password" $qbt_addr/api/v2/auth/login 1> /dev/null

listen_port=$(curl --fail --silent --show-error --cookie-jar /tmp/cookies.txt --cookie /tmp/cookies.txt $qbt_addr/api/v2/app/preferences | jq '.listen_port')

if [ ! "$listen_port" ]; then
    echo "Could not get current listen port, exiting..."
    exit 1
fi

if [ "$port_number" = "$listen_port" ]; then
    echo "Port already set, exiting..."
    exit 0
fi

echo "Updating port to $port_number"

curl --fail --silent --show-error --cookie-jar /tmp/cookies.txt --cookie /tmp/cookies.txt --data-urlencode "json={\"listen_port\": $port_number}"  $qbt_addr/api/v2/app/setPreferences

echo "Successfully updated port"

