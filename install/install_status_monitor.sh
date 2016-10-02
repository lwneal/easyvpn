#!/bin/bash
# Assume the Flask app has been copied to ~/status

PORT=8004
function get_private_ip() {
    ifconfig | grep -A 1 tun | grep "inet addr" | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | head -1
}

echo "Installing requirements..."
apt-get install -y python python-pip
apt-get install -y nginx
pip install Flask

echo "Ensuring OpenVPN is running..."
service openvpn start
service openvpn status

echo "Killing daemon..."
pkill -f "python server.py --port=$PORT"

echo "Summoning daemon..."
cd status
nohup python server.py > stdout.log 2>stderr.log &

echo "Status page now available at is listening on http://`get_private_ip`:$PORT"
