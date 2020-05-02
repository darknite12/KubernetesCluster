#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
	exit 1
else
    # Install Docker
    sudo apt -y update
    sudo apt install -y docker.io

    # Start Docker
    sudo systemctl start docker
    sudo systemctl enable docker

    # Install Dependencies to Kubernetes
    sudo apt install -y apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

    # Install Kubernetes
    sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
    sudo apt install -y kubeadm kubelet kubectl kubernetes-cni

    # Configure the host machine
    sudo swapoff -a
    echo "Open up another terminal and modify /etc/fstab by commenting the swap partition entry out. Press Enter when this step is completed"

    sudo hostnamectl set-hostname kubenode1 #needs to be paramaterized

    #if you are a node
    sudo kubeadm join 192.168.1.100:6443 --token 30wylx.i37tmnpe6btfeze7 --discovery-token-ca-cert-hash sha256:72c53754e8b138e641b15b6ee54d60970cbc7896473b51ff40da5a2412ee1a08

    #if you are master
    sudo kubeadm init
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    curl https://docs.projectcalico.org/manifests/calico.yaml -O
    kubectl apply -f calico.yaml
	
	# install Kubernetes Dashboard
    kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
	
	#install helm
	sudo snap install helm --classic
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo add stable https://kubernetes-charts.storage.googleapis.com


fi
