#!/bin/bash
master_node="192.168.210.11"

if [ "$USER" == "root" ];
then
        echo "Must run as root or with sudo"
        exit 1
fi

# create correct dns resolvers
rm /etc/resolv.conf
echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" > /etc/resolv.conf

# clone requested repositories
ssh $master_node git clone https://github.com/openstack/openstack-helm.git
ssh $master_node git clone https://github.com/openstack/openstack-helm-infra.git
ssh $master_node git clone https://github.com/lmercl/armada-manifests.git

git clone https://github.com/kubernetes-sigs/kubespray.git
cd $HOME/kubespray
sudo pip install -r requirements.txt

cp -rfp inventory/sample inventory/mycluster
echo "Create HOSTS file for ansible"
echo "Check group_vars!!!!!"
echo "Run ansible like ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml"


# run armada
# docker run -d --rm --net host  --name armada -v /etc/:/etc/ -v /home/ubuntu/kube/:/home/ubuntu/.kube/ -v /home/ubuntu/armada/:/tmp/ quay.io/airshipit/armada:latest
