# Usage example:
# docker build -t nvim-dev .
# docker run --gpus all -it -v ~/.config/nvim:/home/ubuntu/.config/nvim -v $(pwd):/workspace nvim-dev /bin/bash

# FROM nvidia/cuda:12.9.1-devel-ubuntu24.04
FROM ubuntu:24.04

# Define build arguments for better maintainability
ARG NEOVIM_VERSION=0.11.3
ARG USERNAME=user
ARG USER_EMAIL=email

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

# Switch to non-root user
USER ${USERNAME}

# Configure Git settings for the user
RUN git config --global user.name "${USERNAME}" && \
    git config --global user.email "${USER_EMAIL}"

# Set working directory to the mounted workspace
WORKDIR /workspace

# Set default shell to bash
ENV SHELL=/bin/bash

# ********************************************************
# * Anything else you want to do goes here *
# ********************************************************

