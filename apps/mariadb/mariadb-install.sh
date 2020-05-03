#!/bin/bash

helm show values bitnami/mariadb >> mariadb.values.yml
helm install my-release bitnami/mariadb
