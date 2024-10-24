#!/bin/env bash

# This script allows one to log into captive portals by temporarily using the provided DNS records. Otherwise, captive portals 
# don't work with custom resolvconf setups

# Get the DNS resolver provided by the network
DNS=$(nmcli -f IP4.DNS dev show wlan0 | awk '{print $2}' | head -1)

# Temporarily put the DNS resolver in place
echo "Need sudo permission to work with /etc/resolv.conf"
sudo cp /etc/resolv.conf /etc/resolv.conf.bk
echo "# Temporary resolv.conf generated by captive-portal-login.sh" | sudo tee /etc/resolv.conf
echo "nameserver $DNS" | sudo tee -a /etc/resolv.conf

echo "Put temporary DNS resolver in place. Now try opening an website, and fix the captive portal before continuing."

read -p "Press enter to continue..."

# Put back own resolvers
sudo mv /etc/resolv.conf.bk /etc/resolv.conf

