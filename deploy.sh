#!/bin/bash

# Exit if any command fails
set -e

# Get the original user who invoked sudo
ORIGINAL_USER=$(who am i | awk '{print $1}')
if [ -z "$ORIGINAL_USER" ]; then
  ORIGINAL_USER=$(logname 2>/dev/null || echo $SUDO_USER)
fi

# Install dependencies
apt-get clean
apt-get update
apt-get install -y curl docker.io

# Install minikube
sudo -u $ORIGINAL_USER curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Install kubectl
sudo -u $ORIGINAL_USER curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

# Configure Docker permissions
usermod -aG docker $ORIGINAL_USER

# Start Minikube as regular user
echo "Starting Minikube..."
sudo -u $ORIGINAL_USER minikube start --driver=docker

# Apply configurations as regular user
kubectl apply -f postgres-configmap.yaml
kubectl apply -f postgres-pvc.yaml
kubectl apply -f postgres-deployment.yaml
kubectl apply -f postgres-service.yaml
kubectl apply -f odoo-deployment.yaml
kubectl apply -f odoo-service.yaml

echo "Odoo deployment complete!"
echo "Access Odoo with: sudo -u $ORIGINAL_USER minikube service odoo-service"

# Fix permissions (important if files were created as root)
chown -R $ORIGINAL_USER:$ORIGINAL_USER $HOME/.kube $HOME/.minikube
