echo TODO: write this script

USERNAME=`whoami`

echo script should do the following:
echo get RSA public key from local machine
echo ssh into server
echo adduser `whoami`
echo append "`whoami` ALL=(ALL) NOPASSWD:ALL" to /etc/sudoers
echo mkdir /home/`whoami`/.ssh
echo "echo RSA_PUBKEY >> ~/.ssh/authorized_keys"
