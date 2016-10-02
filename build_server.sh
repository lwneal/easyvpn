#!/bin/bash
set -e

if [ $# -lt 1 ]; then
    echo "Usage:"
    echo -e "\t$0 54.68.123.234"
    echo
    echo "Connects to the given Internet-accessible server and creates a new VPN"
    echo "The server must be running Ubuntu 16.04 and you must have passwordless (RSA-key) ssh and sudo access as user `whoami`"
    echo
    echo "Arguments:"
    echo -e "\t54.68.123.234: IP address of the server. Can also be your domain name eg. mydomain.com"
    echo
    exit
fi
IP=$1

ssh $IP 'echo Connected to `hostname`' || echo "Error: Could not ssh to $IP, is pubkey auth set up?"

ssh $IP 'sudo -v' || echo "Error: Could not sudo on server. Is passwordless sudo set up?"

scp -r install/* ${IP}:

echo "Enter an appropriate server name (eg. vpn.mydomain.com)"
read SERVER_NAME

echo "Enter your 2-letter state code (eg. WA, OR, or CA)"
read STATE_CODE

echo "Enter your city name (eg. Portland)"
read CITY_NAME

ssh $IP "sudo ./install_vpn.sh $SERVER_NAME $STATE_CODE $CITY_NAME"

echo "Successfully set up a VPN on $IP"
