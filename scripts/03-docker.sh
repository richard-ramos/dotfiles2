#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

log_section "Docker"

if has docker; then
    log_info "Docker already installed"
else
    log_info "Adding Docker repo"
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings

    # Detect distro for repo URL (works for Ubuntu and Debian)
    DISTRO_ID=$(. /etc/os-release && echo "$ID")
    sudo curl -fsSL "https://download.docker.com/linux/${DISTRO_ID}/gpg" \
        -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo "deb [arch=${ARCH_ALT} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/${DISTRO_ID} \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
        | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    sudo apt-get update
    apt_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# Add current user to docker group
if ! groups "$USER" | grep -q docker; then
    log_info "Adding $USER to docker group"
    sudo usermod -aG docker "$USER"
    log_warn "Log out and back in for docker group to take effect"
fi

log_success "Docker installed"
