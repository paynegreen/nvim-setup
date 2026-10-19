export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH=$HOME/.oh-my-zsh
source ~/.bash_aliases
ZSH_THEME="agnoster"

ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

plugins=(git brew docker yarn zsh-vi-mode z)
plugins=(mise zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-tab-title zsh-z)
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

GIT_EDITOR=nvim

alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export ANDROID_HOME=/Users/tsatsu/Library/Android/sdk
export LIBRARY_PATH=:/usr/local/opt/openssl/lib/
export LDFLAGS=-L/usr/local/opt/ruby/lib
export PATH="/usr/local/opt/libiconv/bin:$PATH"

export LDFLAGS="-L/usr/local/opt/openldap/lib"
export CPPFLAGS="-I/usr/local/opt/openldap/include"
export PATH="/usr/local/opt/openldap/bin:$PATH"
export PATH="/usr/local/opt/openldap/sbin:$PATH"
export PATH="/usr/local/sbin:$PATH"

eval "$(direnv hook zsh)"
export GOPATH="/Users/tsatsu/go"
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOPATH/bin
export CFLAGS="-O2 -g -fno-stack-check"
export KERL_CONFIGURE_OPTIONS="--disable-hipe --with-ssl=$(brew --prefix openssl) --with-wx-config=$(brew --prefix wxwidgets)/bin/wx-config --with-odbc=$(brew --prefix unixodbc)" 
export CPPFLAGS="-I$(brew --prefix unixodbc)/include"
export LDFLAGS="-L$(brew --prefix unixodbc)/lib"
export PORT="4000"

export ZSH_TAB_TITLE_ADDITIONAL_TERMS='wezterm'
export ZSH_TAB_TITLE_CONCAT_FOLDER_PROCESS=true
export ZSH_TAB_TITLE_ONLY_FOLDER=true

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
export PATH="$HOME/.local/bin:$PATH"


# Machine-local secrets and overrides (not tracked)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
