# Docker Setup

So Docker comes preloaded on DGX OS - it's fine.  I prefer Podman but I'd rather just use the "integrated tooling" instead of tinkering with things.

To get it rolling though there's probably a couple things you want to configure...

## User & Group Initialization

Once you log in, you'll need to add your user to the `docker` group to use Docker without root (note this is not rootless):

```bash
# Add yourself to the docker group
sudo usermod -aG docker $USER

# Load the group into your current session
newgrp docker

# Test docker
docker info
```

## NVIDIA Container Toolkit Setup

Another thing ya gotta do is add some hooks into Docker for NVIDIA things to work right:

```bash
# Setup CTK for ContainerD
sudo nvidia-ctk runtime configure --runtime=containerd
sudo systemctl restart containerd

# Setup CTK for docker engine
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

## Docker Daemon Configuration

Once CTK is enabled, you can also enable a couple other things in the Docker Daemon before you get too far along the path - this mostly is to handle observability (if you're into that sorta thing)...your `/etc/docker/daemon.json` should look like this:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "metrics-addr": "0.0.0.0:9323",
  "runtimes": {
    "nvidia": {
      "args": [],
      "path": "nvidia-container-runtime"
    }
  }
}
```

Part of it configures how the container logs are store, then enabled daemon metrics that can be scraped by Prometheus.

Once that configuration is set, don't forget to restart docker: `systemctl restart docker.socket docker.service`
