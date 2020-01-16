#!/bin/bash

k8s_cname="k8s-lab"
#source some variables and urls
source git_urls.sh


# Install zsh etc
sudo apt update
sudo apt install git zsh curl wget python-pip -y

# TODO
# Clone repositories formaster

# Clone and set kubespray on supervisor
cd ~
git clone $kubespray
cd $HOME/kubespray
chown ubuntu.ubuntu $HOME/kubespray -R
sudo pip install -r requirements.txt
cp -rfp inventory/sample inventory/"$k8s-cname"

#TODO - check if admin.conf exists
mv ~/admin.conf ~/.kube/config

# run armada
echo "Start armada docker container on master node"
ssh $master_node sudo docker run -d --rm --net host  --name armada -v /etc/:/etc/ -v /home/ubuntu/.kube/:/home/ubuntu/.kube/ -v /home/ubuntu/:/tmp/ quay.io/airshipit/armada:latest

######################################


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

echo "Create HOSTS file for ansible"
echo "Check group_vars!!!!!"
echo "Run ansible like ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml"
echo "Dont forget to download armada manifests!!!"
echo "Private repo: git@github.com:lmercl/armada-manifests.git"
