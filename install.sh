#!/usr/bin/env bash
# Interactive new-machine setup. Every step asks before doing anything; re-running is safe.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
CURSOR_USER="$HOME/Library/Application Support/Cursor/User"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

LINKS=(
  "shell/.zshrc|$HOME/.zshrc"
  "shell/.bashrc|$HOME/.bashrc"
  "shell/.bash_aliases|$HOME/.bash_aliases"
  "tmux/.tmux.conf|$HOME/.tmux.conf"
  "git/.gitconfig|$HOME/.gitconfig"
  "git/ignore|$HOME/.config/git/ignore"
  "mise/config.toml|$HOME/.config/mise/config.toml"
  "nvim|$HOME/.config/nvim"
  "wezterm|$HOME/.config/wezterm"
  "ghostty|$HOME/.config/ghostty"
  "claude/settings.json|$HOME/.claude/settings.json"
  "claude/statusline-command.sh|$HOME/.claude/statusline-command.sh"
  "cursor/settings.json|$CURSOR_USER/settings.json"
  "cursor/keybindings.json|$CURSOR_USER/keybindings.json"
)

ZSH_PLUGINS=(
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-completions
  trystan2k/zsh-tab-title
  agkozak/zsh-z
)

step() { printf '\n\033[1m==> %s\033[0m\n' "$1"; }

ask() { # ask <question> [y|n]  -> succeeds on yes
  local default=${2:-y} hint reply
  if [ "$default" = y ]; then hint="[Y/n]"; else hint="[y/N]"; fi
  read -r -p "$1 $hint " reply
  [[ ${reply:-$default} =~ ^[Yy] ]]
}

# Writes the Brewfile entries of the given kinds (e.g. "tap|brew|cask") that the user picks to <out>.
pick_entries() {
  local kinds=$1 out=$2 mode entry desc
  : >"$out"
  read -r -p "  [a]ll, [c]hoose each, or [s]kip? " mode
  case $mode in
  a* | A*) grep -E "^($kinds) " "$REPO/Brewfile" >"$out" || true ;;
  c* | C*)
    while IFS=$'\t' read -r -u 3 entry desc; do
      if ask "  $entry${desc:+  — $desc}"; then echo "$entry" >>"$out"; fi
    done 3< <(awk -v p="^($kinds) " '/^#/ { d = substr($0, 3); next } $0 ~ p { print $0 "\t" d } { d = "" }' "$REPO/Brewfile")
    ;;
  esac
}

bundle() {
  if [ -s "$1" ]; then
    brew bundle --file="$1" || echo "  Some entries failed — see output above; continuing."
  fi
}

step "Homebrew"
if command -v brew >/dev/null; then
  echo "  already installed"
elif ask "  Install Homebrew?"; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [ -x "$b" ]; then
    eval "$("$b" shellenv)"
    break
  fi
done

if command -v brew >/dev/null; then
  step "Homebrew packages ($(grep -cE '^(tap|brew|cask) ' "$REPO/Brewfile") taps, formulae and casks)"
  pick_entries "tap|brew|cask" "$TMP/packages.Brewfile"
  bundle "$TMP/packages.Brewfile"
fi

step "oh-my-zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "  already installed"
elif ask "  Install oh-my-zsh?"; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

step "zsh plugins"
plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
for repo in "${ZSH_PLUGINS[@]}"; do
  name=${repo#*/}
  if [ -d "$plugin_dir/$name" ]; then
    echo "  $name already installed"
  elif ask "  Install $name?"; then
    git clone -q "https://github.com/$repo" "$plugin_dir/$name"
  fi
done

step "tmux plugin manager"
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "  already installed"
elif ask "  Install tpm?"; then
  git clone -q https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

step "Config symlinks (existing files are moved to <name>.bak.<timestamp>)"
link_all=no
for pair in "${LINKS[@]}"; do
  src="$REPO/${pair%%|*}" dest="${pair#*|}"
  if [ "$(readlink "$dest" || true)" = "$src" ]; then
    echo "  ✓ $dest"
    continue
  fi
  if [ $link_all = no ]; then
    read -r -p "  Link $dest? [Y/n/a(ll)] " reply
    case $reply in
    n* | N*) continue ;;
    a* | A*) link_all=yes ;;
    esac
  fi
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dest" "$backup"
    echo "  backed up to $backup"
  fi
  ln -sfn "$src" "$dest"
  echo "  linked $dest"
done

step "Secrets"
if [ -f "$HOME/.zshrc.local" ]; then
  echo "  ~/.zshrc.local exists"
elif ask "  Create ~/.zshrc.local from the template?"; then
  cp "$REPO/shell/.zshrc.local.example" "$HOME/.zshrc.local"
  echo "  Fill in the values in ~/.zshrc.local"
fi

step "Runtimes (mise)"
if command -v mise >/dev/null && ask "  Install runtimes from ~/.config/mise/config.toml?"; then
  mise install
fi
export PATH="$HOME/.local/share/mise/shims:$PATH"

step "Go and npm global tools"
if ! command -v go >/dev/null && command -v brew >/dev/null && ask "  go not found. Install it with Homebrew?"; then
  brew install go
fi
pick_entries "go|npm" "$TMP/globals.Brewfile"
bundle "$TMP/globals.Brewfile"

step "Agent skills"
if command -v npx >/dev/null && command -v jq >/dev/null; then
  lock="$REPO/agents/.skill-lock.json"
  for source in $(jq -r '[.skills[].source] | unique[]' "$lock"); do
    echo "  $source: $(jq -r --arg s "$source" '[.skills | to_entries[] | select(.value.source == $s) | .key] | join(", ")' "$lock")"
    if ask "  Install skills from $source?"; then
      npx -y skills add "$source" -g
    fi
  done
else
  echo "  Skipped — needs npx and jq"
fi

step "Done. Restart your terminal to load the new shell config."
