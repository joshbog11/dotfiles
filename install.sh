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

    info "Installing LSP servers + tools via Homebrew..."
    brew install typescript-language-server
    brew install vscode-langservers-extracted
    brew install lua-language-server
    brew install pyright
    brew install biome
    brew install stylua
    brew install lazygit

  elif command_exists apt-get; then
    info "Installing packages via apt..."
    sudo apt-get update -qq
    sudo apt-get install -y tmux neovim git ripgrep fd-find fzf make nodejs python3 python3-pip curl
  elif command_exists dnf; then
    sudo dnf install -y tmux neovim git ripgrep fd-find fzf make nodejs python3 python3-pip curl
  elif command_exists pacman; then
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
  symlink "$DOTFILES_DIR/.tmux.conf"   "$HOME/.tmux.conf"
  symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
}

# ── Sora theme extras ─────────────────────────────────────────
install_sora() {
  info "Installing Sora theme extras..."
  local sora_dir="$DOTFILES_DIR/extras/sora"

  # tmux — symlink so the source-file in .tmux.conf finds it
  symlink "$sora_dir/sora.tmux.conf" "$HOME/sora.tmux.conf"

  # lazygit — merge sora theme into lazygit config
  if command_exists lazygit || [[ "$OS" == "Darwin" ]]; then
    local lg_config_dir="$HOME/Library/Application Support/lazygit"
    [[ "$OS" != "Darwin" ]] && lg_config_dir="$HOME/.config/lazygit"
    mkdir -p "$lg_config_dir"
    local lg_config="$lg_config_dir/config.yml"
    if [ ! -f "$lg_config" ]; then
      cp "$sora_dir/sora-lazygit.yml" "$lg_config"
      info "Lazygit sora theme installed"
    else
      warn "Lazygit config already exists — manually merge extras/sora/sora-lazygit.yml if needed"
    fi
  fi

  # iTerm2 — open the .itermcolors file so iTerm imports it automatically
  if [[ "$OS" == "Darwin" ]] && command_exists open; then
    info "Importing Sora iTerm2 color scheme..."
    open "$sora_dir/sora.itermcolors"
    info "iTerm2 will open and import Sora — click OK, then set it in:"
    info "  iTerm2 → Preferences → Profiles → Colors → Color Presets → Sora"
  fi
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
  echo "  1. Start tmux: tmux"
  echo "  2. Open nvim:  nvim  (Lazy auto-installs plugins on first launch)"
  echo "  3. In nvim:    <leader>th to pick your theme"
  echo ""
  echo "Sora theme installed for: tmux, nvim, iTerm2, lazygit"
  echo "iTerm2: Preferences → Profiles → Colors → Color Presets → Sora"
  echo ""
  echo "Font: Make sure your terminal is set to 'MesloLGS Nerd Font'"
}

# ── Main ──────────────────────────────────────────────────────
main() {
  info "Starting dotfiles install (OS: $OS)"
  install_packages
  install_tpm
  link_dotfiles
  install_sora
  install_tmux_plugins
  print_summary
}

main "$@"
