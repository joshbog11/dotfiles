# Shared shell setup, sourced from the machine-local ~/.zshrc by install.sh.
# Machine-specific things (work proxies, tokens, Oh My Zsh, extra aliases) stay
# in ~/.zshrc and are never touched by this repository.
# Every tool is optional: a missing one is skipped, never an error.

export DOTFILES="${DOTFILES:-$HOME/dotfiles}"

# ── PATH ─────────────────────────────────────────────────────
typeset -U path PATH
path=("$HOME/.local/bin" "$DOTFILES/bin" $path)

# Rex exports REX_BIN_DIR into every pane, but startup files often rebuild
# PATH. Put it back so the `rex` CLI works inside Rex.
[[ -n "${REX_BIN_DIR:-}" && -d "$REX_BIN_DIR" ]] && path+=("$REX_BIN_DIR")

export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-FRX"
export MANPAGER="nvim +Man!"

# ── History ──────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS INTERACTIVE_COMMENTS

# ── Completion ───────────────────────────────────────────────
if ! (( $+functions[compdef] )); then
  autoload -Uz compinit && compinit
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS:-}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{cyan}%d%f'

# Up / Down search history for what is already typed.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
for _key in '^[[A' '^[OA'; do bindkey "$_key" up-line-or-beginning-search; done
for _key in '^[[B' '^[OB'; do bindkey "$_key" down-line-or-beginning-search; done
unset _key

# ── Plugins (Homebrew on macOS or Linux) ─────────────────────
if command -v brew >/dev/null 2>&1; then
  _brew_prefix="${HOMEBREW_PREFIX:-$(brew --prefix)}"
  [[ -r "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
    source "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -r "$_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
    source "$_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  unset _brew_prefix
fi

# ── Tools ────────────────────────────────────────────────────
# ANSI colour names inherit the active Tinty palette from the terminal.
export FZF_DEFAULT_OPTS="--height=60% --layout=reverse --border=rounded --info=inline --color=16"
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# ── Aliases ──────────────────────────────────────────────────
# No git aliases on purpose: the ones from your local setup (Oh My Zsh's gco,
# gst, …) keep working unchanged.
alias python=python3
alias pip=pip3
alias nv=nvim
alias lg=lazygit
alias zrc='nvim ~/.zshrc'
alias src='source ~/.zshrc'
alias dots='cd "$DOTFILES" && nvim'

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza --long --all --git --group-directories-first --icons=auto'
  alias tree='eza --tree --icons=auto'
fi
