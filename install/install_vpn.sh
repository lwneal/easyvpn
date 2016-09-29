#!/bin/bash
set -e

echo "Enter an appropriate server name (eg. vpn.mydomain.com)"
read SERVER_NAME

sudo apt-get install openvpn easy-rsa

make-cadir ~/openvpn-ca || echo "CA Directory already exists"
pushd ~/openvpn-ca


echo "export KEY_COUNTRY=US" >> vars
echo "export KEY_PROVINCE=OR" >> vars
echo "export KEY_CITY=Corvallis" >> vars
echo "export KEY_ORG=$SERVER_NAME" >> vars
echo "export KEY_EMAIL=\"admin@$SERVER_NAME\"" >> vars
echo "export KEY_OU=$SERVER_NAME" >> vars
echo "export KEY_NAME=$SERVER_NAME" >> vars

source ./vars
./clean-all
./build-ca
./build-key-server deeplearninggroup.com
./build-dh

cat ~/server.conf.template \
  | sed "s/^cert SERVER_NAME.crt$/cert ${SERVER_NAME}.crt/" \
  | sed "s/^key SERVER_NAME.key$/key ${SERVER_NAME}.key/" > /etc/openvpn/${SERVER_NAME}.conf

popd
cp openvpn-ca/keys/deeplearninggroup.com.* /etc/openvpn
cp openvpn-ca/keys/ca.* /etc/openvpn
