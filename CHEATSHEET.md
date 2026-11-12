# Cheatsheet

Forgot a key? In Neovim press `Space` and wait, or `Space s k` to search every keymap.

## The ten that matter most

| Key | Action |
|---|---|
| `Space Space` | Find a file |
| `Space /` | Search text in the project |
| `Space e` | File explorer |
| `Tab` / `Shift-Tab` | Next / previous open file |
| `Space x` | Close the current file |
| `gd` / `gr` | Go to definition / references |
| `K` | Docs for the thing under the cursor |
| `Space c a` | Code action (quick fix, import, refactor) |
| `Space g g` | LazyGit |
| `Ctrl-h/j/k/l` | Move between splits and panes (Neovim, Rex, tmux) |

---

## Neovim

Leader is `Space`. `Ctrl-s` or `Space w` saves. `Space q q` quits.

### Find and search

| Key | Action |
|---|---|
| `Space Space` | Files (smart: open, recent, project) |
| `Space f f` | Files |
| `Space f r` | Recent files |
| `Space ,` | Open files (buffers) |
| `Space /` or `Space f g` | Grep the project |
| `Space s w` | Grep the word under the cursor / selection |
| `Space s b` | Lines in this file |
| `Space s r` | Search and replace across the project |
| `Space s s` / `Space s S` | Symbols in file / project |
| `Space s d` | Diagnostics |
| `Space s t` | TODO comments |
| `Space s h` / `Space s k` | Help / keymaps |
| `Space s .` | Reopen the last picker |
| `/text` then `n` / `N` | Search in the file, next / previous |
| `s` + 2 chars + label | Jump anywhere on screen (flash) |

Inside a picker: type to filter, `Enter` opens, `Ctrl-v` / `Ctrl-s` open in a split, `Esc` closes.

### Files and windows

| Key | Action |
|---|---|
| `Space e` / `Space E` | Explorer: open or focus / close |
| in explorer | `a` add, `r` rename, `d` delete, `m` move, `y` copy, `H` hidden files, `?` help |
| `Tab` / `Shift-Tab` | Next / previous file |
| `Space x` | Close file |
| `Space b o` | Close all other files |
| `Space b b` | Switch to the previous file |
| `Space a` | Harpoon: pin this file |
| `Space h` | Harpoon: list of pinned files |
| `Space 1` … `Space 5` | Harpoon: jump to pinned file |
| `Space \|` / `Space -` | Split right / below |
| `Ctrl-w q` | Close split |
| `Ctrl-h/j/k/l` | Move between splits (and out into Rex / tmux panes) |
| `Ctrl-arrows` | Resize split |
| `Ctrl-/` | Toggle a terminal |

### Code (LSP)

| Key | Action |
|---|---|
| `gd` / `gD` | Definition / declaration |
| `gr` | References |
| `gI` / `gy` | Implementation / type definition |
| `K` | Hover docs |
| `Space c a` | Code action |
| `Space c r` (or `Space r n`) | Rename symbol |
| `Space c o` | Organise imports |
| `Space c f` | Format file or selection |
| `Space c R` | Rename file and update imports |
| `Space c d` | Show the diagnostic on this line |
| `]d` / `[d` | Next / previous diagnostic |
| `]e` / `[e` | Next / previous error |
| `Space t t` / `Space t b` | Diagnostics panel: project / file |
| `Space t s` | Symbols outline |
| `]]` / `[[` | Next / previous use of the symbol under the cursor |
| `Space c l` | LSP status |
| `Space c m` | Mason (install tools) |

Completion: `Enter` accepts, `Tab` / `Shift-Tab` move, `Ctrl-Space` opens the menu, `Ctrl-e` dismisses.

### Git

