#!/bin/bash

# Start services
systemctl start \
    mesos-master.service \
    mesos-slave.service \
    marathon.service \
    chronos.service