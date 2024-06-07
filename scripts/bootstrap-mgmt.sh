#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y

### Install utils ###
echo "+++ Installing utils..."
sudo apt-get install -y install ca-certificates curl openssl

### Install Docker ###
echo "+++ Installing Docker..."

# Setup Docker's Apt repository
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install latest Docker packages versions
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose

# Start Docker
echo "+++ Starting Docker..."
sudo systemctl start docker
sudo systemctl enable docker

# Enable BuildKit to only build the stages that the target stage depends on
echo "DOCKER_BUILDKIT=1" | sudo tee -a /etc/environment

# Add 'vagrant' user to the 'docker' group to be able to execute docker without the root privileges
sudo usermod -aG docker vagrant

### Clean up cached packages ###
echo "+++ Cleaning all cached packages..."
sudo apt-get clean all
