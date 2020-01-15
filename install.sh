#!/bin/bash
master_node="192.168.210.11"

# create correct dns resolvers
sudo rm /etc/resolv.conf
sudo echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" > /etc/resolv.conf

# Install zsh etc
sudo apt update
sudo apt install git zsh curl wget python-pip -y

# clone requested repositories
ssh $master_node git clone https://github.com/openstack/openstack-helm.git
ssh $master_node git clone https://github.com/openstack/openstack-helm-infra.git


cd ~
git clone https://github.com/kubernetes-sigs/kubespray.git
cd $HOME/kubespray
chown ubuntu.ubuntu $HOME/kubespray -R
sudo pip install -r requirements.txt
chown ubuntu.ubuntu $HOME/kubespray -R
cp -rfp inventory/sample inventory/mycluster


# Install Helm
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

######

echo "Create HOSTS file for ansible"
echo "Check group_vars!!!!!"
echo "Run ansible like ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml"
echo "Dont forget to download armada manifests!!!"
echo "Private repo: git@github.com:lmercl/armada-manifests.git"

ssh $master_node echo "alias armada='sudo docker exec -t armada armada'" >> ~/.bashrc
ssh $master_node mkdir ~/.kube
ssh $master_node sudo cp /etc/kubernetes/admin.conf ~/
ssh $master_node sudo chown ubuntu: ~/admin.conf
ssh $master_node sudo cp ~/admin.conf ~/.kube/config
scp $master_node:/admin.conf ~/

# run armada
echo "Run armada docker container on master-1 or any other master"
#ssh $master_node sudo docker run -d --rm --net host  --name armada -v /etc/:/etc/ -v /home/ubuntu/.kube/:/home/ubuntu/.kube/ -v /home/ubuntu/:/tmp/ quay.io/airshipit/armada:latest

# Install oh-my-zs on the supervisor of cluster
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sed -i 's/plugins\=\(git\)/plugins\=\(git kubectl\)/g' ~/.zshrc
echo -e "PROMPT='%(!.%{%F{yellow}%}.)\$USER@%{\$fg[white]%}%M \${ret_status} %{\$fg[cyan]%}%c%{\$reset_color%} \$(git_prompt_info) '" >> ~/.zshrc
