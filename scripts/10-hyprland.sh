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

# --- awww (wallpaper daemon, built from source) ---
if ! has awww; then
    if [[ -f "$HOME/.cargo/env" ]]; then source "$HOME/.cargo/env"; fi
    if has cargo; then
        apt_install libwayland-dev wayland-protocols liblz4-dev
        log_info "Building awww from source (codeberg)"
        tmpdir=$(mktemp -d)
        git clone --depth 1 https://codeberg.org/LGFae/awww.git "$tmpdir"
        cargo build --release --manifest-path "$tmpdir/Cargo.toml"
        cp "$tmpdir/target/release/awww" "$tmpdir/target/release/awww-daemon" \
            "$HOME/.local/bin/"
        rm -rf "$tmpdir"
    else
        log_warn "awww requires cargo (Rust 1.87+); install Rust first"
    fi
fi

# --- gpu-screen-recorder ---
if ! has gpu-screen-recorder; then
    log_warn "gpu-screen-recorder: install manually from https://github.com/dec05eba/gpu-screen-recorder"
fi

log_success "Hyprland ecosystem setup done"
