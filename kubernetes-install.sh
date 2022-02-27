#!/bin/bash

sudo modprobe br_netfilter



cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF


cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF


sudo sysctl --system
echo "Network Setting Has Been Completed......................"

echo "===================================================================="

echo "Proceeding with the docker installation.............................."

sudo apt-get update &&  sudo apt-get install ca-certificates curl gnupg lsb-release -y && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && sudo apt-get update -y && sudo apt-get install docker-ce docker-ce-cli containerd.io -y && sudo usermod -aG docker ubuntu

sudo apt-get update && sudo apt-get install -y && sudo apt-transport-https ca-certificates curl -y

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg



echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


sudo apt-get update

sudo apt-get install -y kubelet kubeadm kubectl -y

sudo apt-mark hold kubelet kubeadm kubectl



sudo sed -i '/^ExecStart/ s/$/ --exec-opt native.cgroupdriver=systemd/' /usr/lib/systemd/system/docker.service


sudo systemctl daemon-reload
sudo systemctl restart docker



