#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

log_section "External APT repositories"

# --- VSCodium ---
if ! has codium; then
    log_info "Adding VSCodium repo"
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
        | sudo gpg --dearmor --yes -o /usr/share/keyrings/vscodium-archive-keyring.gpg
    echo 'deb [signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] https://download.vscodium.com/debs vscodium main' \
        | sudo tee /etc/apt/sources.list.d/vscodium.list >/dev/null
fi

# --- Signal ---
if ! has signal-desktop; then
    log_info "Adding Signal repo"
    wget -qO - https://updates.signal.org/desktop/apt/keys.asc \
        | sudo gpg --dearmor --yes -o /usr/share/keyrings/signal-desktop-keyring.gpg
    echo "deb [arch=${ARCH_ALT} signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" \
        | sudo tee /etc/apt/sources.list.d/signal.list >/dev/null
fi

# --- Element ---
if ! has element-desktop; then
    log_info "Adding Element repo"
    wget -qO - https://packages.element.io/debian/element-io-archive-keyring.gpg \
        | sudo gpg --dearmor --yes -o /usr/share/keyrings/element-io-archive-keyring.gpg
    echo 'deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main' \
        | sudo tee /etc/apt/sources.list.d/element.list >/dev/null
fi

# --- GitHub CLI ---
if ! has gh; then
    log_info "Adding GitHub CLI repo"
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=${ARCH_ALT} signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
fi

sudo apt-get update

apt_install codium signal-desktop element-desktop gh

log_success "External repo packages installed"
