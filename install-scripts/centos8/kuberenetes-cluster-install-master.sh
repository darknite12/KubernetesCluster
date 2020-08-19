#!/bin/bash

# https://www.tecmint.com/install-a-kubernetes-cluster-on-centos-8/

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
	exit 1
else
    
	## Configuration
	hostnamectl set-hostname kubemaster
	cat <<EOF>> /etc/hosts
192.168.1.100 kubemaster
192.168.1.101 kubenode1
192.168.1.102 kubenode2
EOF
	setenforce 0
	sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
	
	# reboot
    
	firewall-cmd --permanent --add-port=6443/tcp
	firewall-cmd --permanent --add-port=2379-2380/tcp
	firewall-cmd --permanent --add-port=10250/tcp
	firewall-cmd --permanent --add-port=10251/tcp
	firewall-cmd --permanent --add-port=10252/tcp
	firewall-cmd --permanent --add-port=10255/tcp
	firewall-cmd --reload
	modprobe br_netfilter
	echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables


	## Docker
	
	dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
	dnf install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
	dnf install docker-ce
	systemctl enable docker
	systemctl start docker
	
	
	## Kubernetes
	cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
	dnf install kubeadm -y
	systemctl enable kubelet
	systemctl start kubelet
	
	sudo swapoff -a
    echo "Open up another terminal and modify /etc/fstab by commenting the swap partition entry out. Press Enter when this step is completed"

    kubeadm init
	
	mkdir -p $HOME/.kube
	cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	chown $(id -u):$(id -g) $HOME/.kube/config
	
	kubectl get nodes
	export kubever=$(kubectl version | base64 | tr -d '\n')
	kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
	kubectl get nodes
fi
