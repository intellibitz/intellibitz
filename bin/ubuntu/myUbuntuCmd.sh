#

service --status-all
service --status-all | grep '\[ + \]'
service --status-all | grep '\[ - \]'
service <service-name> start
service <service-name> stop
service <service-name> restart
service <service-name> status
ls /etc/init.d

systemctl --type service --all
systemctl list-unit-files
systemctl list-unit-files --type service -all
systemctl --type service
systemctl --type service --state running
sudo systemctl | grep running
systemctl --type service --all --state exited

systemctl start service-name
systemctl stop service-name
systemctl restart service-name
systemctl status service-name

#Run any one of the following command on Linux to see open ports:
sudo lsof -i -P -n | grep LISTEN
sudo netstat -tulpn | grep LISTEN
sudo ss -tulpn | grep LISTEN
sudo lsof -i:22 ## see a specific port such as 22 ##
sudo nmap -sTU -O IP-address-Here
ss -tulw

#