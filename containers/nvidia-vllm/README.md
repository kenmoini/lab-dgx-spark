# NVIDIA VLLM

This is a custom build of the NVIDIA VLLM container that runs package updates and adds a non-root user.

In a production environment (and generally as a best practice...) you should try to avoid running containers as root users.  This is generally a good idea, even more so with AI things since you don't want it to go off the rails - and we find new and exciting vulnerabilities in these stacks every day so ya know, nice to not get hacked because of some bad Python package.

This container adds a user and group with UID and GID 1001 to allow for root-less operation.

Without this if you specify a non-root user you will get KeyError: 'getpwuid(): uid not found' for many Python things

There is the default non-root ubuntu user present with UID/GID 1000, but shared services use 1001 since your local user account is often 1000.

## Building

```bash
docker build -t nvidia-vllm:25.12-py3 -f Containerfile.nvidia-vllm .
```

There are build arguments that can be passed to override versions of the build:

```bash
BASE_IMAGE=nvcr.io/nvidia/vllm
BASE_TAG=25.12-py3

docker build -t nvidia-vllm:${BASE_TAG} -f Dockerfile .
```
