#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

log_section "Curl-based installs"

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
