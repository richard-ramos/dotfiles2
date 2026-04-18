#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

log_section "Base APT packages"

sudo apt-get update

apt_install \
    openssh-server gnupg git neovim wl-clipboard firefox ufw \
    bash-completion fzf ripgrep fd-find bat btop brightnessctl \
    iwd lm-sensors inxi evince vlc imagemagick wget thermald \
    build-essential cmake pkg-config curl unzip zip unrar \
    tmux htop iotop iftop s-tui jq net-tools powertop \
    flatpak pipx python3-pip \
    xournalpp libreoffice \
    blender gimp flameshot transmission keepassxc

log_success "Base APT packages installed"
