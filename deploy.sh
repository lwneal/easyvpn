#!/bin/bash
set -e

if [ $# -lt 1 ]; then
    echo "Usage:"
    echo -e "\t$0 54.68.123.234"
    echo -e "\tCreates a new OpenVPN server on the given IP"
    exit
fi
IP=$1

ssh $IP 'echo Connected to `hostname`' || echo "Error: Could not ssh to $IP, is pubkey auth set up?"

scp -r install/* ${IP}:

echo "Enter an appropriate server name (eg. vpn.mydomain.com)"
read SERVER_NAME

echo "Enter your 2-letter state code (eg. WA, OR, or CA)"
read STATE_CODE

echo "Enter your city name (eg. Portland)"
read CITY_NAME

ssh $IP "sudo ./install_vpn.sh $SERVER_NAME $STATE_CODE $CITY_NAME"
