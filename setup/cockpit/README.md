# Cockpit

Cockpit is a great little Web UI for managing and monitoring your Linux systems.  It's available on pretty much every distro and it's often very useful especially if you don't want to sift through the state and configuration of your system via the many many CLI binaries.

You can simply install and enable Cockpit, or you can go the extra mile and add in some extra Plugins that will make your life easier such as monitoring hardware sensors and basic Docker management:

```bash
# Install Cockpit
apt install cockpit cockpit-storaged -y

# Install cockpit-sensors plugin
wget https://github.com/ocristopfer/cockpit-sensors/releases/latest/download/cockpit-sensors.tar.xz && \
  tar -xf cockpit-sensors.tar.xz cockpit-sensors/dist && \
  mv cockpit-sensors/dist /usr/share/cockpit/sensors && \
  rm -r cockpit-sensors && \
  rm cockpit-sensors.tar.xz

# Install cockpit-dockermanager plugin
curl -L -o dockermanager.deb https://github.com/chrisjbawden/cockpit-dockermanager/releases/download/latest/dockermanager.deb && dpkg -i dockermanager.deb && rm dockermanager.deb

###########################################################
# Enable the Cockpit Service
systemctl enable --now cockpit.socket
```

With that you should be able to access the Cockpit dashboard from `https://YOUR_SPARK_IP:9090/` and by logging in with your Linux credentials.
