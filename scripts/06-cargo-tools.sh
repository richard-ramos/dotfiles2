#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

if [[ -f "$HOME/.cargo/env" ]]; then source "$HOME/.cargo/env"; fi

if ! has cargo; then
    log_error "Cargo not found. Run 05-languages.sh first."
    exit 1
fi

log_section "Cargo tools"

# Build dependencies for bluetui (dbus), alacritty, etc.
apt_install libdbus-1-dev

cargo_install() {
    local bin="$1" crate="${2:-$1}"
    if has "$bin"; then
        log_info "Already installed: $bin"
    else
        log_info "cargo install $crate"
        cargo install "$crate"
    fi
}

cargo_install eza
cargo_install dust du-dust
cargo_install zoxide
cargo_install tldr tealdeer
cargo_install bluetui
cargo_install impala

# --- Alacritty (build from source) ---
if ! has alacritty; then
    log_info "Installing alacritty build dependencies"
    apt_install libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev \
        pkg-config python3 scdoc

    log_info "Building alacritty from source"
    cargo install alacritty

    # Install terminfo and desktop entry
    tmpdir=$(mktemp -d)
    git clone --depth 1 https://github.com/alacritty/alacritty.git "$tmpdir"
    sudo tic -xe alacritty,alacritty-direct "$tmpdir/extra/alacritty.info" 2>/dev/null || true
    sudo cp "$tmpdir/extra/linux/Alacritty.desktop" /usr/share/applications/ 2>/dev/null || true
    sudo update-desktop-database /usr/share/applications/ 2>/dev/null || true
    rm -rf "$tmpdir"
fi

log_success "Cargo tools installed"
