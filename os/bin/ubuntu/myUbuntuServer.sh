ip a
ip addr show
hostname -I
uname -a
uptime
lsb_release -a
ifconfig
arp -a
curl ifconfig.me #prints public ip

sudo apt-get install openssh-server
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.factory-defaults
sudo chmod a-w /etc/ssh/sshd_config.factory-defaults
sudo gedit /etc/ssh/sshd_config
sudo systemctl enable ssh
sudo systemctl start ssh
sudo ss -lnp | grep sshd
ssh-keygen -t rsa -b 4096
ssh-copy-id <username>@<host>

timedatectl list-timezones
sudo timedatectl set-timezone <timeszone>

systemd-analyze cat-config systemd/logind.conf
sudo systemctl restart systemd-logind
