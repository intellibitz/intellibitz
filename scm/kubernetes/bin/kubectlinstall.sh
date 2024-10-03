#!/bin/sh

sudo apt-get -y remove kubelet kubeadm kubectl
sudo apt-get -y update && \
sudo apt-get -y install apt-transport-https ca-certificates curl

sudo mkdir -m 0755 -p /etc/apt/keyrings
sudo rm /etc/apt/keyrings/kubernetes-archive-keyring.gpg
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
sudo chmod a+r /etc/apt/keyrings/kubernetes-archive-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ \
  kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

sudo apt-get -y update && \
sudo apt-get -y install kubelet kubeadm kubectl
