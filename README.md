## Easy VPN

Are you tired of Google assuming things about you just because of where you live?

Do you want to SSH into your work computer, but your IT setup makes it difficult?

Do you want to control your ROS-based research robot from a remotely located computer?

You can solve all these problems by setting up a Virtual Private Network!


## Step Zero

If you are using Windows, back up your files and install a UNIX-based operating system.


## Step One

Go to Amazon Web Services, digitalocean, or your favorite other provider and rent a server.

Make sure the server is running Ubuntu 16.04 or a similar version of Linux.

Make sure the server has the following ports open: TCP 22, TCP 943, UDP 1194


## Step Two

Find the IP address of the server you rented. For example: 54.68.123.234


## Step Three (optional)

Register a domain name through Amazon Route53, namecheap.com, or your favorite domain name registrar.

Create an A record that points 54.68.123.234 to eg. yourdomainname.com or vpn.yourdomainname.com


## Step Four

On the server, create a user account for yourself, with sudo access, public key authentication, and no password.

If you have an Amazon Ubuntu 16.04 server, you can do this automatically by running:


    ./ssh_setup.sh 54.68.123.234

or

    ./ssh_setup.sh mydomainname.com

Where 54.68.123.234 or mydomanname.com is the hostname of the server that you have rented.


## Step Five

Run the command:

    ./build_server.sh 54.68.123.234

Where 54.68.123.234 is the hostname of the server that you have rented.


## Step Six

Add a client for each computer you want to connect to the VPN. For example:

    ./add_client.sh 54.68.123.234 laptop-myusername
    ./add_client.sh 54.68.123.234 desktop-myusername
    ./add_client.sh 54.68.123.234 my-other-computer-myusername

This will create a laptop-myusername.tar.gz file for each computer.


## Step Seven

For each computer you want to connect to the VPN, move computername-username.tar.gz to the computer and install it.

For OSX, use [Tunnelblick](https://tunnelblick.net/cInstall.html).

For Linux, run:

    sudo apt-get install openvpn
    cd /etc/openvpn
    sudo tar xzvf ~/my-other-computer-myusername.tar.gz
    sudo echo 'AUTOSTART="all"' >> /etc/default/openvpn


After the VPN is set up, you can add a nicely formatted status page by running:

    ./build_status_monitor.sh serverhostname.com

Then visit port 8004 on the server to see which devices are currently connected to the VPN.
Note: ensure that port 8004 is not open to the public Internet


To route all of your Internet traffic through the VPN, follow instructions [here](https://openvpn.net/index.php/open-source/documentation/howto.html#redirect)
