# coreos-setup

## About

This repository contains `systemd` unit files for Mesos on CoreOS setup, as described at initially described at https://docs.mesosphere.com/tutorials/mesosphere-on-a-single-coreos-instance/
There were some tweaks applied, such as the automatic determination of the IP address based on the network interface name. The Docker containers werde also updated to the most recent versions of the infrastructure (see below).

It installs the following infrastucture:

1. Zookeeper (3.4.6)
2. Mesos Master (0.24.1)
3. Mesos Slave (0.24.1)
4. Marathon (0.10.1)
5. Chronos (2.4.0)

as of 2015-09-03.

## Installation

Please take the following steps to install the unit files on your CoreOS instance:

### Clone repository

    git clone https://github.com/tobilg/coreos-setup.git

### Run setup script

Give execution permissions to the scripts:

    sudo chmod +x coreos-setup/*.sh

To configure and install the services for a single node, run 

    sudo coreos-setup/setup_mesos_environment.sh <public network interface name>

where `<public network interface name>` is `eth1` for example.

If you want to run on multiple nodes with each one having an own Zookeeper instance, use

    sudo coreos-setup/setup_mesos_environment.sh <public network interface name> <comma separated list of IP addresses>

where `<public network interface name>` is `eth1` for example, and `<comma separated list of IP addresses>` is `192.168.0.1,192.168.0.2,192.168.0.3`

### Pull images

To avoid a long delay upon the first startup, pull the relevant Docker images before via

    sudo coreos-setup/pull_images.sh

Depending on your internet connection this can take a while...

### Start services

On a local node installation, run

    sudo coreos-setup/start_local_mesos.sh
	
This will start all services. For a cluster installation, it is advisable to start the Zookeeper services with `sudo systemctl start zookeeper.service` on each node first, and once this is done, start the other services via

    sudo coreos-setup/start_cluster_mesos.sh