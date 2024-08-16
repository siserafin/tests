#! /bin/bash
podman build -t test .
podman run -p 4000:4000 test
