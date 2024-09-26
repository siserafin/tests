#!/bin/bash
#run from flightctl-demo
#copy youragentconfig and Containerfile to flightctl-demo

sudo podman login quay.io -u ${QUAYUSER} -p ${QUAY_PASSWORD}
cp agentconfig.yaml ./images/bootc/centos-bootc/
cp Containerfile ./images/bootc/centos-bootc/

make bootc-centos QUAYUSER=${QUAYUSER} # the quay.io repository must be set to public
make qcow2-bootc QUAYUSER=${QUAYUSER} flavor=centos

#Create the VM
export VMNAME=flightctl-device-centos
export VMRAM=512
export VMCPUS=1
export VMDISK=/var/lib/libvirt/images/$VMNAME.qcow2
export VMWAIT=0

sudo cp ./output/qcow2/disk.qcow2 $VMDISK
            oath: /configuration
sudo chown libvirt:libvirt $VMDISK 2>/dev/null || true
sudo virt-install --name $VMNAME \
         --tpm backend.type=emulator,backend.version=2.0,model=tpm-tis \
                                   --vcpus $VMCPUS \
                                   --memory $VMRAM \
                                   --import --disk $VMDISK,format=qcow2 \
                                   --os-variant fedora-eln  \
                                   --autoconsole text \
				   --wait $VMWAIT \
   				   --transient || true


