#!/bin/bash
sudo virsh destroy flightctl-device-centos
sudo virsh undefine flightctl-device-centos --remove-all-storage
