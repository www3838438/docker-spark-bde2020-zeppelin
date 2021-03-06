#!/bin/bash

echo "Usage: $(basename $0) <base_dir_for_data>"

export DATA_DIR=${1:-${HOME}/data-docker/bde2020-hadoop-spark}/data
export NOTEBOOK_DIR=${1:-${HOME}/data-docker/bde2020-hadoop-spark}/notebook
mkdir -p ${DATA_DIR}
mkdir -p ${NOTEBOOK_DIR}

echo "DATA_DIR=${DATA_DIR}"
echo "NOTEBOOK_DIR=${NOTEBOOK_DIR}"

## -- some issue with restarting spark-notebook
## -- workaround: remove old instance first
docker rm -f spark-notebook

## -- Starting all services
docker-compose up --user $USER -d namenode hive-metastore-postgresql
docker-compose up --user $USER -d datanode hive-metastore
docker-compose up --user $USER -d hive-server
docker-compose up --user $USER -d spark-master spark-worker
sleep 8
docker-compose up --user $USER -d spark-notebook hue

#docker-compose up --user $USER -d --build zeppelin
docker-compose up --user $USER -d zeppelin

my_ip=`ip route get 1|awk '{print $NF;exit}'`
echo "Namenode: http://${my_ip}:50070"
echo "Datanode: http://${my_ip}:50075"
echo "Spark-master: http://${my_ip}:8080"
echo "Spark-notebook: http://${my_ip}:9001"
echo "Hue (HDFS Filebrowser): http://${my_ip}:8088/home"
echo "Zeppelin: http://${my_ip}:19090"
