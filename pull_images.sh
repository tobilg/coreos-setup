#!/bin/bash

echo "Pulling Zookeeper"
docker pull tobilg/zookeeper:latest

echo "Pulling Mesos Master"
docker pull tobilg/mesos-master:0.25.0

echo "Pulling Mesos Slave"
docker pull tobilg/mesos-slave:0.25.0

echo "Pulling Marathon"
docker pull mesosphere/marathon:v0.13.0-RC1

echo "Pulling Chronos"
docker pull tobilg/chronos:latest