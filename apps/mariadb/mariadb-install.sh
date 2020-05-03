#!/bin/bash

#create mariadb namespace
kubectl create namespace mariadb

#create persisten volumes
kubectl apply -f mariadb.persistentvolume.yml
kubectl get pv

#create persistent volume claim
kubectl apply -f mariadb.persistentvolumeclaim.yml
kubectl get pvc -n mariadb

helm install mariadb bitnami/mariadb --namespace mariadb --values mariadb.values.yml

kubectl get pods -n mariadb -o wide