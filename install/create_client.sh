#!/bin/bash
set -e

# Client name should start with a descriptive tag and must be unique
# eg: laptop-alice, workstation-bob, robot-frontdoor
CLIENT_NAME=$1

# Read the server name from ca.crt which we created with build_server.sh
SERVER_NAME=$(openssl x509 -in ~/openvpn-ca/keys/ca.crt -text | grep -o "O=[^\,]*" | head -1 | cut -c 3- | cut -d \/ -f 1)
echo "Using server name $SERVER_NAME"

if [ $# -lt 1 ]; then
  echo "Usage: $0 boblaptop"
  echo "Creates an openvpn key and configuration file for a computer named 'boblaptop'"
  echo "Client name should be one word lowercase ASCII"
  exit
fi

cd ~/openvpn-ca
source ./vars
export KEY_NAME=${CLIENT_NAME}
export KEY_OU=${CLIENT_NAME}
export KEY_CN=${CLIENT_NAME}.${SERVER_NAME}
./build-key --batch $CLIENT_NAME

# Replace the "CLIENT_NAME" in client.conf with the real client name
cd keys
cat ~/client.conf.template | \
  sed "s/CLIENT_NAME/${CLIENT_NAME}/" | \
  sed "s/SERVER_NAME/${SERVER_NAME}/" > ${CLIENT_NAME}.conf

tar czvf ~/${CLIENT_NAME}.tar.gz ${CLIENT_NAME}.key ${CLIENT_NAME}.conf ${CLIENT_NAME}.csr ${CLIENT_NAME}.crt ${SERVER_NAME}.crt ca.crt
echo "Keys and configuration file for $CLIENT_NAME have been saved to ${CLIENT_NAME}.tar.gz"
