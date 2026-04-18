#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

log_section "pip/pipx tools"

if ! has tzupdate; then
    if has pipx; then
        pipx install tzupdate
    else
        pip install --user tzupdate
    fi
fi

log_success "pip tools installed"
