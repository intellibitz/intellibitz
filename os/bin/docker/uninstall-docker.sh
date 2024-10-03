#https://docs.docker.com/engine/install/ubuntu/
# uninstalls old versions
sudo apt-get remove docker docker-engine docker.io containerd runc
# stops service
sudo systemctl disable docker
# uninstalls current versions
sudo apt-get purge docker-ce docker-ce-cli containerd.io
# deletes docker installation folder
sudo rm -rf /var/lib/docker
