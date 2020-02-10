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

if [ -f ~/.ssh/id_rsa ];
then
    # clone requested repositories
    ssh $master_node git clone $os_helm
    ssh $master_node git clone $os_helm_infra
    ssh $master_node git clone $armada_repo
else
    echo "No key for git repository"
    exit 1
fi


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

echo "Create HOSTS file for ansible"
echo "Check group_vars!!!!!"
echo "Run ansible like ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml"
echo "Dont forget to download armada manifests!!!"
echo "Private repo: git@github.com:lmercl/armada-manifests.git"