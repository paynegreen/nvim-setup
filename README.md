# nvim-setup

Dotfiles and app configs for setting up a new MacBook.

| Path | Installs to |
| --- | --- |
| `shell/.zshrc`, `.bashrc`, `.bash_aliases` | `~/` |
| `tmux/.tmux.conf` | `~/.tmux.conf` |
| `git/.gitconfig`, `git/ignore` | `~/.gitconfig`, `~/.config/git/ignore` |
| `nvim/`, `wezterm/`, `ghostty/`, `mise/`, `alacritty/` | `~/.config/<name>` |
| `claude/` | `~/.claude/` (settings + statusline) |
| `cursor/` | `~/Library/Application Support/Cursor/User/` |
| `agents/.skill-lock.json` | manifest of installed agent skills |
| `cmux/cmux.json` | cmux config |
| `Brewfile` | Homebrew formulae, casks, go and npm globals |

## New machine

```sh
# 1. Homebrew + packages
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --file=Brewfile

# 2. oh-my-zsh, then the custom plugins listed in .zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ZC=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZC/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZC/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-completions "$ZC/zsh-completions"
git clone https://github.com/trystan2k/zsh-tab-title "$ZC/zsh-tab-title"
git clone https://github.com/agkozak/zsh-z "$ZC/zsh-z"

# 3. tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 4. Symlink configs (existing files are moved to *.bak)
./install.sh

# 5. Secrets live in ~/.zshrc.local (untracked) — fill it in
$EDITOR ~/.zshrc.local

# 6. Runtimes
mise install
```

### Claude Code

Plugins (`enabledPlugins`, `extraKnownMarketplaces`) are restored from
`claude/settings.json` on first launch. Skills in `agents/.skill-lock.json` come
from `mattpocock/skills`, `vercel-labs/skills` and `anthropics/claude-code`;
reinstall with `npx skills add <source>`.

## Notes

- `.zshrc` and the Brewfile were captured on an Intel Mac (`/usr/local`). On
  Apple Silicon Homebrew lives in `/opt/homebrew`, so the `/usr/local/opt/*`
  paths in `.zshrc` need updating.
- Never commit secrets — this repo is public. Put them in `~/.zshrc.local`.
