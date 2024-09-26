#Export QUAY_USER and QUAY_PASSWORD with your quay.io account

rm mycsr.csr 
rm myeckey.pem  
rm myoutputfile

git clone git@github.com:flightctl/flightctl-demos.git ~/
openssl ecparam -name secp521r1 -genkey -noout -out myeckey.pem
openssl req -new -sha256 -key myeckey.pem -out mycsr.csr -subj "/C=US/ST=Utah/L=Lehi/O=Your Company, Inc./OU=IT/CN=myverylonglongdomain.com"
echo 'creating output file'
~/flightctl/bin/flightctl csr-generate mycsr.csr -e 604800 -n mycsr -o myoutputfile -y
~/flightctl/bin/flightctl apply -f myoutputfile
~/flightctl/bin/flightctl approve csr/mycsr
~/flightctl/bin/flightctl enrollmentconfig mycsr --private-key myeckey.pem > agentconfig.yaml


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
                                   --import --disk $VMDISK,format=qcow2 \
                                   --os-variant fedora-eln  \
                                   --autoconsole text \
                                   --wait $VMWAIT \
                                   --transient || true
