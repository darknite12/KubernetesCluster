#!/bin/bash

# https://www.tecmint.com/install-a-kubernetes-cluster-on-centos-8/

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
	exit 1
else
    
	## Configuration
	hostnamectl set-hostname kubenode$0
	cat <<EOF>> /etc/hosts
192.168.1.100 kubemaster
192.168.1.101 kubenode1
192.168.1.102 kubenode2
EOF
	setenforce 0
	sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
	
	# reboot
    
	firewall-cmd --permanent --add-port=6783/tcp
	firewall-cmd --permanent --add-port=10250/tcp
	firewall-cmd --permanent --add-port=10255/tcp
	firewall-cmd --permanent --add-port=30000-32767/tcp
	firewall-cmd --reload
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
	
	kubeadm join 192.168.1.100:6443 --token nu06lu.xrsux0ss0ixtnms5  --discovery-token-ca-cert-hash sha256:f996ea35r4353d342fdea2997a1cf8caeddafd6d4360d606dbc82314683478hjmf78

fi
