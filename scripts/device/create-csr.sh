rm mycsr.csr 
rm myeckey.pem  
rm myoutputfile
openssl ecparam -name secp521r1 -genkey -noout -out myeckey.pem
openssl req -new -sha256 -key myeckey.pem -out mycsr.csr -subj "/C=US/ST=Utah/L=Lehi/O=Your Company, Inc./OU=IT/CN=myverylonglongdomain.com"
echo 'creating output file'
~/flightctl/bin/flightctl csr-generate mycsr.csr -e 604800 -n mycsr -o myoutputfile -y
~/flightctl/bin/flightctl apply -f myoutputfile
~/flightctl/bin/flightctl approve csr/mycsr
~/flightctl/bin/flightctl enrollmentconfig mycsr --private-key myeckey.pem > agentconfig.yaml

