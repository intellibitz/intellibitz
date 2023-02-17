#https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/
[ -f ./containerd.io_1.2.13-2_amd64.deb ] || curl -sO https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/containerd.io_1.2.13-2_amd64.deb
[ -f ./docker-ce-cli_19.03.12~3-0~ubuntu-focal_amd64.deb ] || curl -sO https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce-cli_19.03.12~3-0~ubuntu-focal_amd64.deb
[ -f ./docker-ce_19.03.12~3-0~ubuntu-focal_amd64.deb ] || curl -sO https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce_19.03.12~3-0~ubuntu-focal_amd64.deb

# installs with dependencies
sudo apt update && \
sudo apt --fix-broken install && \
sudo apt -f install \
    iptables libip6tc2 libnetfilter-conntrack3 libnfnetlink0 libnftnl11
#https://docs.docker.com/engine/install/ubuntu/
sudo dpkg -iE ./docker-ce_19.03.12~3-0~ubuntu-focal_amd64.deb && \
sudo dpkg -iE ./docker-ce-cli_19.03.12~3-0~ubuntu-focal_amd64.deb && \
sudo dpkg -iE ./containerd.io_1.2.13-2_amd64.deb

sudo apt --fix-broken install

sudo docker run hello-world

