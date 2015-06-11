# coreos-setup

## About

This repository contains `systemd` unit files for Mesos on CoreOS setup, as described at initially described at https://docs.mesosphere.com/tutorials/mesosphere-on-a-single-coreos-instance/
There were some tweaks applied, such as the automatic determination of the IP address based on the network interface name. The Docker containers werde also updated to the most recent versions of the infrastructure (see below).

It installs the following infrastucture:

1. Zookeeper (3.4.6)
2. Mesos Master (0.22.1)
3. Mesos Slave (0.22.1)
4. Marathon (0.8.2)

## Installation

Please take the following steps to install the unit files on your CoreOS instance:

### Clone repository

    git clone https://github.com/tobilg/coreos-setup.git

### Copy the unit files

    sudo cp coreos-setup/etc/systemd/system/*.service /etc/systemd/system

#### Hint

If you're using another public-facing network interface than `eth0`, please run

    sudo sed -i 's/eth0/<<interface name>>/g' /etc/systemd/system/*.service 
	
where `<<interface name>>` is the name of the correct interface (such as `ens192` for example if you run CoreOS on VMware ESXi).	

### Enable the `systemd` services

    sudo systemctl enable zookeeper.service \
        mesos-master.service \
        mesos-slave.service \
        marathon.service
		
### Start the `systemd` services

    sudo systemctl start zookeeper.service \
        mesos-master.service \
        mesos-slave.service \
        marathon.service