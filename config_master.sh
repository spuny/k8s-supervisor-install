#!/bin/bash

# This file configs master node
# Cant upload armada manifestsm they are kept in private repository - do manually
echo "Cant upload armada manifestsm they are kept in private repository - do manually"

source git_urls.sh
$master_node="192.168.210.11"
ssh $master_node git clone $os_helm
ssh $master_node git clone $os_helm_infra
scp $PWD/install_kubectl.sh $master_node:

ssh $master_node echo "alias armada='sudo docker exec -t armada armada'" >> ~/.bashrc                                                                        
ssh $master_node mkdir ~/.kube                                                          
ssh $master_node sudo cp /etc/kubernetes/admin.conf ~/                                  
ssh $master_node sudo chown ubuntu: ~/admin.conf                                        
ssh $master_node mv ~/admin.conf ~/.kube/config

scp $master_node:~/.kube/config ~/.kube/
