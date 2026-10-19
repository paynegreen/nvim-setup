alias ls='ls -lat'
alias gc='git commit -m '
alias gcn='git commit --amend --no-edit'
alias gs='git status'
alias gst='git stash --include-untracked'
alias gsta='git stash apply'
alias gadd='git add -p'
alias gp='git push -u'
alias gpl='git pull --ff'
alias pa='php artisan'
alias pas='php artisan serve'
alias ph='php -S localhost:9090'
alias rm='rm -rf'
alias gco='git checkout'
alias wa='~/workarea'
alias dpa='docker ps -a'
alias v='vim'
alias gcl='git clone'
alias emu='~/Library/Android/sdk/emulator/emulator'
alias p='phpunit'
alias pf='phpunit --filter'
alias cat='bat'
alias dp='docker ps'
alias pd='popd'
alias reload='source ~/.zshrc'
alias tp='terraform apply'
alias ti='terraform init'
alias kb='kubectl'
alias nv='nvim'
alias vim='nvim'
alias mkd='make dockerless=true'
# alias brew='arch -arm64 /opt/homebrew/bin/brew'
alias wooga='~/workarea/wooga'
alias iex='iex --erl "-kernel shell_history enabled"'
alias scharts='wooga && cd sbs-charts'
alias sprojtools='wooga && cd sbs-project-tools'
# Rosetta 2
alias a="arch -x86_64"

# x86 Homebrew
alias ibrew="arch -x86_64 brew"
# alias ibrew="a /usr/local/Homebrew/bin/brew"
alias makd="make dockerless=true"
alias wtconfig="vim ~/.config/wezterm/wezterm.lua"
alias ms="iex -S mix phx.server"
alias mrd="mix ecto.reset; mix run apps/core/priv/repo/seeds.exs"
alias mt="MIX_ENV=test mix test --warnings-as-errors=false $1"
alias mtw="mix test --only wip"
alias mf="mix format"
alias mdg="mix deps.get"
alias g="git"
alias grs="git reset --soft"
alias grh="git reset --hard"
alias gb="git branch"
alias git-purge='sh ~/bin/git-purge.sh'
alias git-recent='sh ~/bin/git-recent.sh'
