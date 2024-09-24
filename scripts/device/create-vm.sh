sudo podman login quay.io -u ${QUAY_USER} -p ${QUAY_PASSWORD}
cp agentconfig.yaml ~/flightctl-demo/images/bootc/centos-bootc/
cp Containerfile ~/flightctl-demo/images/bootc/centos-bootc/
cd ~/flightctl-demos
make bootc-centos QUAYUSER=${QUAY_USER} # the quay.io repository must be set to public
make qcow2-bootc QUAYUSER=${QUAY_USER} flavor=centos

#Create the VM
export VMNAME=flightctl-device-centos
export VMRAM=512
export VMCPUS=1
export VMDISK=/var/lib/libvirt/images/$VMNAME.qcow2
export VMWAIT=0

sudo cp ~/flightctl-demos/output/qcow2/disk.qcow2 $VMDISK
sudo chown libvirt:libvirt $VMDISK 2>/dev/null || true
sudo virt-install --name $VMNAME \
         --tpm backend.type=emulator,backend.version=2.0,model=tpm-tis \
                                   --vcpus $VMCPUS \
                                   --memory $VMRAM \

