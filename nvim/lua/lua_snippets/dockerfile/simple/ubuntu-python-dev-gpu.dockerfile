# docker build . -t sample-dev

# docker run \
#   --privileged \
#   --net=host \
#   --pid=host \
#   --ipc=host \
#   --gpus all \
#   --runtime=nvidia \
#   -e DISPLAY=:0 \
#   -e XAUTHORITY=/home/developer/.Xauthority \
#   -e TERM=screen-256color \
#   -v ~/.config/nvim:/home/developer/.config/nvim \
#   -v ~/.tmux.conf:/home/developer/.tmux.conf \
#   -v ~/.Xauthority:/home/developer/.Xauthority \
#   -v /tmp/.X11-unix:/tmp/.X11-unix:cached \
#   -v "$(pwd)":/workspace \
#   -n sample-devcontainer \
#   -it sample-dev \
#   bash


# FROM nvidia/cuda:12.9.1-devel-ubuntu24.04
# FROM ros:jazzy
FROM ubuntu:24.04

# Define build arguments for better maintainability
ARG NEOVIM_VERSION=0.11.4
ARG USERNAME=developer

# Set up container user
RUN if id -u 1000 ; then userdel `id -un 1000` ; fi
RUN groupadd --gid 1000 $USERNAME \
    && useradd --uid 1000 --gid 1000 -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# System upgrade
RUN apt-get update && \
    apt-get upgrade -y

# Install helper tools (tmux, nvtop, htop, ripgrep)
RUN apt-get update && \
    apt-get install -y \
        htop \
        nvtop \
        ripgrep \
        tmux

# Install Neovim build dependencies
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        cmake \
        curl \
        gettext \
        git \
        npm \
        python3-venv \
        unzip

# Build and install Neovim from source
RUN curl -L "https://github.com/neovim/neovim/archive/refs/tags/v${NEOVIM_VERSION}.zip" -o /tmp/neovim.zip && \
    unzip /tmp/neovim.zip -d /tmp/ && \
    cd "/tmp/neovim-${NEOVIM_VERSION}" && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    make install && \
    rm -rf /tmp/neovim*

# Copy UV package manager
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install D2 using the official script
RUN curl -fsSL https://d2lang.com/install.sh | sh -s

# Switch to non-root user
USER ${USERNAME}

ARG GIT_USER=developer
ARG GIT_EMAIL=no@mail.com

# Configure Git settings for the user
RUN git config --global user.name "${GIT_USER}" && \
    git config --global user.email "${GIT_EMAIL}"

# Set working directory to the mounted workspace
WORKDIR /workspace

# Set default shell to bash
ENV SHELL=/bin/bash

# ********************************************************
# * Anything else you want to do goes here *
# ********************************************************
