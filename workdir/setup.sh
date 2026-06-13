#!/bin/bash

# This script will set up a DGX Spark that has been freshly installed
# The following actions are performed:
#   - Enable needed apt repos
#   - Install needed system packages
#   - Install uv
#   - Install nvm and Node.js v22.21.1
#   - Fix Ubuntu Pro activation script
#   - Enable and start cockpit service

set -e

NVM_VERSION="v0.40.3"
NODE_VERSION="v22.22.3"
NVMONITOR_VERSION="v1.13.0"

##########################################################
# Enable needed repos
sudo add-apt-repository universe -y

# Not supported for Ubuntu 24.04 yet
# curl -sSL https://repo.45drives.com/setup | bash

##########################################################
# Install needed system packages
sudo apt install -y curl wget git \
  winpr3-utils \
  uidmap dbus-user-session docker-ce-rootless-extras fuse-overlayfs \
  cockpit lm-sensors \
  cockpit-machines

# Install uv
if [ ! -f "$HOME/.local/bin/uv" ]; then
  echo "- Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
else
  echo "- uv is already installed."
fi

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm list-remote
nvm install $NODE_VERSION

##########################################################
# Fix Ubuntu Pro Script
if [ $(pro status --format yaml | grep 'attached: true' | wc -l) -eq 0 ]; then
  echo "Attaching to Ubuntu Pro subscription..."
  sudo sed -i 's/--wait-for-startup --timeout 300 //' /opt/nvidia/dgx-oobe/ubuntu-pro-activate.sh
  sudo systemctl restart dgx-oobe-ubuntu-pro-activate.service
else
  echo "Already attached to Ubuntu Pro subscription."
fi

##########################################################
# Enable Additional Cockpit Plugins

# Install cockpit-sensors plugin
wget https://github.com/ocristopfer/cockpit-sensors/releases/latest/download/cockpit-sensors.tar.xz && \
  tar -xf cockpit-sensors.tar.xz cockpit-sensors/dist && \
  sudo mv cockpit-sensors/dist /usr/share/cockpit/sensors && \
  rm -r cockpit-sensors && \
  rm cockpit-sensors.tar.xz

# Install cockpit-dockermanager plugin
curl -L -o dockermanager.deb https://github.com/chrisjbawden/cockpit-dockermanager/releases/download/latest/dockermanager.deb
sudo dpkg -i dockermanager.deb
rm dockermanager.deb

###########################################################
# Enable Services
sudo systemctl enable --now cockpit.socket

############################################################
# Create needed directories
sudo mkdir -p /opt/workdir/{llm-cache/{huggingface,ollama,tiktoken,tiktoken-encodings},models,logs}

# Enable passwordless sudo for users in sudo group
sudo sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g'

# Install nv-monitor
if [ ! -f "/usr/local/bin/nv-monitor" ]; then
  echo "- Installing nv-monitor..."
  sudo curl -L -o /usr/local/bin/nv-monitor https://github.com/wentbackward/nv-monitor/releases/download/$NVMONITOR_VERSION/nv-monitor-linux-arm64
  sudo chmod +x /usr/local/bin/nv-monitor
else
  echo "- nv-monitor is already installed."
fi