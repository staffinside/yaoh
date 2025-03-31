#!/bin/bash


#Temporal name and location for the script, will change once its tested

# Exit if any command fails
set -e

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to run commands with sudo when needed
run_with_sudo() {
    echo -e "${YELLOW}[Requires sudo]${NC} $*"
    sudo --prompt="[sudo required] Password for %u: " -- "$@"
}

# Function to ensure Docker group exists and user is member
ensure_docker_group() {
    # Create docker group if it doesn't exist
    if ! grep -q '^docker:' /etc/group; then
        echo -e "${BLUE}Creating docker group...${NC}"
        run_with_sudo groupadd docker
    fi
    
    # Add user to docker group if not already
    if ! groups $USER | grep -q '\bdocker\b'; then
        echo -e "${BLUE}Adding user to docker group...${NC}"
        run_with_sudo usermod -aG docker $USER
    fi
}

# Function to configure Docker permissions
configure_docker() {
    echo -e "${BLUE}Configuring Docker socket permissions...${NC}"
    run_with_sudo touch /var/run/docker.sock
    run_with_sudo chown root:docker /var/run/docker.sock
    run_with_sudo chmod 660 /var/run/docker.sock
    run_with_sudo systemctl restart docker
    
    # Verify Docker access
    if ! docker info &>/dev/null; then
        echo -e "${YELLOW}Docker access still not working. Trying alternative approach...${NC}"
        run_with_sudo chmod 777 /var/run/docker.sock
    fi
}

# Main installation function
install_odoo() {
    # Install dependencies
    echo -e "${GREEN}[1/6] Installing system dependencies...${NC}"
    run_with_sudo apt-get update
    run_with_sudo apt-get install -y curl docker.io
    
    # Configure Docker
    echo -e "${GREEN}[2/6] Configuring Docker...${NC}"
    configure_docker
    
    # Install minikube
    echo -e "${GREEN}[3/6] Installing minikube...${NC}"
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    run_with_sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64

    # Install kubectl
    echo -e "${GREEN}[4/6] Installing kubectl...${NC}"
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    run_with_sudo mv ./kubectl /usr/local/bin/kubectl

    # Start Minikube
    echo -e "${GREEN}[5/6] Starting Minikube cluster...${NC}"
    if ! minikube start --driver=docker; then
        echo -e "${YELLOW}Minikube start failed. Trying with force...${NC}"
        minikube start --driver=docker --force
    fi

    # Apply configurations
    echo -e "${GREEN}[6/6] Applying Kubernetes configurations...${NC}"
    for file in postgres-pvc.yaml postgres-configmap.yaml postgres-deployment.yaml \
                postgres-service.yaml odoo-deployment.yaml odoo-service.yaml; do
        if [ -f "resources/$file" ]; then
            echo -e "Applying ${YELLOW}${file}${NC}..."
            kubectl apply -f "resources/$file" --validate=false || echo -e "${RED}Error applying ${file}${NC}"
            sleep 2
        else
            echo -e "${RED}Warning: File resources/$file not found!${NC}" >&2
        fi
    done

    echo -e "${GREEN}Deployment complete!${NC}"
    echo -e "Access Odoo with: ${YELLOW}minikube service odoo-service${NC}"
}

# --- Main Execution Flow ---

# 1. First ensure docker group exists and user is member
ensure_docker_group

# 2. If we get here, docker group was already set up
install_odoo