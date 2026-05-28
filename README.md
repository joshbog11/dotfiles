# dotfiles

> tmux + neovim config. One command to reproduce the same environment on any machine.

Based on the [Dreams of Code tmux setup](https://www.youtube.com/watch?v=DzNmUNvnB04).

---

## Requirements

| Tool | Version |
|------|---------|
| tmux | ≥ 3.2 |
| neovim | ≥ 0.9 |
| git | any |
| A Nerd Font | e.g. MesloLGS NF |
| ripgrep + fd | for Telescope |
| node + python3 | for LSP servers |

---

## Quick start

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The script will:
1. Install packages (Homebrew on macOS, apt/dnf/pacman on Linux)
2. Install [TPM](https://github.com/tmux-plugins/tpm) (tmux plugin manager)
3. Symlink `.tmux.conf` → `~/.tmux.conf`
4. Symlink `.config/nvim` → `~/.config/nvim`
5. Install tmux plugins headlessly

Then:
- Open tmux and press **`C-Space I`** to install plugins (if headless install didn't run)
- Open `nvim` — [lazy.nvim](https://github.com/folke/lazy.nvim) will auto-install everything

---

## tmux

### Prefix
`Ctrl + Space` (replaces the default `Ctrl + b`)

### Pane navigation
| Key | Action |
|-----|--------|
| `prefix h/j/k/l` | Move between panes (vim style) |
| `Alt + ←/→/↑/↓` | Move between panes (no prefix) |
| `prefix "` | Split horizontal (keeps cwd) |
| `prefix %` | Split vertical (keeps cwd) |

### Window navigation
| Key | Action |
|-----|--------|
| `Shift + ←/→` | Prev/next window |
| `Alt + H/L` | Prev/next window (vim style) |

### Copy mode (vi)
| Key | Action |
|-----|--------|
| `prefix [` | Enter copy mode |
| `v` | Begin selection |
| `C-v` | Rectangle selection |
| `y` | Yank (copy to system clipboard via tmux-yank) |

### Plugins
| Plugin | Purpose |
|--------|---------|
| [tpm](https://github.com/tmux-plugins/tpm) | Plugin manager |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible defaults |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless nvim ↔ tmux pane nav |
| [catppuccin-tmux](https://github.com/dreamsofcode-io/catppuccin-tmux) | Mocha theme |
| [tmux-yank](https://github.com/tmux-plugins/tmux-yank) | System clipboard yank |

---

## neovim

**Leader key:** `Space`

### File navigation
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>e` | Toggle file explorer (Neo-tree) |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover docs |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>f` | Format file |

### Git
| Key | Action |
|-----|--------|
| `]h / [h` | Next/prev git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |

### Plugins
| Plugin | Purpose |
|--------|---------|
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | Mocha theme (matches tmux) |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax / indentation |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + mason | LSP |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + luasnip | Completion |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git decorations |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless tmux nav |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keymap hints |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto bracket pairs |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | `gcc` to comment |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround motions |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | TODO highlights |

---

## Syncing to a new machine

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

That's it.
