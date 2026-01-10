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

##########################################################
# Enable needed repos
add-apt-repository universe

# Not supported for Ubuntu 24.04 yet
# curl -sSL https://repo.45drives.com/setup | bash

##########################################################
# Install needed system packages
apt install -y curl wget git \
  winpr3-utils \
  uidmap dbus-user-session docker-ce-rootless-extras fuse-overlayfs \
  cockpit cockpit-navigator lm-sensors \
  cockpit-machines

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm list-remote
nvm install v22.21.1

##########################################################
# Fix Ubuntu Pro Script
sed -i 's/--wait-for-startup --timeout 300 //' /opt/nvidia/dgx-oobe/ubuntu-pro-activate.sh
systemctl restart dgx-oobe-ubuntu-pro-activate.service

##########################################################
# Enable Additional Cockpit Plugins

# Install cockpit-sensors plugin
wget https://github.com/ocristopfer/cockpit-sensors/releases/latest/download/cockpit-sensors.tar.xz && \
  tar -xf cockpit-sensors.tar.xz cockpit-sensors/dist && \
  mv cockpit-sensors/dist /usr/share/cockpit/sensors && \
  rm -r cockpit-sensors && \
  rm cockpit-sensors.tar.xz

# Install cockpit-dockermanager plugin
curl -L -o dockermanager.deb https://github.com/chrisjbawden/cockpit-dockermanager/releases/download/latest/dockermanager.deb && dpkg -i dockermanager.deb && rm dockermanager.deb

###########################################################
# Enable Services
systemctl enable --now cockpit.socket

############################################################
# Create needed directories
mkdir -p /opt/workdir/{vllm-cache/{tiktoken,tiktoken-encodings},models,logs}