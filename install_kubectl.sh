#!/bin/bash

# Install latest version of kubectl
# This one is the latest!
#curl -sLO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
# v 1.16.3
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.16.3/bin/linux/amd64/kubectl
sudo mv kubectl /usr/bin/
sudo chmod 755 /usr/bin/kubectl

echo "LABEL YOUR NODES!!!!!"
