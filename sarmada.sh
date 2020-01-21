#!/bin/bash

ssh k8s-master-1 sudo docker run -d --rm --net host  --name armada -v /etc/:/etc/ -v /home/ubuntu/.kube/:/home/ubuntu/.kube/ -v /home/ubuntu/:/tmp/ quay.io/airshipit/armada:latest
