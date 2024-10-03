#!/usr/bin/env sh
#https://multipass.run/docs/set-up-a-graphical-interface

#RDP
multipass launch release:23.10 --name xrdp-mantic --cpus 4 --memory 8G --disk 60G
multipass shell xrdp-mantic
sudo apt update
sudo apt install ubuntu-desktop xrdp
sudo passwd ubuntu
multipass list
multipass info xrdp-mantic

remmina -c rdp://<ipaddr>

#X11 forwarding
ForwardX11 yes #~/.ssh/config
multipass exec <name> -- bash -c "echo `cat ~/.ssh/id_rsa.pub` >> ~/.ssh/authorized_keys"
ssh -X ubuntu@<ipaddr>
export XAUTHORITY=~/.Xauthority 

#/etc/ssh/sshd_config
X11Forwarding yes 
X11DisplayOffset 10
X11UseLocalhost yes

sudo apt install x11-apps
xlogo &

sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

