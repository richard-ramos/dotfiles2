#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

log_section "System configuration"

# --- UFW ---
if has ufw; then
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw --force enable
    log_success "UFW configured"
fi

# --- Thermald ---
if dpkg -s thermald &>/dev/null; then
    sudo systemctl enable --now thermald
    log_success "Thermald enabled"
fi

# --- SSH ---
if dpkg -s openssh-server &>/dev/null; then
    sudo systemctl enable --now ssh
    log_success "SSH enabled"
fi

# --- lm-sensors ---
if has sensors; then
    sudo sensors-detect --auto >/dev/null 2>&1 || true
    log_success "Sensors configured"
fi

# --- Ollama service ---
if has ollama; then
    sudo systemctl enable --now ollama 2>/dev/null || true
    log_success "Ollama service enabled"
fi

log_success "System config done"
