# dotfiles

One repository, one command, the same environment on every machine: Neovim, Rex or tmux, zsh, Ghostty, and one theme across all of them.

```bash
git clone https://github.com/joshbog11/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

The installer is safe to run again. It never deletes anything: a real file that is in the way is moved to `<name>.bak.<timestamp>`. Use `./install.sh --link-only` to link configs without installing packages.

**After pulling this rewrite on a machine that had the old version, run `./install.sh` once.** Two links moved (`~/.config/zsh/dotfiles.zsh`, and `~/.tmux.conf` became `~/.config/tmux/tmux.conf`).

## What you get

| Area | Choice | Why |
|---|---|---|
| Editor | Neovim 0.12+, lazy.nvim | Native LSP API, fast startup, pinned plugin versions |
| Finder, explorer, dashboard | snacks.nvim | One maintained plugin instead of five |
| Completion | blink.cmp | Fast, works out of the box, no build step |
| Language servers | Homebrew-installed, enabled only if present | No npm, so corporate registries are not involved |
| Formatting | conform.nvim | Biome when a project has `biome.json`, otherwise Prettier |
| Git | gitsigns, diffview, LazyGit | Inline changes, review tab, full TUI |
| Multiplexer | Rex and tmux, same keys in both | `Ctrl-h/j/k/l` crosses editor splits and panes |
| Theme | Tinty (Base16) | One command re-themes terminal, tmux and every open Neovim |
| Shell | zsh, Starship, zoxide, fzf, eza, delta | Your own `~/.zshrc` is never replaced |

Every keybinding is in [CHEATSHEET.md](CHEATSHEET.md). In Neovim, press `Space` and wait: which-key lists everything.

## Layout

```text
install.sh                      bootstrap (idempotent)
Brewfile                        core tools
bin/theme                       theme picker
bin/sessionizer                 project picker for tmux
.config/nvim/                   Neovim
  init.lua
  lua/config/                   options, keymaps, autocmds, navigate (tmux/Rex), lazy
  lua/plugins/                  one file per concern
.config/rex/init.lua            Rex keys and actions
.config/tmux/tmux.conf          tmux (no plugins)
.config/zsh/dotfiles.zsh        shared shell module, sourced from your ~/.zshrc
.config/ghostty/config          terminal
.config/starship.toml           prompt
.config/git/delta.inc           git diff rendering
.config/tinted-theming/tinty/   theme sources and hooks
```

## Neovim

Requires **Neovim 0.12 or newer** (`brew upgrade neovim`). On first launch lazy.nvim installs the plugins and Tree-sitter builds the syntax parsers in the background, which takes a minute once per machine.

- **Language servers** are listed in `lua/plugins/lsp.lua`. A server starts only when its executable is installed, so nothing errors on a machine that lacks one. `./install.sh` installs them with Homebrew; `:Mason` is available as an alternative on machines without Homebrew. Check status with `:checkhealth vim.lsp`.
- **TypeScript** uses `vtsls` (the VS Code engine) and falls back to `typescript-language-server`. It uses each project's own TypeScript version.
- **Add a plugin** by creating a file in `lua/plugins/` that returns a lazy.nvim spec. **Update plugins** with `:Lazy sync`, then commit `lazy-lock.json` so other machines get the same versions.
- **Health check:** `:checkhealth` (and `:checkhealth nvim-treesitter` if a file has no colours).

## Rex

[Rex](https://www.superlogical.com/rex) is a terminal and multiplexer in one. `.config/rex/init.lua` gives it the same keys as the tmux config, and wires up the Neovim handshake:

- `Ctrl-h/j/k/l` moves between Rex panes. When the focused pane runs Neovim (Rex checks that the title starts with `nvim`), the key goes to Neovim, which moves between its own splits and calls `rex focus <direction>` at the edge.
- `Ctrl-Space` is the prefix, as in tmux: `|` and `-` split, `c` new tab, `1`-`9` go to tab, `z` zoom, `s` sessions, `r` reload config.
- `prefix d` opens a dev layout (Neovim plus a shell), `prefix g` opens LazyGit in a tab. Both are also in the command palette.
- Rex's built-in `Cmd` shortcuts are untouched.

Apply changes with `rex config reload`; validate with `rex config check`. Rex stores fonts and colours in its own Settings rather than this file: to match the Tinty theme use the palette command *Import Theme File* with `~/.config/ghostty/themes/tinted-theming`.

The Rex config is written from the public Rex Beta 0.1.x documentation. Rex is in beta, so if an action name changes, `rex keymap` shows which binding to fix.

## tmux

No plugin manager and no plugins. Prefix is `Ctrl-Space`. `prefix f` picks a project and jumps to its session, `prefix g` opens LazyGit in a popup. Copying in copy mode reaches the system clipboard, including over SSH.

## Theme

```text
Tinty scheme
├── Ghostty palette  ──> Starship, fzf, eza, delta, LazyGit (terminal colours)
├── tmux palette     ──> ~/.config/tmux/tinted.conf
└── Neovim           ──> tinted-nvim watches the scheme and reloads live
```

`theme` opens a picker, `theme base16-gruvbox-dark-medium` applies one directly, and `<leader>ut` does the same from inside Neovim. For a see-through editor, set `background-opacity` in the Ghostty config and press `<leader>ub` in Neovim.

## Shell

The repository never owns `~/.zshrc`. The installer adds one line to it that sources `~/.config/zsh/dotfiles.zsh`; machine-specific settings (work proxies, tokens, Oh My Zsh) stay in your local file. No git aliases are defined, so the ones you already have keep working.

- `cd <keyword>` jumps by frecency (zoxide); `cdi` opens its picker.
- `Ctrl-T` inserts a file, `Alt-C` changes directory, `Ctrl-R` searches history (fzf).
- `ll`, `tree` (eza), `lg` (LazyGit), `nv` (Neovim), `dots` (edit this repo).

## Troubleshooting

| Symptom | Fix |
|---|---|
| "This config needs Neovim 0.12" | `brew upgrade neovim` |
| A file has no syntax colours | `:checkhealth nvim-treesitter`; the `tree-sitter` CLI must be installed (`brew install tree-sitter-cli`) |
| No completions or errors in a language | `:checkhealth vim.lsp`; install the server (`brew install <name>` or `:Mason`) |
| Icons show as boxes | Use a Nerd Font (the installer adds JetBrains Mono Nerd Font) or Ghostty, which has the symbols built in |
| `Alt-j` / `Alt-k` types odd characters | Ghostty: `macos-option-as-alt = left` (already set). Other terminals: enable "Option as Meta" |
| `Ctrl-h/j/k/l` does not leave Neovim in Rex | `rex config check`, then `rex config reload`; confirm `echo $REX_BLOCK` prints an ID |
| Old shell aliases disappeared after pulling | Run `./install.sh --link-only` |

## Rolling back

The state before the November 2026 rewrite is tagged: `git checkout pre-rewrite-2026-11-12`.
