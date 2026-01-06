# Ubuntu Pro

Did you know that the DGX Spark systems come with Ubuntu Pro that is good til 2036?!?!  That's longer than we'll probably be around!

I found this out while looking in Cockpit and saw the failed service...that failed to register the system for Ubuntu Pro.

The keys are baked into the systems and the script just extracts it and connects and yada yada - but the script's logic is a no so good eh?

Here's how you fix that:

```bash
# Get rid of the wait for startup bit
sudo sed -i 's/--wait-for-startup --timeout 300 //' /opt/nvidia/dgx-oobe/ubuntu-pro-activate.sh

# Restart the service
sudo systemctl restart dgx-oobe-ubuntu-pro-activate.service

# wait about 30s

# Check the status
sudo pro status

SERVICE          ENTITLED  STATUS       DESCRIPTION
anbox-cloud      yes       disabled     Scalable Android in the cloud
esm-apps         yes       enabled      Expanded Security Maintenance for Applications
esm-infra        yes       enabled      Expanded Security Maintenance for Infrastructure
fips-updates     yes       disabled     FIPS compliant crypto packages with stable security updates
landscape        yes       disabled     Management and administration tool for Ubuntu
realtime-kernel* yes       disabled     Ubuntu kernel with PREEMPT_RT patches integrated
usg              yes       disabled     Security compliance and audit tools

 * Service has variants

NOTICES
Limited to Ubuntu 24.04 LTS (Noble Numbat) and previous releases.

For a list of all Ubuntu Pro services and variants, run 'pro status --all'
Enable services with: pro enable <service>

                Account: nvidia-123456
           Subscription: Ubuntu Pro Desktop - One Time - 26.04 LTS
            Valid until: Sat May 31 19:59:59 2036 EDT
Technical support level: essential
```

Essential Support - ***cool!***  No clue what Ubuntu Pro is or does but hey, it's "free".