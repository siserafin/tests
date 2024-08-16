! /bin/bash
oc delete ns flightctl-internal
oc delete ns flightctl-external
helm uninstall flightctl
rm ~/.config/flightctl/client.yaml
sudo rm -rf ~/.flightctl/certs/
rm -rf  flightctl

