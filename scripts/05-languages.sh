#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

log_section "Programming languages"

# --- Go ---
if ! has go; then
    log_info "Installing Go"
    GO_VERSION=$(curl -sL 'https://go.dev/VERSION?m=text' | head -1)
    curl -sL "https://go.dev/dl/${GO_VERSION}.linux-${ARCH_ALT}.tar.gz" -o /tmp/go.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz
    export PATH="/usr/local/go/bin:$PATH"
fi
log_success "Go: $(go version)"

# --- Rust ---
if ! has rustup; then
    log_info "Installing Rust via rustup"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi
log_success "Rust: $(rustc --version)"

# --- Nim ---
if ! has nim; then
    log_info "Installing Nim via choosenim"
    curl https://nim-lang.org/choosenim/init.sh -sSf | sh -s -- -y
    export PATH="$HOME/.nimble/bin:$PATH"
fi
log_success "Nim: $(nim --version | head -1)"

# --- Haskell ---
if ! has ghcup; then
    log_info "Installing Haskell via ghcup"
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | \
        BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh
    source "$HOME/.ghcup/env"
fi
log_success "GHC: $(ghc --version)"

# --- Node.js (via nvm, needed for claude/codex) ---
if ! has node; then
    log_info "Installing Node.js via nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
    nvm install --lts
fi
log_success "Node: $(node --version)"
