# dotfiles

A reproducible macOS terminal environment built around Ghostty, Zsh, tmux and Neovim. Tinty/Base16 is the single colour source for Ghostty, tmux and Neovim; shell tools use the terminal's ANSI palette so they follow automatically.

## Quick start (macOS)

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer is safe to rerun. It installs Homebrew if needed, installs dependencies, preserves the machine-local `~/.zshrc` and Git identity, installs tmux plugins, syncs Tinty, and applies the default theme.

The repository never owns or symlinks `~/.zshrc`. It links the shared shell module at `~/.config/zsh/dotfiles.zsh` and adds one guarded source line to the local file. Pulling a new version therefore cannot replace machine-specific settings. The installer also migrates the earlier setup that linked `~/.zshrc`, restoring `~/.zshrc.bak` when present.

Install **JetBrains Mono Nerd Font** separately, then restart Ghostty (or run `exec zsh`). Linux package-manager support is best-effort; macOS/Homebrew is the reproducible target.

## Included

| Area | Tools |
|---|---|
| Shell and prompt | Zsh, Starship, autosuggestions, syntax highlighting |
| Navigation | zoxide, eza, fd, fzf |
| Git | delta, lazygit, branch and project pickers |
| Environment | optional direnv hook |
| Terminal/editor | Ghostty, tmux, Neovim |
| Theme | Tinty with Base16 schemes |

## Theme architecture

```text
Tinty scheme
├── Ghostty palette ──> Starship, fzf, eza, delta (ANSI colours)
├── tmux palette      ──> ~/.config/tmux/tinted.conf
└── Neovim palette    ──> colors/tinted.vim ──> Lualine auto theme
```

Use `theme` for an fzf picker, `theme base16-gruvbox-dark-medium` to apply one directly, or `tinty current` to inspect the active scheme. The active tmux palette is persisted, so a new tmux server receives it too.

Tmux uses Tinty's full segmented status bar. The left segment shows the session, windows are visually separated with a bright active window, and the right side shows date, time, and host. Shell windows automatically use their current folder as the name; foreground applications use their command name.

## Shell workflow

- `cd keyword` uses zoxide's learned directory history; `cdi` opens its picker.
- `Alt-C` picks a directory and `Ctrl-T` inserts a selected file via fzf.
- `project` finds Git repositories under `~/Developer`, `~/Projects`, `~/Code`, `~/work`, and `~/dotfiles`.
- `gco` previews recent branches and switches to the selected branch.
- `lg` opens lazygit; `git lg` shows a compact graph.
- `ll` shows a detailed Git-aware directory listing.
- Entering a directory with an approved `.envrc` loads it through direnv. Run `direnv allow` once per trusted project.

## Layout

```text
.zshrc → ~/.config/zsh/dotfiles.zsh shared shell tools (local ~/.zshrc preserved)
.config/starship.toml               two-line Git-aware prompt
.config/git/dotfiles.inc            delta and shared Git defaults
.config/tinted-theming/tinty/       theme sources and hooks
.config/ghostty/config              terminal settings
.tmux.conf                           tmux and persisted Tinty palette
.config/nvim/                        Neovim
bin/theme                            theme picker/direct command
```

Personal Git name/email remain in `~/.gitconfig`; the installer adds the repo-managed Git file as an include. This keeps machine-specific identity out of the repository.

## First-run checks

```bash
exec zsh
theme
tmux
nvim
git config --show-origin --get core.pager
```

Inside tmux, use `Ctrl-Space I` if plugins were not installed by the bootstrap. Neovim's lazy.nvim installs its plugins on first launch. See [CHEATSHEET.md](CHEATSHEET.md) for everyday shortcuts.
