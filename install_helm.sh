#!/bin/bash

## Install Helm
cd /tmp
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > install-helm.sh
chmod u+x install-helm.sh
./install-helm.sh
# Install Tiller - in version of helm 3 tiller is no longer supported !!!
# Armada will not work thou
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
# Verification of runnig tiller pod
kubectl get pods -n kube-system |grep tiller
# copy helm to master
scp /tmp/install-helm.sh $master_node:
ssh $master_node /tmp/install-helm.sh