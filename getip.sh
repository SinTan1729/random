#!/usr/bin/env bash

# This is a simple script to get the ip addresses of a machine.

echo 'ipv4:'
for i in eno1 wlan0; do
    addr="$(ip -4 addr show dev $i | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"
    [ -z "$addr" ] || echo -e "\t$i: \t\t$addr"
done
echo -e "\texternal: \t$(curl -s ipv4.icanhazip.com)"

[ "$(cat /sys/module/ipv6/parameters/disable)" == "1" ] && exit

echo 'ipv6:'
for i in eno1 wlan0; do
    addr="$(ip -6 addr show dev $i | grep -oP '(?<=inet6\s)\w+(\:{1,2}\w+){4}(?=.+link)')"
    [ -z "$addr" ] || echo -e "\t$i: \t\t$addr"
done
echo -e "\texternal: \t$(curl -s ipv6.icanhazip.com)"
