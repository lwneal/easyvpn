#!/bin/bash
set -e

if [ $# -lt 2 ]; then
    echo "Usage:"
    echo -e "\t$0 mydomain.com laptop-bobby"
    echo "Creates and downloads keys for a new VPN client named laptop-bobby"
    echo "Use the word 'laptop', 'desktop', 'ros-turtlebot' etc in the name for automatic host type recognition"
    echo
    echo "Arguments:"
    echo -e "\tmydomain.com: Can also be the IP address of your VPN server eg. 123.12.34.56"
    echo -e "\tlaptop-bobby: Can be any name for the client. Suggestion: <computertype>-<username>"
    echo
    echo
    echo "Requirements:"
    echo "You must have already installed OpenVPN using ./build_server.sh"
    echo
    exit
fi

SERVER_NAME=$1
CLIENT_NAME=$2
ssh $SERVER_NAME "sudo ./create_client.sh $CLIENT_NAME"
scp ${SERVER_NAME}:$CLIENT_NAME.tar.gz .

echo "Downloaded VPN config tarball $CLIENT_NAME.tar.gz"
echo "Move this file to $CLIENT_NAME and unzip it to /etc/openvpn/"
