#!/bin/bash

echo "Pulling Zookeeper"
docker pull tobilg/zookeeper:3.4.6

echo "Pulling Mesos Master"
docker pull mesosphere/mesos-master:0.28.1

echo "Pulling Mesos Slave"
docker pull mesosphere/mesos-slave:0.28.1

echo "Pulling Marathon"
docker pull mesosphere/marathon:v1.1.1

echo "Pulling Chronos"
docker pull tobilg/chronos:latest