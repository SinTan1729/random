#!/usr/bin/env bash

# This is a simple script to get the ip addresses of a machine.

addr4="$(curl --connect-timeout 3 -s ipinfo.io)"
addr6=$(curl --connect-timeout 3 -s ipv6.icanhazip.com)

echo 'ipv4:'
for i in eth0 eno1 wlan0; do
    $(ip -4 addr | grep -q " $i:") || continue
    addr="$(ip -4 addr show dev $i | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"
    [ -z "$addr" ] || echo -e "\t$i: \t\t$addr"
done
addr="$(echo $addr4 | jq -r '.ip')"
echo -e "\texternal: \t${addr:-n/a}"

[ "$(cat /sys/module/ipv6/parameters/disable)" == "1" ] && exit

echo 'ipv6:'
for i in eth0 eno1 wlan0; do
    $(ip -6 addr | grep -q " $i:") || continue
    addr="$(ip -6 addr show dev $i | grep -oP '(?<=inet6\s)\w+(\:{1,2}\w+){4}(?=.+link)')"
    [ -z "$addr" ] || echo -e "\t$i: \t\t$addr"
done
echo -e "\texternal: \t${addr6:-n/a}"

location="$(echo $addr4 | jq -r '.city,.region,.country' | paste -sd, - | sed 's/,/, /g')"
timzone="$(echo $addr4 | jq -r '.timezone')"
echo -e "city: \t${location:-n/a}"
echo -e "tz: \t${timzone:-n/a}"
