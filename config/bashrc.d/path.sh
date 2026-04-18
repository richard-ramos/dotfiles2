# Dotfiles bin
DOTFILES_BIN="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/bin"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/go/bin:$HOME/go/bin:$HOME/.nimble/bin:$HOME/.ghcup/bin:$HOME/.cabal/bin:$DOTFILES_BIN:$PATH"

export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=alacritty
