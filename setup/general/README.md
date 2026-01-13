# General Helpful Things

The following won't "make or break" things, but they certainly make things easier (at least for me).

- [Shared AI Services User](#shared-ai-services-user)
- [Cache Directory](#cache-directory)
- [Software Runtimes](#software-runtimes)
  - [UV - Python Package Manager](#uv---python-package-manager)
  - [Golang](#golang)
  - [NVM - Node Version Manager](#nvm---node-version-manager)

## Shared AI Services User

I like having file/process permissions kinda tight - this is especially important with AI things since we see new vulnerabilities and vectors every day.  Keeping things from running as root is usually a good idea so to align permissions across a variety of things I like to make a dedicated user for it.

```bash
# Make a dedicated AI Services user with a specific UID, make its home dir, give it a shell and a name
sudo useradd -u 1001 -m -s /bin/bash aisvcs

# Add that user to the docker group
sudo usermod -aG docker aisvcs
```

## Cache Directory

When downloading models you'll often download multi-gig blobs and they're typically stored in a directory under your home directory.

When doing this repeatedly you want to cache them under similar paths - very important when running models as containers and with different runtimes.

I set up a cache directory to be used to speed things up and keep the hard drive clean:

```bash
# Base cache directory
mkdir -p /opt/workdir/llm-cache

# Key cache directories
mkdir -p /opt/workdir/llm-cache/{huggingface/hub,ollama,tiktoken,tiktoken-encodings,torchinductor,vllm}

# Common Environmental overrides
export HF_HOME=/llm-cache/huggingface
export TORCHINDUCTOR_CACHE_DIR=/llm-cache/torchinductor
export TIKTOKEN_RS_CACHE_DIR=/llm-cache/tiktoken
export TIKTOKEN_ENCODINGS_BASE=/llm-cache/tiktoken-encodings

# For VLLM - do not set in your local user, only used for containers
export XDG_CONFIG_HOME=/llm-cache/vllm
export XDG_CACHE_HOME=/llm-cache
```

## Software Runtimes

While I do try to run everything on here via containers for ease, consistency, portability, and general system hygene, there are times where system-local runtimes are useful.  Namely when I need to test/run something really quickly or while I'm vibe coding and developing on the system.

### UV - Python Package Manager

- https://github.com/astral-sh/uv

```bash
# One-shot
curl -LsSf https://astral.sh/uv/install.sh | sh
```

This allows for shortcutting `nvitop` for CLI GPU metrics:

```bash
# "Install nvitop" via uv
echo 'alias nvitop="uvx nvitop"' >> ~/.bashrc
```

### Golang

I develop a lot via Golang sooo...

```bash
# Set a version
GOLANG_VERSION="1.25.5"

# Download
wget https://go.dev/dl/go${GOLANG_VERSION}.linux-arm64.tar.gz

# Remove old versions and install this new version
rm -rf /usr/local/go && tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz

# Set it to your path (globally)
echo 'export PATH=$PATH:/usr/local/go/bin' > /etc/profile.d/golang.sh

# Set it to your path (local)
echo 'export PATH=$PATH:/usr/local/go/bin' > ~/.bashrc
```

### NVM - Node Version Manager

And of course for my frontends I use NodeJS...managing the versions is much easier with NVM:

```bash
# Set Version
NVM_VERSION="v0.40.3"

# Oneshot install
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

# Install a version and switch to it
nvm install v22.21.1
nvm use v22.21.1
```