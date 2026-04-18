#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

log_section "Curl-based installs"

# Source nvm/go/cargo — never pre-export NVM_DIR before sourcing
if [[ -s "$HOME/.nvm/nvm.sh" ]]; then source "$HOME/.nvm/nvm.sh"; fi
# Fallback: nvm sourced but default not set — find the latest installed node bin directly
if ! has npm; then
    _node_bin=$(ls -d "$HOME/.nvm/versions/node/"*/bin 2>/dev/null | sort -V | tail -1)
    if [[ -n "$_node_bin" ]]; then export PATH="$_node_bin:$PATH"; fi
fi
if [[ -f "$HOME/.cargo/env" ]]; then source "$HOME/.cargo/env"; fi
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
