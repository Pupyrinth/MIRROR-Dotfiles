# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

#eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"


# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light djui/alias-tips

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo

# Theme
ZSH_THEME="bira"
zinit snippet OMZL::git.zsh
zinit snippet OMZL::prompt_info_functions.zsh
zinit snippet OMZL::async_prompt.zsh
zinit cdclear -q
setopt promptsubst
zinit snippet OMZT::bira

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Keybindings
# bindkey '^f' autosuggest-accept
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lav --ignore=..'   # show long listing of all except ".."
alias l='ls -lav --ignore=.?*'   # show long listing but no hidden dotfiles except "."
alias la='ls -A'
alias ..='cd ..'
alias mv='mv -i'
alias rm='rm -i'
alias vim='nvim'

alias neo='neofetch'
alias hy='hyfetch'
alias npm='pnpm'
alias npx='pnpm dlx'
alias zed='zeditor'

#alias cd='cd ~/myHome'

alias chall='~/Scripts/challenges.sh'
alias backup='~/Scripts/backup.sh'

alias brew='echo "Remeber what happened last time. You do not want to do that."'

alias ustow='export CURRENT_PATH=$(pwd) && cd ~/myHome/Dotfiles && stow -t /home/luna . && cd $CURRENT_PATH'

# Paths
PATH="$HOME/.npm-packages/bin:$PATH"
PATH="$HOME/.bun/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="/usr/local/go/bin:$PATH"
PATH="$HOME/go/bin:$PATH"

# pnpm
export PNPM_HOME="/home/luna/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH=$PATH:/home/luna/.millennium/ext/bin
