#!/bin/bash

# Get rid of the wait for startup bit
sudo sed -i 's/--wait-for-startup --timeout 300 //' /opt/nvidia/dgx-oobe/ubuntu-pro-activate.sh

# Restart the service
sudo systemctl restart dgx-oobe-ubuntu-pro-activate.service
