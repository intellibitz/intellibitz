#https://docs.docker.com/engine/install/linux-postinstall/

sudo groupadd docker
sudo usermod -aG docker $USER

#On Linux, you can also run the following command to activate the changes to groups:
newgrp docker 

#If you initially ran Docker CLI commands using sudo before adding your user to the docker group,
# you may see the following error, which indicates that your ~/.docker/ directory was created
# with incorrect permissions due to the sudo commands.

#> WARNING: Error loading config file: /home/user/.docker/config.json -
#> stat /home/user/.docker/config.json: permission denied

#To fix this problem, either remove the ~/.docker/ directory (it is recreated automatically,
# but any custom settings are lost), or change its ownership and permissions using the following commands:

sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R

#Verify that you can run docker commands without sudo.
docker run hello-world

