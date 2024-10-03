#

# uninstalls desktop versions
sudo apt remove docker-desktop
rm -r "$HOME"/.docker/desktop
sudo rm /usr/local/bin/com.docker.cli
sudo apt purge docker-desktop

#Note
#If you have installed the Docker Desktop for Linux tech preview or beta version, you need to
# remove all files that were generated by those packages
# (e.g., ~/.config/systemd/user/docker-desktop.service,
# ~/.local/share/systemd/user/docker-desktop.service).

#