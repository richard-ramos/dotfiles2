#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

log_section "GitHub release binaries"

INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# --- lazygit ---
if ! has lazygit; then
    log_info "Installing lazygit"
    github_download "jesseduffield/lazygit" \
        "https://github.com/jesseduffield/lazygit/releases/download/{VERSION}/lazygit_{VER}_Linux_${ARCH}.tar.gz" \
        /tmp/lazygit.tar.gz
    tar -xzf /tmp/lazygit.tar.gz -C /tmp lazygit
    mv /tmp/lazygit "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/lazygit"
    rm -f /tmp/lazygit.tar.gz
fi

# --- lazydocker ---
if ! has lazydocker; then
    log_info "Installing lazydocker"
    github_download "jesseduffield/lazydocker" \
        "https://github.com/jesseduffield/lazydocker/releases/download/{VERSION}/lazydocker_{VER}_Linux_${ARCH}.tar.gz" \
        /tmp/lazydocker.tar.gz
    tar -xzf /tmp/lazydocker.tar.gz -C /tmp lazydocker
    mv /tmp/lazydocker "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/lazydocker"
    rm -f /tmp/lazydocker.tar.gz
fi

# --- fastfetch (stable filename, no version needed) ---
if ! has fastfetch; then
    log_info "Installing fastfetch"
    github_download "fastfetch-cli/fastfetch" \
        "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-${ARCH_ALT}.deb" \
        /tmp/fastfetch.deb
    sudo dpkg -i /tmp/fastfetch.deb
    rm -f /tmp/fastfetch.deb
fi

# --- ufw-docker ---
if [[ ! -f /usr/local/bin/ufw-docker ]]; then
    log_info "Installing ufw-docker"
    sudo curl -fSL https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker \
        -o /usr/local/bin/ufw-docker
    sudo chmod +x /usr/local/bin/ufw-docker
fi

log_success "GitHub release binaries installed"
