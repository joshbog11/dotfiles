#!/usr/bin/env bash
# Bootstrap this machine from the dotfiles repo. Safe to run again at any time.
#
#   ./install.sh              install tools, link configs, set up theme + Neovim
#   ./install.sh --link-only  only link configs (no package installs)
#   ./install.sh --help
#
# Nothing in your home directory is deleted: a real file that is in the way is
# moved to <name>.bak.<timestamp> before the link is created.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
OS="$(uname -s)"
LINK_ONLY=0

# Language servers and formatters. Each one is optional: Neovim enables a
# server only when it is installed, so a formula that is missing or blocked on
# this machine is skipped with a warning instead of stopping the install.
# All of these come from Homebrew, never npm, so a corporate npm registry
# (Nexus, Artifactory) is not involved.
DEV_TOOLS=(
  tree-sitter-cli               # builds syntax parsers for Neovim
  vtsls                         # TypeScript / JavaScript (preferred)
  typescript-language-server    # TypeScript / JavaScript (fallback)
  vscode-langservers-extracted  # HTML, CSS, JSON, ESLint
  tailwindcss-language-server
  biome
  prettierd
  lua-language-server
  stylua
  basedpyright
  ruff
  yaml-language-server
  helm-ls
  bash-language-server
  shellcheck
  shfmt
  marksman                      # Markdown
  taplo                         # TOML
)

# ── Output helpers ───────────────────────────────────────────
if [[ -t 1 ]]; then
  GREEN=$'\033[0;32m' YELLOW=$'\033[1;33m' RED=$'\033[0;31m' BOLD=$'\033[1m' NC=$'\033[0m'
else
  GREEN="" YELLOW="" RED="" BOLD="" NC=""
fi
step() { printf '\n%s==> %s%s\n' "$BOLD" "$*" "$NC"; }
info() { printf '%s[ok]%s   %s\n' "$GREEN" "$NC" "$*"; }
warn() { printf '%s[warn]%s %s\n' "$YELLOW" "$NC" "$*"; }
fail() { printf '%s[fail]%s %s\n' "$RED" "$NC" "$*" >&2; exit 1; }
has() { command -v "$1" >/dev/null 2>&1; }

usage() {
  sed -n '2,9p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

# Link $2 -> $1, backing up anything real that is already there.
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -L "$dst" ]]; then
    if [[ "$(readlink "$dst")" == "$src" ]]; then
      info "already linked: ${dst/#$HOME/\~}"
      return
    fi
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    local backup
    backup="$dst.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    warn "moved existing ${dst/#$HOME/\~} to ${backup/#$HOME/\~}"
  fi
  ln -s "$src" "$dst"
  info "linked ${dst/#$HOME/\~}"
}

# ── Packages ─────────────────────────────────────────────────
load_brew() {
  has brew && return 0
  local candidate
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [[ -x "$candidate" ]]; then
      eval "$("$candidate" shellenv)"
      return 0
    fi
  done
  return 1
}

