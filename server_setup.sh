#!/bin/bash

cd

mkdir -p grafana/provisioning # data sources and dashboards
mkdir nginx

docker volume create --name=grafana-pg-storage
docker volume create --name=grafana-storage
docker volume create --name=letsencrypt

cd -
