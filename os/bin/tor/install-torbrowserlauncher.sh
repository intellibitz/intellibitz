#Installing in any Linux distro using Flatpak
#Install Flatpak using these instructions.
#Then install torbrowser-launcher like this:

flatpak install flathub com.github.micahflee.torbrowser-launcher -y

#Run torbrowser-launcher either by using the GUI desktop launcher, or by running:

flatpak run com.github.micahflee.torbrowser-launcher

#Installing from the PPA
#If you use Ubuntu or one of its derivatives:

sudo add-apt-repository ppa:micahflee/ppa
sudo apt update
sudo apt install torbrowser-launcher

#Run torbrowser-launcher either by using the GUI desktop launcher, or by running:

torbrowser-launcher

