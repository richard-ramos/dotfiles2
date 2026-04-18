#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

log_section "Curl-based installs"

# Source nvm/go/cargo if available
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
elif [[ -d "$NVM_DIR/versions/node" ]]; then
    # nvm.sh missing but node installed — add to PATH directly
    NODE_DIR=$(ls -d "$NVM_DIR/versions/node/"* 2>/dev/null | sort -V | tail -1)
    [[ -n "$NODE_DIR" ]] && export PATH="$NODE_DIR/bin:$PATH"
fi
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

if ! has npm; then
    log_error "npm not found. Run 05-languages.sh first to install Node.js."
    exit 1
fi

# --- Starship ---
if ! has starship; then
    log_info "Installing Starship"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# --- Ollama ---
if ! has ollama; then
    log_info "Installing Ollama"
    curl -fsSL https://ollama.com/install.sh | sh
fi

# --- Claude Code ---
if ! has claude; then
    log_info "Installing Claude Code"
    npm install -g @anthropic-ai/claude-code
fi

# --- Codex ---
if ! has codex; then
    log_info "Installing OpenAI Codex"
    npm install -g @openai/codex
fi

# --- OpenCode ---
if ! has opencode; then
    log_info "Installing OpenCode"
    go install github.com/opencode-ai/opencode@latest
fi

log_success "Curl installs done"
