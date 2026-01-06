# Remote Desktop

While I have this system sitting on my desk, I don't really want to KVM around between it - but I still want to be able to use the remote desktop for GUI things.  I like the pointy clicky.

## System Configuration

To set it up on the DGX OS you have to configure the system for it and the GNOME GUI tooling for Remote Desktop settings seems to not do the trick.  So here are the commands to get it working.

```bash
###### Add your user to the needed groups
sudo usermod -aG render $USER
sudo usermod -aG video $USER

###### Install a thing to make certs with the CLI
sudo apt install -y winpr3-utils

###### Set a Username and Password
RDP_USER="${USER}"
RDP_PASS="notPassw0rd"

###### For Screen Sharing
# Create a key
winpr-makecert3 -silent -rdp -path ~/.local/share/gnome-remote-desktop/ rdp-tls

# Configure the service with the key files
grdctl rdp set-tls-key ~/.local/share/gnome-remote-desktop/rdp-tls.key
grdctl rdp set-tls-cert ~/.local/share/gnome-remote-desktop/rdp-tls.crt
# Enable and set the credentials and allow control
grdctl rdp set-credentials "${RDP_USER}" "${RDP_PASS}"
grdctl rdp enable
grdctl rdp disable-view-only

###### For headless RDP
# Create a key
# This funny squiggly path prefix is intentional
sudo -u gnome-remote-desktop winpr-makecert3 -silent -rdp -path ~gnome-remote-desktop rdp-tls
# Configure the service with the key files
sudo grdctl --system rdp set-tls-key ~gnome-remote-desktop/rdp-tls.key
sudo grdctl --system rdp set-tls-cert ~gnome-remote-desktop/rdp-tls.crt
# Enable and set the username and password
sudo grdctl --system rdp enable
sudo grdctl --system rdp set-credentials "${RDP_USER}" "${RDP_PASS}"

###### Configure SystemD and Permissions
sudo systemctl --now enable gnome-remote-desktop.service
chown -R gnome-remote-desktop: /var/lib/gnome-remote-desktop
sudo chown -R gnome-remote-desktop: /var/lib/gnome-remote-desktop

###### Restart the RDP service
sudo systemctl restart gnome-remote-desktop.service
```

## Remote Desktop Connection Configuration

It seems as if when you connect to the system via GNOME RDP, at least on Mac with the Microsoft Remote Desktop tool - you have to create the connection, export it, then replace a value, and finally reimport it to successfully connect.

I can't take credit for the fix, I found it here: https://dev.to/emile1636/rdp-error-code-0x207-on-mac-for-ubuntu-24-d6d

I will copy the jist of the steps below for preservation's sake:

1. 'Add PC' in Microsoft Windows App (previously called Remote Desktop for Mac) with all changes that you'd like eg Friendly name, credentials, etc.
2. Export the Connection to your system
3. Open that exported file in a text editor
4. Find the line with `use redirection server name:i:0` and change it to `use redirection server name:i:1`
5. Save, then import into the Windows RDP for Mac app or whatever it's called
6. Connect
7. ???????
8. PROFIT!!!!!1
