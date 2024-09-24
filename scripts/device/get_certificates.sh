API_POD=$(oc get pod -n flightctl -l flightctl.service=flightctl-api --no-headers -o custom-columns=":metadata.name"  | head -1 )

# pull agent-usable details as well as client configuration file
for f in certs/{ca.crt,client-enrollment.crt,client-enrollment.key}; do
        echo "\\nThis is $f\\n"
        oc exec -n flightctl "${API_POD}" -- cat /root/.flightctl/$f | base64 | tr -d '\n'
done

