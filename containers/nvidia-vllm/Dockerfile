# This container is built due to how the NVIDIA VLLM container is baked as root without a user 1001 defined in the system config.
# This container adds a user and group with UID and GID 1001 to allow for root-less operation.
# Without this if you specify a non-root user you will get KeyError: 'getpwuid(): uid not found'
# There is the default non-root ubuntu user present with UID/GID 1000, but shared services use 1001 since your local user account is often 1000.

# docker build -t nvidia-vllm:25.12-py3 -f Containerfile.nvidia-vllm .

ARG BASE_IMAGE=nvcr.io/nvidia/vllm
ARG BASE_TAG=25.12-py3
FROM ${BASE_IMAGE}:${BASE_TAG}

ARG UID=1001
ARG GID=1001
ARG USERNAME=app
ARG USER_HOME=/app

# Do a basic update and cleanup
RUN apt update -y && apt autoremove -y && apt clean -y

# Add user/group
ENV HOME=$USER_HOME
RUN if [ $UID -ne 0 ]; then \
      if [ $GID -ne 0 ]; then \
        groupadd --system --gid ${GID} ${USERNAME}; \
      fi; \
      useradd --system --uid ${UID} --gid ${GID} \
      --home ${USER_HOME} --shell /bin/bash ${USERNAME}; \
    fi

# Handle paths
RUN mkdir --parents $HOME /app/{.cache,.local/bin} && chown --recursive $UID:$GID $HOME /app && chmod -R 775 /app
ENV PATH="/app/.local/bin:/app:${PATH}"

# Switch user 
USER $UID:$GID