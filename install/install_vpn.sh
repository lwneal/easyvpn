#!/bin/bash
set -e

if [ $# -lt 3 ]; then
    echo "Usage:"
    echo -e "\t$0 mydomain.com WA Seattle"
    echo "mydomain.com: The domain name you are using for your VPN"
    echo "WA: Your 2-letter state code"
    echo "Seattle: Your city"
    exit
fi
SERVER_NAME=$1
STATE_CODE=$2
CITY_NAME=$3

if [ "$EUID" -ne 0 ]; then 
  echo "Run this script as root!"
  exit
fi

apt-get install -y openvpn easy-rsa

cd ~
make-cadir ~/openvpn-ca || echo "CA Directory already exists"
pushd ~/openvpn-ca

# http://stackoverflow.com/questions/24255205/error-loading-extension-section-usr-cert
echo "HACK TO FIX openssl-1.0.0.cnf"
perl -p -i -e 's|^(subjectAltName=)|#$1|;' openssl-1.0.0.cnf

source ./vars
./clean-all

source ./vars
export KEY_COUNTRY=US
export KEY_PROVINCE=$STATE_CODE
export KEY_CITY=$CITY_NAME
export KEY_ORG=$SERVER_NAME
export KEY_EMAIL="admin@$SERVER_NAME"
export KEY_OU=$SERVER_NAME
export KEY_NAME=$SERVER_NAME

./build-ca --batch
./pkitool --server $SERVER_NAME
openvpn --genkey --secret keys/ta.key
./build-dh

cat ~/server.conf.template \
  | sed "s/^cert SERVER_NAME.crt$/cert ${SERVER_NAME}.crt/" \
  | sed "s/^key SERVER_NAME.key$/key ${SERVER_NAME}.key/" > /etc/openvpn/${SERVER_NAME}.conf

popd
cp openvpn-ca/keys/${SERVER_NAME}.* /etc/openvpn
cp openvpn-ca/keys/ca.* /etc/openvpn
cp openvpn-ca/keys/dh* /etc/openvpn
cp openvpn-ca/keys/ta.key /etc/openvpn

