#!/bin/bash

API_POD=$(oc get pod -n flightctl -l flightctl.service=flightctl-api --no-headers -o custom-columns=":metadata.name"  | head -1 )

mkdir certs

# pull agent-usable details as well as client configuration file
for f in certs/{ca.crt,client-enrollment.crt,client-enrollment.key}; do
        echo "\\nThis is $f\\n"
        oc exec -n flightctl "${API_POD}" -- cat /root/.flightctl/$f | base64 | tr -d '\n' > $f
done


# Define the path to the YAML file
yaml_file="agentconfig.yaml"

# Define new values
new_client_certificate_data=$(cat certs/ca.crt)
new_client_key_data=$(cat certs/client-enrollment.key)
new_certificate_authority_data=$(cat certs/client-enrollment.crt)

# Replace the values in the YAML file
sed -i "s|client-certificate-data:.*|client-certificate-data: $new_client_certificate_data|" "$yaml_file"
sed -i "s|client-key-data:.*|client-key-data: $new_client_key_data|" "$yaml_file"
sed -i "s|certificate-authority-data:.*|certificate-authority-data: $new_certificate_authority_data|" "$yaml_file"

echo "YAML file has been updated with new values."
