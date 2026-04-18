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

# Download a GitHub release asset.
# URL template supports {VERSION} (e.g. v0.44.1) and {VER} (e.g. 0.44.1).
# If url_template is a plain URL with no placeholders, it is used as-is
# (works with /releases/latest/download/<stable-filename> URLs).
github_download() {
    local repo="$1" url_template="$2" dest="$3"
    local url="$url_template"
    if [[ "$url_template" == *"{VERSION}"* || "$url_template" == *"{VER}"* ]]; then
        log_info "Resolving latest version for $repo"
        local response version
        response=$(curl -sf "https://api.github.com/repos/$repo/releases/latest" || true)
        if echo "$response" | grep -q "API rate limit"; then
            log_error "GitHub API rate limit exceeded. Wait and retry."
            return 1
        fi
        version=$(echo "$response" | grep -oP '"tag_name":\s*"\K[^"]*' | head -1)
        if [[ -z "$version" ]]; then
            log_error "Could not determine latest version for $repo (response: ${response:0:200})"
            return 1
        fi
        local ver_no_v="${version#v}"
        url="${url_template/\{VERSION\}/$version}"
        url="${url/\{VER\}/$ver_no_v}"
    fi
    log_info "Downloading $url"
    curl -fSL "$url" -o "$dest"
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
