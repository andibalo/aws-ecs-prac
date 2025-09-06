#!/bin/bash

# Install Docker
echo "Installing Docker..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Docker Installation Complete!"

# Start OpenVPN
echo "Starting OpenVPN..."
docker volume create openvpn-data
docker run -v openvpn-data:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://$(curl -s http://checkip.amazonaws.com):1194
docker run -v openvpn-data:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
docker run -v openvpn-data:/etc/openvpn -d -p 1194:1194/udp --name openvpn --cap-add=NET_ADMIN kylemanna/openvpn
docker update --restart unless-stopped openvpn
echo "OpenVPN Started!"