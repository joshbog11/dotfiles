# Small standalone shell configuration; dependencies come from install.sh.
export PATH="$HOME/.local/bin:$HOME/dotfiles/bin:$PATH"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-FRX"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS INTERACTIVE_COMMENTS

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS:-}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{cyan}%d%f'

if command -v brew >/dev/null 2>&1; then
  brew_prefix="$(brew --prefix)"
  [[ -r "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
    source "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -r "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
    source "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  unset brew_prefix
fi

# ANSI colour names inherit the active Tinty/Base16 terminal palette.
export FZF_DEFAULT_OPTS="--height=60% --layout=reverse --border=rounded --info=inline --color=16"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# Remove picker functions shipped by an earlier version. `unfunction` does not
# touch Oh My Zsh aliases such as gco='git checkout'.
unfunction gco project 2>/dev/null

alias python=python3
alias pip=pip3
alias nv=nvim
alias zrc='nvim ~/.zshrc'
alias src='source ~/.zshrc'
alias ls='eza --group-directories-first --icons=auto'
alias ll='eza --long --all --git --group-directories-first --icons=auto'
alias tree='eza --tree --icons=auto'
