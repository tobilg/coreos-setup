#!/bin/bash

# Display help
if [ $1 == "--help" ]; then
  echo "Usage: ./setup_mesos_environment.sh <public network interface name> <comma separated list of IP addresses>"
  exit 0
fi

# Check for network interface parameter
if [ -z ${1+x} ]; then
  echo "Please supply at least a network interface name!"
  exit 1
else
  INTERFACE_NAME=$1
  LOCAL_IP=$(ifconfig ${INTERFACE_NAME} | grep 'inet ' | awk '{print $2}')
  CWD=$(pwd)
fi

# Check for additional hosts parameter
if [ -z ${2+x} ]; then
  # Produce correct env variables for single node
  echo "Single node setup for IP ${LOCAL_IP}"
  BASE_ZK="zk:\/\/${LOCAL_IP}"
  MESOS_ZK="${BASE_ZK}\/mesos"
  MARATHON_ZK="${BASE_ZK}\/marathon"
  ZOOKEEPER_HOSTS="${LOCAL_IP}"
  MESOS_QUORUM=1
else
  CLUSTER_HOSTS=$2
  HOST_COUNT=0
  IFS=',' read -a chosts <<< "$CLUSTER_HOSTS"
  for index in "${!chosts[@]}"
  do
    MESOS_HOST_STRINGS[(index+1)]=${chosts[index]}:2181
    ZK_HOST_STRINGS[(index+1)]=${chosts[index]}:2888:3888
    HOST_COUNT=$((index+1))
  done
  echo "Cluster setup for ${HOST_COUNT} hosts (${CLUSTER_HOSTS})"
  # Produce correct env variables for cluster
  IFS=','
  BASE_ZK="zk:\/\/${MESOS_HOST_STRINGS[*]}"
  MESOS_ZK="${BASE_ZK}\/mesos"
  MARATHON_ZK="${BASE_ZK}\/marathon"
  ZOOKEEPER_HOSTS="${ZK_HOST_STRINGS[*]}"
  MESOS_QUORUM=$((($HOST_COUNT / 2) + 1))
fi

# Debug info
echo "Local IP: ${LOCAL_IP}"
echo "Zookeeper Hosts: ${ZOOKEEPER_HOSTS}"
echo "Base Zookeeper URL: ${BASE_ZK}"
echo "Marathon Zookeeper URL: ${MARATHON_ZK}"
echo "Mesos Zookeeper URL: ${MESOS_ZK}"
echo "Mesos Quorum: ${MESOS_QUORUM}"

# Set WORK_DIR
WORK_DIR=$CWD/coreos-setup/etc/systemd/system

# Replace network interface name
sed -i -e "s/eth0/${INTERFACE_NAME}/" $WORK_DIR/*.service 

# Configure zookeeper.service
sed -i -e "s/%%ZOOKEEPER_HOSTS%%/${ZOOKEEPER_HOSTS}/" $WORK_DIR/zookeeper.service 
sed -i -e "s/%%LOCAL_IP%%/${LOCAL_IP}/" $WORK_DIR/zookeeper.service 

# Configure mesos-master.service
sed -i -e "s/%%MESOS_ZK%%/${MESOS_ZK}/" $WORK_DIR/mesos-master.service 
sed -i -e "s/%%LOCAL_IP%%/${LOCAL_IP}/" $WORK_DIR/mesos-master.service 
sed -i -e "s/%%MESOS_QUORUM%%/${MESOS_QUORUM}/" $WORK_DIR/mesos-master.service 

# Configure mesos-slave.service
sed -i -e "s/%%MESOS_ZK%%/${MESOS_ZK}/" $WORK_DIR/mesos-slave.service 
sed -i -e "s/%%LOCAL_IP%%/${LOCAL_IP}/" $WORK_DIR/mesos-slave.service 

# Configure marathon.service
sed -i -e "s/%%MESOS_ZK%%/${MESOS_ZK}/" $WORK_DIR/marathon.service 
sed -i -e "s/%%MARATHON_ZK%%/${MARATHON_ZK}/" $WORK_DIR/marathon.service 

# Configure chronos.service
sed -i -e "s/%%MESOS_ZK%%/${MESOS_ZK}/" $WORK_DIR/chronos.service
sed -i -e "s/%%BASE_ZK%%/${BASE_ZK}/" $WORK_DIR/chronos.service
sed -i -e "s/%%LOCAL_IP%%/${LOCAL_IP}/" $WORK_DIR/chronos.service

# Copy unit files
cp $WORK_DIR/*.service /etc/systemd/system

# Enable services
sudo systemctl enable zookeeper.service \
    mesos-master.service \
    mesos-slave.service \
    marathon.service \
    chronos.service