#!/bin/bash
branch_name="release-2.11"

# create correct dns resolvers
sudo rm /etc/resolv.conf
sudo chmod 666 /etc/resolv.conf
cat << 'EOF' > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
sudo chmod 644 /etc/resolv.conf
k8s_cname="k8s-lab"
#source some variables and urls
source git_urls.sh


# Install zsh etc
sudo apt update
sudo apt install git zsh curl wget python3-pip -y
sudo pip3 install --upgrade pip
mkdir ~/.ssh
cp $PWD/ssh_config $HOME/.ssh/config

# clone requested repositories
ssh $master_node git clone https://github.com/spuny/openstack-helm.git
ssh $master_node git clone https://github.com/spuny/openstack-helm-infra.git


# Clone and set kubespray on supervisor
cd ~
git clone --single-branch --branch $branch_name $kubespray
cd $HOME/kubespray
chown ubuntu.ubuntu $HOME/kubespray -R
sudo pip install -r requirements.txt
cp -rfp inventory/sample inventory/k8s-cluster
cp -rfp inventory/sample inventory/"$k8s_cname"

if [ ! -d "$HOME/.kube" ];then
    exit 1
fi

if [ ! -f "$HOME/admin.conf" ];then
    exit 1
else
    mv ~/admin.conf ~/.kube/config
fi

sudo ln -v sarmada.sh /usr/bin/sarmada
sudo ln -v karmada.sh /usr/bin/karmada


source install_zsh.sh
######################################
source config_master.sh


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
