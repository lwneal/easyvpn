#!/bin/bash
set -e

if [ $# -lt 2 ]; then
    echo "Usage:"
    echo "$0 54.68.123.234 vpn.mysite.com newhost"
    echo "Adds the provisioned Ubuntu machine newhost with IP 54.68.123.234 to vpn.mysite.com"
    exit
fi
NEW_CLIENT=$1
VPN_SERVER=$2


echo "Attempting to connect to new client at $NEW_CLIENT ..."
ssh $NEW_CLIENT "uname -a && echo Success"

echo "Attempting to connect to VPN server at $VPN_SERVER ..."
ssh $VPN_SERVER "uname -a && echo Success"

echo "Installing OpenVPN on $NEW_CLIENT..."
echo TODO

echo "Creating keys for $NEW_CLIENT..."
echo TODO

echo "Moving keys to $NEW_CLIENT..."
echo TODO

echo "Installing keys on $NEW_CLIENT..."
echo TODO

echo "Done"
