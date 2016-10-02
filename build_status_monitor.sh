#!/bin/bash
set -e

if [ $# -lt 1 ]; then
    echo "Usage:"
    echo -e "\t$0 53.86.12.34"
    echo "Arguments:"
    echo "Hostname of the server to connect to."
    echo "The server should already be running OpenVPN"
    exit
fi
SERVER=$1

echo "Copying files to server..."
scp -r status ${SERVER}:
scp install/install_status_monitor.sh ${SERVER}:

echo "Running command on server..."
ssh $SERVER "sudo ./install_status_monitor.sh"

echo "Successfully installed status monitor. View it at http://$SERVER"
