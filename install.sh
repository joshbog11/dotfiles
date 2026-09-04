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

configure_zsh() {
  local zshrc="$HOME/.zshrc"
  local shared="$HOME/.config/zsh/dotfiles.zsh"
  local source_line='[[ -r "$HOME/.config/zsh/dotfiles.zsh" ]] && source "$HOME/.config/zsh/dotfiles.zsh"'

  # Migrate the earlier installer, which briefly linked the whole ~/.zshrc.
  if [ -L "$zshrc" ] && [ "$(readlink "$zshrc")" = "$DOTFILES_DIR/.zshrc" ]; then
    rm "$zshrc"
    if [ -f "$zshrc.bak" ]; then
      mv "$zshrc.bak" "$zshrc"
    else
      : > "$zshrc"
    fi
    info "Restored machine-local $zshrc"
  fi

  [ -e "$zshrc" ] || : > "$zshrc"
  if ! grep -Fqx "$source_line" "$zshrc"; then
    printf '\n# Shared shell tools from ~/dotfiles (machine settings stay local).\n%s\n' "$source_line" >> "$zshrc"
    info "Enabled shared shell tools in $zshrc"
  fi

  symlink "$DOTFILES_DIR/.zshrc" "$shared"
}

# ── Package manager install ───────────────────────────────────
install_packages() {
  if [[ "$OS" == "Darwin" ]]; then
    if ! command_exists brew; then
      info "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    info "Installing core packages via Homebrew..."
    brew install tmux neovim git ripgrep fd fzf make node python3 \
      starship zoxide eza git-delta direnv lazygit \
      zsh-autosuggestions zsh-syntax-highlighting

    brew install tinted-theming/tinted/tinty
    
    info "Installing LSP servers + tools via Homebrew..."
    brew install typescript-language-server
    brew install vscode-langservers-extracted
    brew install lua-language-server
    brew install pyright
    brew install biome
    brew install stylua
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

	symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
	symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
	symlink "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

	mkdir -p "$HOME/.config/ghostty"
	symlink \
		"$DOTFILES_DIR/.config/ghostty/config" \
		"$HOME/.config/ghostty/config"

	mkdir -p "$HOME/.config/tinted-theming"
	symlink \
		"$DOTFILES_DIR/.config/tinted-theming/tinty" \
		"$HOME/.config/tinted-theming/tinty"

	configure_zsh

	if ! git config --global --get-all include.path 2>/dev/null | grep -Fqx "$DOTFILES_DIR/.config/git/delta.inc"; then
		git config --global --add include.path "$DOTFILES_DIR/.config/git/delta.inc"
		info "Enabled delta for Git output (no aliases added)"
	fi

}

setup_tinty() {
	if ! command_exists tinty; then
		warn "Tinty is not installed — skipping theme setup"
		return
	fi

	info "Syncing themes..."
	tinty sync

	info "Applying default theme..."
	tinty apply base16-gruvbox-dark-medium
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
	echo "  1. Restart Ghostty (or run: exec zsh)"
	echo "  2. Start tmux: tmux"
	echo "  3. Open Neovim: nvim"
	echo "  4. Pick a theme: theme"
	echo ""

	echo "Theme system:"
	echo "  Tinty → Ghostty + tmux + Neovim + Lualine"
	echo ""

	echo "Default theme:"
	echo "  base16-gruvbox-dark-medium"
	echo ""

	echo "Font: JetBrains Mono Nerd Font (install it separately if needed)"
}

# ── Main ──────────────────────────────────────────────────────
main() {
  info "Starting dotfiles install (OS: $OS)"
  install_packages
  install_tpm
  link_dotfiles
  setup_tinty
  install_tmux_plugins
  print_summary
}

main "$@"
