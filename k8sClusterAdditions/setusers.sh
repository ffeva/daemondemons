#!/bin/bash
sudo adduser username
sudo su - username
mkdir .ssh
chmod 700 .ssh
touch .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
# nano .ssh/authorized_keys
echo publickey/username.pub > .ssh/authorized_keys
exit
