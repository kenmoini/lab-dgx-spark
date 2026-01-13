# lab-dgx-spark

> **tl;dr:** Resources to quickly bootstrap a DGX Spark (or other) AI machine for productivity - includes container and model management, reverse proxy, service portal, observability, and more!

## Who is this for?

Anyone with a DGX Spark system or a derrivitive - or another Ubuntu 24.04 system with an NVIDIA GPU in it.

While many of the exercises and tasks can be done on systems with other GPUs or even other distros of Linux, some things will be catered to the DGX Spark and that ecosystem.  Out of scope of this repo are other platforms.

## What's In It For Me?

- Tips to get the system up and running because it may not even boot out of the box!
- Where not to waste your time!
- Remote Desktop!
- Ubuntu Pro!
- Cockpit System Web UI!
- Docker Configuration!
- A simple and secure certificate (SSL/TLS) chain for doing AI security things!
- Portainer and Traefik Management Stack!
- Grafana/Prometheus Observability Stack for system dashboards!
- Custom built Llama Swap for hot swapping of models loaded as containers!
- LMStudio Developer Mode for serving models that way!
- Open WebUI for in-browser chatting!
- How to evaluate different models!

## Prerequisites

- A DGX Spark system, I use an MSI EdgXpert since it has better power and thermal management than the one from NVIDIA.
- A Static IP for accessing your services
- [Optional] A DNS zone with an A record going to the system as well as a `*.systemName.domain.tld` wildcard A record going to the system - or you can use your Static IP and something like traefik.me as is in these examples

## General Spark Information

### No Output?  Not turning on out of the box?  Reflash!

- You may need to find a spare USB thumb drive and reinstall DGX OS out of the box.  If you [search the forums](https://forums.developer.nvidia.com/t/my-dgx-spark-has-power-but-is-not-working/354584) you can find a lot of similar posts about how it won't turn on, it's got a black screen, etc.
- Mine exhibited similar behavior, and every now and then would show a rotating EFI thing - which told me it was at least POST'ing.
- To fix this I just had to go through the [System Recovery](https://docs.nvidia.com/dgx/dgx-spark/system-recovery.html) steps of downloading the install media, flashing it, checking out the BIOS (not too exciting), booting from the USB, reformatting, rebooting, and bam!  Got a lovely OOBE setup wizard that was expected.

### Initial Setup

Once it's booting, you'll need to connect it to a network, create a user, etc of course.

If you have another system you'll be connecting remotely to the Spark, then you'll want to download [NVIDIA AI Workbench](https://www.nvidia.com/en-us/deep-learning-ai/solutions/data-science/workbench/) first - then [NVIDIA Sync](https://build.nvidia.com/spark/connect-to-your-spark/sync) as detailed in the Onboarding guide.

After you have NVIDIA Sync set up, this is a good opportunity to simply load up the DGX Dashboard, run a quick System Update, then Set the Hostname which will trigger a reboot.  Of course you could also just do a `apt update && apt upgrade -y && hostnamectl hostname raichu && systemctl reboot`

Past that, I personally haven't used the Workbench or Sync much - the Open WebUI example in the guides that's supposed to run via NVIDIA Sync didn't work for me - this is when I decided to run it the way I normally would.

## Table of Contents

> Note: If you just want to start copy/pasting code and stuff, the `workdir` contains all the working scripts/configs that I use in it's general structure.  Below are individual topics broken out.

### Setup

- [Native GNOME Remote Desktop](./setup/remote-desktop/README.md)
- [DGX Dashboard Proxy Service](./setup/dgx-dash-proxy/README.md)
- ["Free" Ubuntu Pro](./setup/ubuntu-pro/README.md)
- [Installing Cockpit and Co](./setup/cockpit/README.md)
- [Install NVIDIA GPU Cloud CLI](./setup/ngc/README.md)
- [Docker Setup](./setup/docker/README.md)
- [Docker Proxy](./setup/docker-proxy/README.md)
- [General Helpful Things](./setup/general/README.md)

### Services

Once general setup is complete, you can begin to roll out some services that'll make this box useful.

- [Management Stack](./services/management/README.md)
- [Open WebUI](./services/open-webui/README.md)
- [Generic Ollama](./services/ollama/README.md)

### Custom Containers

You will inevitably need to make a series of different containers.  This could be because of mismatched Python packages (looking at you Torch*), system packages missing, or something not compiled for Arm64.  I've shared some in this repo:

- [llama.cpp](./containers/llama.cpp/)
- [NVIDIA VLLM](./containers/nvidia-vllm/README.md)