install_packages() {
  step "Installing tools with Homebrew"

  if ! load_brew; then
    if [[ "$OS" == "Darwin" ]]; then
      info "Homebrew not found, installing it"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      load_brew || fail "Homebrew was installed but is not on PATH. Open a new terminal and run this again."
    else
      warn "Homebrew not found. On Linux, install it from https://brew.sh (recommended: it provides Neovim 0.12+),"
      warn "or install these yourself: neovim (0.12+), tmux, git, ripgrep, fd, fzf, lazygit, tree-sitter-cli."
      warn "Continuing with config links only."
      return 0
    fi
  fi

  brew bundle --file "$DOTFILES_DIR/Brewfile" || warn "some Brewfile entries failed (see above); continuing"

  step "Installing language servers and formatters"
  local tool missing=()
  for tool in "${DEV_TOOLS[@]}"; do
    if brew list --formula "$tool" >/dev/null 2>&1; then
      info "$tool"
    elif brew install --quiet "$tool" >/dev/null 2>&1; then
      info "$tool (installed)"
    else
      missing+=("$tool")
    fi
  done
  if ((${#missing[@]} > 0)); then
    warn "not installed: ${missing[*]}"
    warn "Neovim still works; those languages just get less help. Retry with: brew install <name>"
  fi
}

# ── Config links ─────────────────────────────────────────────
link_configs() {
  step "Linking configuration"

  link "$DOTFILES_DIR/.config/nvim" "$CONFIG_HOME/nvim"
  link "$DOTFILES_DIR/.config/rex" "$CONFIG_HOME/rex"
  link "$DOTFILES_DIR/.config/starship.toml" "$CONFIG_HOME/starship.toml"
  link "$DOTFILES_DIR/.config/tinted-theming/tinty" "$CONFIG_HOME/tinted-theming/tinty"

  # Single files, because Tinty writes generated theme files next to them.
  link "$DOTFILES_DIR/.config/tmux/tmux.conf" "$CONFIG_HOME/tmux/tmux.conf"
  link "$DOTFILES_DIR/.config/ghostty/config" "$CONFIG_HOME/ghostty/config"

  # Earlier versions of this repo linked ~/.tmux.conf, which tmux would read
  # instead of ~/.config/tmux/tmux.conf.
  if [[ -L "$HOME/.tmux.conf" && "$(readlink "$HOME/.tmux.conf")" == "$DOTFILES_DIR/"* ]]; then
    rm "$HOME/.tmux.conf"
    info "removed old ~/.tmux.conf link"
  elif [[ -e "$HOME/.tmux.conf" ]]; then
    warn "$HOME/.tmux.conf exists and takes priority over $CONFIG_HOME/tmux/tmux.conf. Remove it to use this config."
  fi
}

# ~/.zshrc stays yours. It only gains one line that sources the shared module.
configure_zsh() {
  step "Configuring zsh"

  local zshrc="$HOME/.zshrc"
  local shared="$CONFIG_HOME/zsh/dotfiles.zsh"
  # shellcheck disable=SC2016  # written literally; expanded by zsh at startup
  local source_line='[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/dotfiles.zsh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/dotfiles.zsh"'

  link "$DOTFILES_DIR/.config/zsh/dotfiles.zsh" "$shared"

  # Very early versions linked the whole ~/.zshrc into the repo. Undo that.
  if [[ -L "$zshrc" && "$(readlink "$zshrc")" == "$DOTFILES_DIR/"* ]]; then
    rm "$zshrc"
    info "removed old ~/.zshrc link (your ~/.zshrc is now a normal local file)"
  fi

  [[ -e "$zshrc" ]] || : >"$zshrc"
  if grep -Fq 'zsh/dotfiles.zsh' "$zshrc"; then
    info "~/.zshrc already sources the shared module"
  else
    printf '\n# Shared shell setup from ~/dotfiles (machine-specific settings stay in this file).\n%s\n' "$source_line" >>"$zshrc"
    info "added one source line to ~/.zshrc"
  fi
}

configure_git() {
  step "Configuring git"
  if ! has git; then
    warn "git not found, skipping"
    return 0
  fi
  local include="$DOTFILES_DIR/.config/git/delta.inc"
  if ! has delta; then
    warn "delta not installed, leaving git output unchanged"
  elif git config --global --get-all include.path 2>/dev/null | grep -Fqx "$include"; then
    info "delta already enabled for git output"
  else
    git config --global --add include.path "$include"
    info "enabled delta for git diff / show / log -p (no aliases added, identity untouched)"
  fi
}

# ── Theme ────────────────────────────────────────────────────
setup_theme() {
  step "Setting up the theme (Tinty)"
  if ! has tinty; then
    warn "tinty not installed, skipping. Neovim falls back to gruvbox-dark-medium."
    return 0
  fi
  if ! tinty sync >/dev/null 2>&1; then
    warn "tinty sync failed (network?). Run it later, then: theme"
    return 0
  fi
  # Re-apply the scheme you already use; only a new machine gets the default.
  local scheme
  scheme="$(tinty current 2>/dev/null || true)"
  scheme="${scheme:-base16-gruvbox-dark-medium}"
  if tinty apply "$scheme" >/dev/null 2>&1; then
    info "theme applied: $scheme"
  else
    warn "could not apply $scheme. Try: theme"
  fi
}

# ── Neovim ───────────────────────────────────────────────────
setup_neovim() {
  step "Setting up Neovim"
  if ! has nvim; then
    warn "nvim not installed, skipping. Plugins install on first launch."
    return 0
  fi
  if ! nvim -u NONE --headless -c 'if !has("nvim-0.12") | cquit | endif' -c 'qall' >/dev/null 2>&1; then
    warn "Neovim 0.12 or newer is required (found: $(nvim --version | head -n 1)). Upgrade with: brew upgrade neovim"
    return 0
  fi
  if nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1; then
    info "plugins installed"
  else
    warn "plugin install did not finish (network?). Open nvim and run :Lazy sync"
  fi
  info "syntax parsers build in the background the first time you open nvim"
}

# ── Rex ──────────────────────────────────────────────────────
setup_rex() {
  step "Checking Rex"
  local rex=""
  if [[ -n "${REX_BIN_DIR:-}" && -x "$REX_BIN_DIR/rex" ]]; then
    rex="$REX_BIN_DIR/rex"
  elif has rex; then
    rex="rex"
  fi
  if [[ -z "$rex" ]]; then
    info "Rex CLI not found here. The config is linked and loads when Rex starts."
    return 0
  fi
  if "$rex" config check >/dev/null 2>&1; then
    if "$rex" config reload >/dev/null 2>&1; then
      info "Rex config valid and reloaded"
    else
      info "Rex config valid. Reload it with: rex config reload"
    fi
  else
    warn "rex config check reported problems. Run it to see them: rex config check"
  fi
}

summary() {
  cat <<EOF

${GREEN}Done.${NC}

Next:
  1. Open a new terminal tab (or: exec zsh)
  2. nvim           first launch builds syntax parsers; watch :Lazy and :checkhealth
  3. theme          pick colours for terminal + tmux + Neovim
  4. Read CHEATSHEET.md, or press Space in Neovim and wait

Rex:  config lives in ~/.config/rex. Apply edits with: rex config reload
tmux: prefix is Ctrl-Space. Apply edits with: prefix then r
EOF
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --link-only) LINK_ONLY=1 ;;
      -h | --help) usage; exit 0 ;;
      *) usage; fail "unknown option: $1" ;;
    esac
    shift
  done

  printf '%sdotfiles%s  %s  (%s)\n' "$BOLD" "$NC" "$DOTFILES_DIR" "$OS"

  if ((LINK_ONLY == 0)); then
    install_packages
  fi
  load_brew || true
  link_configs
  configure_zsh
  configure_git
  if ((LINK_ONLY == 0)); then
    setup_theme
    setup_neovim
  fi
  setup_rex
  summary
}

main "$@"
