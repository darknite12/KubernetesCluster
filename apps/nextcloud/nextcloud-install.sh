#!/bin/bash

#create nextcloud namespace
sudo kubectl create namespace nextcloud

#create persisten volume
sudo kubectl apply -f nextcloud.persistentvolume.yml
sudo kubectl get pv

#create persistent volume claim
kubectl apply -f nextcloud.persistentvolumeclaim.yml
kubectl get pvc -n nextcloud