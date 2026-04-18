#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

log_section "Symlinking dotfiles"

# --- XDG config dirs ---
config_link "hypr"        "$HOME/.config/hypr"
config_link "alacritty"   "$HOME/.config/alacritty"
config_link "waybar"      "$HOME/.config/waybar"
config_link "wofi"        "$HOME/.config/wofi"
config_link "btop"        "$HOME/.config/btop"
config_link "starship.toml" "$HOME/.config/starship.toml"

# --- Neovim (kickstart.nvim) ---
if [[ ! -d "$HOME/.config/nvim" ]]; then
    log_info "Cloning kickstart.nvim"
    git clone https://github.com/nvim-lua/kickstart.nvim.git "$HOME/.config/nvim"
    log_success "kickstart.nvim installed"
else
    log_info "nvim config already exists"
fi

# --- Bash additions ---
config_link "bashrc.d" "$HOME/.config/bashrc.d"

BASHRC_HOOK='# dotfiles2
for f in ~/.config/bashrc.d/*.sh; do [[ -f "$f" ]] && source "$f"; done'

if ! grep -qF "bashrc.d" "$HOME/.bashrc" 2>/dev/null; then
    echo "" >> "$HOME/.bashrc"
    echo "$BASHRC_HOOK" >> "$HOME/.bashrc"
    log_success "Added bashrc.d hook to ~/.bashrc"
else
    log_info "bashrc.d hook already in ~/.bashrc"
fi

# --- Private configs ---
if [[ -d "$DOTFILES_DIR/private/ssh" ]]; then
    config_link "../private/ssh" "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    chmod 600 "$HOME/.ssh/"* 2>/dev/null || true
    log_success "SSH config linked"
fi

if [[ -d "$DOTFILES_DIR/private/gnupg" ]]; then
    config_link "../private/gnupg" "$HOME/.gnupg"
    chmod 700 "$HOME/.gnupg"
    log_success "GPG config linked"
fi

if [[ -f "$DOTFILES_DIR/private/gitconfig" ]]; then
    config_link "../private/gitconfig" "$HOME/.gitconfig"
    log_success "Git config linked"
fi

# --- bin/ scripts ---
if [[ -d "$DOTFILES_DIR/bin" ]]; then
    chmod +x "$DOTFILES_DIR/bin/"* 2>/dev/null || true
    log_success "bin/ scripts marked executable"
fi

log_success "Dotfiles linked"
