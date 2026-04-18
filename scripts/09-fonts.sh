#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

log_section "Fonts"

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

if ! fc-list | grep -qi "FiraMono Nerd"; then
    log_info "Installing FiraMono Nerd Font"
    gh_release_download "ryanoasis/nerd-fonts" "FiraMono.tar.xz" /tmp/FiraMono.tar.xz
    mkdir -p /tmp/FiraMono
    tar -xf /tmp/FiraMono.tar.xz -C /tmp/FiraMono
    cp /tmp/FiraMono/*.ttf "$FONT_DIR/" 2>/dev/null || cp /tmp/FiraMono/*.otf "$FONT_DIR/" 2>/dev/null || true
    fc-cache -f
    rm -rf /tmp/FiraMono /tmp/FiraMono.tar.xz
    log_success "FiraMono Nerd Font installed"
else
    log_info "FiraMono Nerd Font already installed"
fi
