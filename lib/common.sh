#!/usr/bin/env bash

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export DOTFILES_DIR

ARCH="$(uname -m)"
case "$ARCH" in
    x86_64)  ARCH_ALT="amd64" ;;
    aarch64) ARCH_ALT="arm64" ;;
    *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac
export ARCH ARCH_ALT

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log_section() { echo -e "\n${BLUE}${BOLD}==> $1${NC}"; }
log_info()    { echo -e "${BOLD}  -> $1${NC}"; }
log_success() { echo -e "${GREEN}  ✓ $1${NC}"; }
log_warn()    { echo -e "${YELLOW}  ! $1${NC}"; }
log_error()   { echo -e "${RED}  ✗ $1${NC}"; }

has() { command -v "$1" &>/dev/null; }

apt_install() {
    local to_install=()
    for pkg in "$@"; do
        if ! dpkg -s "$pkg" &>/dev/null; then
            to_install+=("$pkg")
        fi
    done
    if [[ ${#to_install[@]} -gt 0 ]]; then
        log_info "Installing: ${to_install[*]}"
        sudo apt-get install -y "${to_install[@]}"
    else
        log_info "Already installed: $*"
    fi
}

gh_release_download() {
    local repo="$1" pattern="$2" dest="$3"
    local url
    if has gh; then
        url=$(gh release view --repo "$repo" --json assets -q \
            ".assets[].url | select(test(\"${pattern}\"))" 2>/dev/null | head -1)
        if [[ -n "$url" ]]; then
            log_info "Downloading $url"
            curl -sL "$url" -o "$dest"
            return 0
        fi
    fi
    url=$(curl -sL "https://api.github.com/repos/$repo/releases/latest" \
        | grep -oP "\"browser_download_url\":\s*\"\\K[^\"]*${pattern}[^\"]*" | head -1)
    if [[ -z "$url" ]]; then
        log_error "Could not find release asset matching '$pattern' for $repo"
        return 1
    fi
    log_info "Downloading $url"
    curl -sL "$url" -o "$dest"
}

config_link() {
    local src="$DOTFILES_DIR/config/$1"
    local dst="$2"
    if [[ -L "$dst" ]]; then
        log_info "Already linked: $dst"
        return 0
    fi
    if [[ -e "$dst" ]]; then
        log_warn "Backing up existing $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    log_success "Linked $src -> $dst"
}
