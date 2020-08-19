#!/bin/bash

#create mariadb namespace
kubectl create namespace mariadb

#create persisten volumes
kubectl apply -f mariadb.persistentvolume.yaml
kubectl get pv

#create persistent volume claim
kubectl apply -f mariadb.persistentvolumeclaim.yaml
kubectl get pvc -n mariadb

helm install mariadb --namespace mariadb bitnami/mariadb --set volumePermissions.enabled=true --set rootUser.password=zjcu53Hw  --set db.user=flara --set db.password=zjcu53Hw --set replication.password=zjcu53Hw --set master.persistence.existingClaim=mariadb-master --set service.type=LoadBalancer  --set slave.replicas=0 -f values-production.yaml

kubectl get pods -n mariadb


# troubleshooting
##kubectl describe pod mariadb-master -n mariadb
##kubectl get pv
##kubectl get pvc -n mariadb


##kubectl delete pvc mariadb-master-0 -n mariadb
##kubectl delete pv maraidb-master -n mariadb

# Delete the mariadb chart
helm delete mariadb --namespace mariadb
