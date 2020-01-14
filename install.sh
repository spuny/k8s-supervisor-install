#!/bin/bash
master_node="192.168.210.11"

if [[ $EUID -ne 0 ]]; then
   echo "You must be root to do this." 1>&2
   exit 100
fi

# create correct dns resolvers
rm /etc/resolv.conf
echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" > /etc/resolv.conf

# Install zsh etc
sudo apt install git zsh -y
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sed -i 's/plugins\=\(git\)/plugins\=\(git kubectl\)/g' ~/.zshrc
echo "export PROMPT='%(!.%{%F{yellow}%}.)$USER@%{$fg[white]%}%M ${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'" >> ~/.zshrc
source ~/.zshrc


# clone requested repositories
ssh $master_node git clone https://github.com/openstack/openstack-helm.git
ssh $master_node git clone https://github.com/openstack/openstack-helm-infra.git
ssh $master_node git clone https://github.com/lmercl/armada-manifests.git

cd ~
git clone https://github.com/kubernetes-sigs/kubespray.git
cd $HOME/kubespray
chown ubuntu.ubuntu $HOME/kubespray -R
sudo apt install python-pip -y
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
# Verification of runnig tiller pod
kubectl get pods -n kube-system |grep tiller

echo "Create HOSTS file for ansible"
echo "Check group_vars!!!!!"
echo "Run ansible like ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml"

ssh $master_node echo "alias armada='sudo docker exec -t armada armada'"
ssh $master_node mkdir ~/.kube
ssh $master_node sudo cp /etc/kubernetes/admin.conf ~/.kube/config

# run armada
ssh $master_node sudo docker run -d --rm --net host  --name armada -v /etc/:/etc/ -v /home/ubuntu/.kube/:/home/ubuntu/.kube/ -v /home/ubuntu/:/tmp/ quay.io/airshipit/armada:latest

