#!/bin/bash

echo "Pulling Zookeeper"
docker pull tobilg/zookeeper:latest

echo "Pulling Mesos Master"
docker pull tobilg/mesos-master:latest

echo "Pulling Mesos Slave"
docker pull tobilg/mesos-slave:latest

echo "Pulling Marathon"
docker pull mesosphere/marathon:latest

echo "Pulling Chronos"
docker pull tobilg/chronos:latest