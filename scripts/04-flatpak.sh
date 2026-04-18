#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

log_section "Flatpak setup"

if ! flatpak remotes | grep -q flathub; then
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

flatpak_install() {
    local app_id="$1"
    if flatpak list --app | grep -q "$app_id"; then
        log_info "Already installed: $app_id"
    else
        log_info "Installing $app_id"
        sudo flatpak install -y flathub "$app_id"
    fi
}

flatpak_install md.obsidian.Obsidian
flatpak_install com.github.PintaProject.Pinta
flatpak_install org.localsend.localsend_app

# Typora may not be on Flathub — try, warn on failure
if ! flatpak list --app | grep -q io.typora.Typora; then
    log_info "Attempting Typora flatpak..."
    if ! sudo flatpak install -y flathub io.typora.Typora 2>/dev/null; then
        log_warn "Typora not on Flathub — download .deb from https://typora.io"
    fi
fi

log_success "Flatpak apps installed"
