#!/usr/bin/env bash
# install.sh — bootstrap dotfiles on a fresh machine
# Usage: ./install.sh
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

# ── Colours ──────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()    { echo -e "${GREEN}[info]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[warn]${NC}  $*"; }
err()     { echo -e "${RED}[error]${NC} $*" >&2; }

# ── Helpers ───────────────────────────────────────────────────
command_exists() { command -v "$1" &>/dev/null; }

symlink() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    warn "Backing up existing $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sfn "$src" "$dst"
  info "Linked $dst → $src"
}

# ── Package manager install ───────────────────────────────────
install_packages() {
  if [[ "$OS" == "Darwin" ]]; then
    if ! command_exists brew; then
      info "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    info "Installing core packages via Homebrew..."
    brew install tmux neovim git ripgrep fd fzf make node python3
    brew install --cask font-meslo-lg-nerd-font

    # ── LSP servers via Homebrew (bypasses npm/Nexus entirely) ──
    # These are installed as binaries — no npm registry involved
    info "Installing LSP servers + tools via Homebrew..."
    brew install typescript-language-server    # ts_ls
    brew install vscode-langservers-extracted  # html, cssls, jsonls
    brew install lua-language-server           # lua_ls
    brew install pyright                       # pyright
    brew install biome                         # linter + formatter
    brew install stylua                        # lua formatter

  elif command_exists apt-get; then
    info "Installing packages via apt..."
    sudo apt-get update -qq
    sudo apt-get install -y tmux neovim git ripgrep fd-find fzf make nodejs python3 python3-pip curl
    # On Linux, Mason handles LSP installs fine (no Nexus issue)
  elif command_exists dnf; then
    info "Installing packages via dnf..."
    sudo dnf install -y tmux neovim git ripgrep fd-find fzf make nodejs python3 python3-pip curl
  elif command_exists pacman; then
    info "Installing packages via pacman..."
    sudo pacman -Sy --noconfirm tmux neovim git ripgrep fd fzf make nodejs python python-pip curl
  else
    warn "No supported package manager found. Install tmux, neovim, git, ripgrep, fd, fzf manually."
  fi
}

# ── TPM (Tmux Plugin Manager) ─────────────────────────────────
install_tpm() {
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [ -d "$tpm_dir" ]; then
    info "TPM already installed, pulling latest..."
    git -C "$tpm_dir" pull --quiet
  else
    info "Installing TPM..."
    git clone --quiet https://github.com/tmux-plugins/tpm "$tpm_dir"
  fi
}

# ── Symlink dotfiles ──────────────────────────────────────────
link_dotfiles() {
  info "Symlinking dotfiles..."
  symlink "$DOTFILES_DIR/.tmux.conf"    "$HOME/.tmux.conf"
  symlink "$DOTFILES_DIR/.config/nvim"  "$HOME/.config/nvim"
}

# ── Install tmux plugins ──────────────────────────────────────
install_tmux_plugins() {
  info "Installing tmux plugins via TPM..."
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
}

# ── Summary ───────────────────────────────────────────────────
print_summary() {
  echo ""
  echo -e "${GREEN}✓ Done!${NC}"
  echo ""
  echo "Next steps:"
  echo "  1. Start tmux:  tmux"
  echo "     (plugins were installed headlessly — no C-Space+I needed)"
  echo "  2. Open neovim: nvim"
  echo "     Lazy.nvim will auto-install plugins on first launch."
  echo "     Mason will install biome (GitHub binary — no npm needed)."
  echo "  3. LSP servers (html, ts, lua, css, json) were installed via Homebrew."
  echo "     No Mason/npm required for those."
  echo ""
  echo "Tip: Set your terminal font to 'MesloLGS Nerd Font' for icons."
}

# ── Main ──────────────────────────────────────────────────────
main() {
  info "Starting dotfiles install (OS: $OS)"
  install_packages
  install_tpm
  link_dotfiles
  install_tmux_plugins
  print_summary
}

main "$@"
