#!/bin/bash
# Update the system
yum update -y

setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Install Docker
yum install -y docker
systemctl enable docker
systemctl start docker

yum -y install socat 
dnf install socat  


# This overwrites any existing configuration in /etc/yum.repos.d/kubernetes.repo
cat <<EOF |  tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

# Install kubeadm, kubelet, and kubectl
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet

# Initialize Kubernetes Master
kubeadm init --pod-network-cidr=50.244.0.0/16

# Set up kubeconfig for the master node
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Install Flannel network plugin
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml


#kubeadm token create --print-join-command
# Install the required dependencies
sudo yum install -y curl

# Download the Helm installation script
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

# Make the script executable
chmod 700 get_helm.sh

# Run the script to install Helm
./get_helm.sh

helm version