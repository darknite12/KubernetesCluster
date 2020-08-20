#!/bin/bash

#create mariadb namespace
kubectl create namespace mariadb-galera

#create persisten volumes
kubectl apply -f mariadb-galera.persistentvolume.yaml
kubectl get pv

#create persistent volume claim
kubectl apply -f mariadb-galera.persistentvolumeclaim.yaml
kubectl get pvc -n mariadb-galera

helm install mariadb-galera --namespace mariadb-galera bitnami/mariadb-galera --set rootUser.password=PASSWORD --set galera.mariabackup.password=PASSWORD --set db.user=flara --set db.password=PASSWORD --set persistence.existingClaim=mariadb-galera-master --set service.type=LoadBalancer --set service.loadBalancerIP=192.168.1.251 -f values-production.yaml -f values-production.yaml

kubectl get pods -n mariadb-galera


# troubleshooting
##kubectl describe pod mariadb-master -n mariadb-galera
##kubectl get pv
##kubectl get pvc -n mariadb-galera


##kubectl delete pvc mariadb-master-0 -n mariadb-galera
##kubectl delete pv maraidb-master -n mariadb

# Delete the mariadb chart
helm delete mariadb-galera --namespace mariadb-galera

