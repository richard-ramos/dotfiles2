#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
export DOTFILES_DIR

source "$DOTFILES_DIR/lib/common.sh"

usage() {
    echo "Usage: $0 [--all | --only <script> | --from <step-number>]"
    echo "  --all           Run all scripts (default)"
    echo "  --only <name>   Run only the named script (e.g. 05-languages.sh)"
    echo "  --from <num>    Run scripts starting from step number (e.g. 5)"
    exit 1
}

MODE="all"
TARGET=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --all)  MODE="all"; shift ;;
        --only) MODE="only"; TARGET="$2"; shift 2 ;;
        --from) MODE="from"; TARGET="$2"; shift 2 ;;
        -h|--help) usage ;;
        *) log_error "Unknown option: $1"; usage ;;
    esac
done

succeeded=()
failed=()

for script in "$DOTFILES_DIR"/scripts/[0-9]*.sh; do
    step_name="$(basename "$script")"
    step_num="${step_name%%-*}"
    step_num=$((10#$step_num))

    case "$MODE" in
        only)
            [[ "$step_name" != "$TARGET" ]] && continue
            ;;
        from)
            [[ "$step_num" -lt "$TARGET" ]] && continue
            ;;
    esac

    log_section "Running $step_name"
    if bash "$script"; then
        log_success "$step_name completed"
        succeeded+=("$step_name")
    else
        log_error "$step_name failed"
        failed+=("$step_name")
    fi
done

echo ""
log_section "Summary"
for s in "${succeeded[@]}"; do
    log_success "$s"
done
for f in "${failed[@]}"; do
    log_error "$f"
done

if [[ ${#failed[@]} -gt 0 ]]; then
    echo ""
    log_warn "${#failed[@]} script(s) failed. Re-run with --from <step> to retry."
    exit 1
fi

log_success "All done!"