| Key | Action |
|---|---|
| `Space g g` | LazyGit (`q` to return) |
| `Space g d` | Diff view of all changes (same key closes it) |
| `Space g f` / `Space g F` | History of this file / repository |
| `Space g s` | Changed files |
| `Space g b` | Branches |
| `Space g B` | Open file or selection on GitHub |
| `]h` / `[h` | Next / previous change |
| `Space g h s` | Stage / unstage change |
| `Space g h r` | Discard change |
| `Space g h p` | Preview change |
| `Space g h b` | Blame line |
| `Space u g` | Toggle inline blame |

### Editing

| Key | Action |
|---|---|
| `gcc` / `gc` + motion | Toggle comment |
| `Alt-j` / `Alt-k` | Move line or selection down / up |
| `<` / `>` (visual) | Indent, keeps the selection |
| `ysiw"` | Surround word with `"` |
| `cs"'` / `ds"` | Change / delete surrounding |
| `ci"` `da(` `vif` | Change in quotes, delete around parens, select function call |
| `]t` / `[t` | Next / previous TODO |
| `Space s u` | Undo history |
| `zR` / `zM` / `za` | Open all / close all / toggle fold |

### Toggles and sessions

| Key | Action |
|---|---|
| `Space u t` | Pick theme (terminal + tmux + Neovim) |
| `Space u b` | Transparent background |
| `Space u f` | Format on save |
| `Space u h` | Inlay hints |
| `Space u d` | Diagnostics |
| `Space u w` / `Space u s` | Line wrap / spelling |
| `Space u c` | Sticky function header |
| `Space u z` | Zen mode |
| `Space q s` | Restore this folder's session |
| `Space q l` | Restore the last session |
| `Space l` | Plugin manager |

---

## Rex and tmux

Same keys in both. Prefix is `Ctrl-Space`: press, release, then the key.

| Key | Rex | tmux |
|---|---|---|
| `Ctrl-h/j/k/l` | Move between panes and Neovim splits | same |
| `prefix \|` or `%` | Split right | same |
| `prefix -` or `"` | Split down | same |
| `prefix h/j/k/l` | Focus pane | same |
| `prefix H/J/K/L` | Resize pane | same |
| `prefix x` | Close pane | same |
| `prefix z` | Zoom pane | same |
| `prefix c` | New tab | New window |
| `prefix n` / `p` | Next / previous tab | Next / previous window |
| `prefix 1`-`9` | Go to tab | Go to window |
| `prefix ,` | Rename tab | Rename window |
| `prefix s` | Switch session | same |
| `prefix $` | Rename session | same |
| `prefix g` | LazyGit | same (popup) |
| `prefix r` | Reload config | same |
| `prefix Ctrl-l` | Clear screen | same |
| `prefix prefix` | Send a real `Ctrl-Space` | same |

Rex only: `prefix d` dev layout (Neovim + shell), `prefix f` float pane, `prefix =` balance splits, `prefix b` sidebar, `prefix ?` command palette. Rex's own shortcuts still work: `Cmd-D` split, `Cmd-T` tab, `Cmd-K` sessions, `Cmd-P` go to anything, `Cmd-Shift-P` palette.

tmux only: `prefix f` project picker, `prefix d` detach, `prefix [` copy mode (`v` select, `y` copy, `q` quit), `Alt-Shift-h/l` previous / next window.

---

## Shell

| Command / key | Action |
|---|---|
| `theme` | Pick a colour scheme for everything |
| `cd <keyword>` / `cdi` | Jump to a directory by habit / pick one |
| `Ctrl-r` | Search command history |
| `Ctrl-t` / `Alt-c` | Insert a file path / change directory |
| `Up` / `Down` | History matching what is already typed |
| `ll` / `tree` | Detailed listing / tree |
| `lg` / `nv` | LazyGit / Neovim |
| `dots` | Open this repo in Neovim |
| `zrc` / `src` | Edit / reload `~/.zshrc` |

## LazyGit

| Key | Action |
|---|---|
| `Space` | Stage / unstage |
| `c` | Commit |
| `p` / `P` | Pull / push |
| `b` | Branches |
| `z` | Undo |
| `?` | All keys |
| `q` | Quit |
