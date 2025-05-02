#!/bin/sh
set -x

echo "Setup Vagrant user"
adduser -D vagrant
echo "vagrant:vagrant" | chpasswd

# TODO: Need fix this will fail on install
# # Install sudo locally from community repo
# echo "Install sudo"
# apk add --repository https://dl-cdn.alpinelinux.org/alpine/v3.20/community/ sudo
# apk update && apk apk upgrade
# echo 'vagrant ALL=(ALL:ALL) ALL' >> /etc/sudoers
# cat /etc/sudoers

# echo "Install curl"
# apk add --repository https://dl-cdn.alpinelinux.org/alpine/v3.20/main/ curl

echo "SSH configurations for user vagrant"
mkdir /home/vagrant/.ssh
mv /tmp/vagrant.pub /home/vagrant/.ssh/authorized_keys
# curl -k -s -L -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/refs/heads/main/keys/vagrant.pub
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# echo "Setup vmware-tools"
# apk add --repository https://dl-cdn.alpinelinux.org/alpine/v3.20/community/ open-vm-tools open-vm-tools-guestinfo open-vm-tools-deploypkg
# rc-service open-vm-tools start
# rc-update add open-vm-tools boot
