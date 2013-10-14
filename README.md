UbuntuUser
==========

setup.sh is designed to quickly build up a highly functional user account 
for a vim user on Ubuntu 12.04+. It is written an maintained so that the 
project owner (jarederaj) can quickly configure new servers and virtual 
machines that have an internet connection. It is highly recommended that you 
fork this repo and modify it to your own needs before you execute it.

Any and all contributions will be appreciated and considered.

You may need to run the following as root to make this script work:

    adduser $USER sudo
    chsh

Please do not run this script as root or with sudo.  You do need to run it on 
an account that has suod privileges, though.
