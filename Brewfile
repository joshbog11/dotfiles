# Core tools. Installed by ./install.sh (or: brew bundle --file ~/dotfiles/Brewfile).
# Works with Homebrew on macOS and on Linux; casks are macOS only.
# Language servers and formatters are installed separately by install.sh so one
# unavailable formula cannot block the rest.

tap "tinted-theming/tinted"

# Editor and terminal multiplexer
brew "neovim"                 # 0.12 or newer
brew "tmux"

# Search, navigation, git
brew "git"
brew "ripgrep"
brew "fd"
brew "fzf"
brew "zoxide"
brew "eza"
brew "jq"
brew "lazygit"
brew "git-delta"
brew "direnv"

# Shell
brew "starship"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# Theme manager
brew "tinted-theming/tinted/tinty"

# Runtimes that language tooling expects
brew "node"
brew "python"

if OS.mac?
  cask "font-jetbrains-mono-nerd-font"
end
