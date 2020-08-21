#!/bin/bash

#create nextcloud namespace
sudo kubectl create namespace nextcloud

#create persisten volume
sudo kubectl apply -f nextcloud.persistentvolume.yaml
sudo kubectl get pv

#create persistent volume claim
kubectl apply -f nextcloud.persistentvolumeclaim.yaml
kubectl get pvc -n nextcloud

helm install nextcloud stable/nextcloud --namespace nextcloud --set nextcloud.username=flara --set nextcloud.password=PASSWORD --set persistence.enabled=true --set persistence.existingClaim=nextcloud-data --set internalDatabase.enabled=false --set externalDatabase.enabled=true --set externalDatabase.type=mysql --set externalDatabase.host=192.168.1.251 --set externalDatabase.database=nextcloud --set externalDatabase.user=nextcloud --set externalDatabase.password=PASSWORD --set service.type=LoadBalancer --set service.loadBalancerIP=192.168.1.250

kubectl get pods -n nextcloud