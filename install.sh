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
    info "Installing packages via Homebrew..."
    brew install tmux neovim git ripgrep fd fzf make node python3
    brew install --cask font-meslo-lg-nerd-font  # Nerd Font for icons
  elif command_exists apt-get; then
    info "Installing packages via apt..."
    sudo apt-get update -qq
    sudo apt-get install -y tmux neovim git ripgrep fd-find fzf make nodejs python3 python3-pip curl
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

  # tmux
  symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

  # neovim
  symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
}

# ── Install tmux plugins ──────────────────────────────────────
install_tmux_plugins() {
  info "Installing tmux plugins via TPM..."
  # Headless TPM install
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
}

# ── Summary ───────────────────────────────────────────────────
print_summary() {
  echo ""
  echo -e "${GREEN}✓ Done!${NC}"
  echo ""
  echo "Next steps:"
  echo "  1. Start a new tmux session: tmux"
  echo "  2. Press  prefix + I  (C-Space + I) to install tmux plugins"
  echo "  3. Open neovim: nvim"
  echo "     Lazy.nvim will auto-install all plugins on first launch"
  echo "  4. In nvim, run :MasonInstall to install additional LSP servers"
  echo ""
  echo "Tip: Install a Nerd Font and set it in your terminal for icons."
  echo "     Recommended: MesloLGS NF or JetBrainsMono Nerd Font"
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
