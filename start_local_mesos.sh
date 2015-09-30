#!/bin/bash

# Start services
systemctl start zookeeper.service \
    mesos-master.service \
    mesos-slave.service \
    marathon.service \
    chronos.service