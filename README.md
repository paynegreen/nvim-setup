# nvim-setup

Dotfiles and app configs for setting up a new MacBook.

| Path | Installs to |
| --- | --- |
| `shell/.zshrc`, `.bashrc`, `.bash_aliases` | `~/` |
| `tmux/.tmux.conf` | `~/.tmux.conf` |
| `git/.gitconfig`, `git/ignore` | `~/.gitconfig`, `~/.config/git/ignore` |
| `nvim/`, `wezterm/`, `ghostty/`, `mise/` | `~/.config/<name>` |
| `claude/` | `~/.claude/` (settings + statusline) |
| `cursor/` | `~/Library/Application Support/Cursor/User/` |
| `agents/.skill-lock.json` | manifest of installed agent skills |
| `cmux/cmux.json` | cmux config |
| `Brewfile` | Homebrew formulae, casks, go and npm globals |

## New machine

```sh
git clone https://github.com/paynegreen/nvim-setup ~/workarea/nvim-setup
cd ~/workarea/nvim-setup && ./install.sh
```

`install.sh` is interactive and safe to re-run. It walks through, asking before each step:

1. Homebrew (installs it if missing)
2. Brewfile taps, formulae and casks — install `[a]ll`, `[c]hoose each`, or `[s]kip`
3. oh-my-zsh and the custom zsh plugins `.zshrc` expects
4. tmux plugin manager
5. Config symlinks, per file or `a(ll)`; existing files are moved to `<name>.bak.<timestamp>`
6. `~/.zshrc.local` from the template — fill in your secrets afterwards
7. `mise install` runtimes
8. Go and npm global tools from the Brewfile (offers to install Go if missing)
9. Agent skills from `agents/.skill-lock.json`, one source at a time

The Brewfile lists only top-level formulae; dependencies are pulled in automatically.

### Claude Code

Plugins (`enabledPlugins`, `extraKnownMarketplaces`) are restored from
`claude/settings.json` on first launch. Skills are restored by step 9 of
`install.sh` (`npx skills add <source> -g`).

## Notes

- `.zshrc` and the Brewfile were captured on an Intel Mac (`/usr/local`). On
  Apple Silicon Homebrew lives in `/opt/homebrew`, so the `/usr/local/opt/*`
  paths in `.zshrc` need updating.
- Never commit secrets — this repo is public. Put them in `~/.zshrc.local`.
