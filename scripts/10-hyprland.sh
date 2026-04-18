#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

log_section "Hyprland ecosystem"

# Attempt to install from repos (works on Ubuntu 24.10+, Debian Trixie+)
# On older Ubuntu, may need a PPA
HYPR_PKGS=(
    hyprland
    xdg-desktop-portal-hyprland
    waybar
    wofi
    dunst
    grim
    slurp
    polkit-gnome
    hyprlock
    hypridle
)

for pkg in "${HYPR_PKGS[@]}"; do
    if dpkg -s "$pkg" &>/dev/null; then
        log_info "Already installed: $pkg"
    else
        log_info "Attempting: $pkg"
        if sudo apt-get install -y "$pkg" 2>/dev/null; then
            log_success "$pkg installed"
        else
            log_warn "$pkg not in repos — may need PPA or manual build"
        fi
    fi
done

# --- swww (wallpaper daemon, cargo) ---
if ! has swww; then
    [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
    if has cargo; then
        log_info "Building swww via cargo"
        cargo install swww
    else
        log_warn "swww requires cargo; install Rust first"
    fi
fi

# --- gpu-screen-recorder ---
if ! has gpu-screen-recorder; then
    log_warn "gpu-screen-recorder: install manually from https://github.com/dec05eba/gpu-screen-recorder"
fi

log_success "Hyprland ecosystem setup done"
