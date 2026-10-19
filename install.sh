#!/usr/bin/env bash
# Symlinks this repo's configs into place. Existing files are moved to <file>.bak.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
CURSOR_USER="$HOME/Library/Application Support/Cursor/User"

link() {
  local src="$REPO/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak"
    echo "backed up $dest -> $dest.bak"
  fi
  ln -sfn "$src" "$dest"
  echo "linked $dest"
}

link shell/.zshrc            "$HOME/.zshrc"
link shell/.bashrc           "$HOME/.bashrc"
link shell/.bash_aliases     "$HOME/.bash_aliases"
link tmux/.tmux.conf         "$HOME/.tmux.conf"
link git/.gitconfig          "$HOME/.gitconfig"
link git/ignore              "$HOME/.config/git/ignore"
link mise/config.toml        "$HOME/.config/mise/config.toml"
link alacritty/alacritty.yml "$HOME/.config/alacritty/alacritty.yml"
link nvim                    "$HOME/.config/nvim"
link wezterm                 "$HOME/.config/wezterm"
link ghostty                 "$HOME/.config/ghostty"
link claude/settings.json    "$HOME/.claude/settings.json"
link claude/statusline-command.sh "$HOME/.claude/statusline-command.sh"
link cursor/settings.json    "$CURSOR_USER/settings.json"
link cursor/keybindings.json "$CURSOR_USER/keybindings.json"

if [ ! -f "$HOME/.zshrc.local" ]; then
  cp "$REPO/shell/.zshrc.local.example" "$HOME/.zshrc.local"
  echo "created ~/.zshrc.local from example — fill in secrets"
fi
