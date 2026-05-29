# Cheatsheet

## Tmux
> Prefix: `Ctrl + Space` (press and release, then the next key)

### Sessions & Windows
| Key | Action |
|-----|--------|
| `C-Space c` | New window |
| `C-Space ,` | Rename window |
| `C-Space s` | List / switch sessions |
| `C-Space $` | Rename session |
| `Shift + →` | Next window |
| `Shift + ←` | Previous window |
| `Alt + L` | Next window |
| `Alt + H` | Previous window |
| `C-Space 1-9` | Jump to window by number |

### Panes
| Key | Action |
|-----|--------|
| `C-Space %` | Split vertical |
| `C-Space "` | Split horizontal |
| `C-Space x` | Close pane |
| `C-Space h/j/k/l` | Move between panes |
| `Alt + ←/→/↑/↓` | Move between panes (no prefix) |

### Copy Mode
| Key | Action |
|-----|--------|
| `C-Space [` | Enter copy mode |
| `v` | Begin selection |
| `C-v` | Rectangle selection |
| `y` | Yank (copy to clipboard) |
| `q` | Exit copy mode |

---

## Neovim
> Leader key: `Space`

### Files
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in project) |
| `<leader>fb` | Open buffers |
| `<leader>fr` | Recent files |
| `<leader>fc` | Find word under cursor |
| `<leader>e` | Open file explorer |
| `<leader>E` | Close file explorer |
| `Tab` | Next open file |
| `Shift + Tab` | Previous open file |
| `<leader>x` | Close current file |

### Splits
| Key | Action |
|-----|--------|
| `<C-w>v` | Vertical split |
| `<C-w>s` | Horizontal split |
| `<C-w>q` | Close split |
| `<C-h/j/k/l>` | Move between splits |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gi` | Go to implementation |
| `K` | Hover docs |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>cf` | Format file |
| `[d / ]d` | Prev / next diagnostic |
| `<leader>de` | Show diagnostic float |

### Git
| Key | Action |
|-----|--------|
| `<leader>gg` | Open LazyGit TUI |
| `<leader>gd` | Diff working tree |
| `<leader>gD` | Close diffview |
| `<leader>gh` | Current file history |
| `<leader>gH` | Repo history |
| `]h / [h` | Next / prev hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>hu` | Undo stage |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line (full) |
| `<leader>hB` | Toggle inline blame |
| `<leader>hd` | Diff hunk |

### Search
| Key | Action |
|-----|--------|
| `/foo` | Search forward |
| `?foo` | Search backward |
| `n / N` | Next / prev match |
| `*` | Search word under cursor |
| `<leader>fg` | Search across project |

### Editing
| Key | Action |
|-----|--------|
| `gcc` | Toggle comment |
| `gc` + motion | Comment motion |
| `<A-j/k>` | Move line/selection up/down |
| `> / <` | Indent / dedent (stays selected) |
| `ys` + motion + char | Surround (e.g. `ysiw"`) |
| `cs` + old + new | Change surround |
| `ds` + char | Delete surround |

### Misc
| Key | Action |
|-----|--------|
| `<leader>th` | Theme picker |
| `<leader>u` | Undotree |
| `<leader>w` | Save |
| `<leader>q` | Quit |
| `]t / [t` | Next / prev TODO |
| `<leader>ft` | Find TODOs |

---

## LazyGit (inside `<leader>gg`)
| Key | Action |
|-----|--------|
| `space` | Stage / unstage file |
| `c` | Commit |
| `p` | Push |
| `P` | Pull |
| `b` | Branches |
| `z` | Stash |
| `d` | Diff |
| `e` | Edit file |
| `q` | Quit LazyGit |
