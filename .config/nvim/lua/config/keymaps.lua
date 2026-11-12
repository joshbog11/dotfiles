-- Global keymaps. Plugin-specific keymaps live next to the plugin in lua/plugins.
-- Press <Space> and wait: which-key shows every available mapping.

local map = vim.keymap.set

-- ── Windows and panes ───────────────────────────────────────
-- Ctrl-h/j/k/l: Neovim splits first, then tmux / Rex panes.
require("config.navigate").setup()

map("n", "<leader>|", "<C-w>v", { desc = "Split right" })
map("n", "<leader>-", "<C-w>s", { desc = "Split below" })
-- Close a split with <C-w>q, keep only this one with <C-w>o, equalise with <C-w>=.
-- Press <C-w> and wait to see the rest.

map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Taller window" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Shorter window" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Narrower window" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Wider window" })

-- ── Files ───────────────────────────────────────────────────
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>write<cr><esc>", { desc = "Save file" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })
map("n", "<leader>qq", "<cmd>quitall<cr>", { desc = "Quit Neovim" })

-- ── Buffers (open files) ────────────────────────────────────
-- <Tab>/<S-Tab> cycling and <leader>x close are defined with bufferline and
-- snacks so they follow the order shown in the tab bar.
map("n", "<leader>bb", "<cmd>buffer #<cr>", { desc = "Switch to previous file" })
-- <Tab> and <C-i> are the same key in old terminals. Mapping <C-i> to itself
-- keeps "jump forward" working in Ghostty and Rex, which can tell them apart.
map("n", "<C-i>", "<C-i>", { desc = "Jump forward" })

-- ── Editing ─────────────────────────────────────────────────
map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", { desc = "Clear search highlight" })

-- Move lines up and down
map("n", "<A-j>", "<cmd>move .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>move .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<Esc><cmd>move .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc><cmd>move .-2<cr>==gi", { desc = "Move line up" })
map("x", "<A-j>", ":move '>+1<cr>gv=gv", { desc = "Move selection down", silent = true })
map("x", "<A-k>", ":move '<-2<cr>gv=gv", { desc = "Move selection up", silent = true })

-- Keep the selection when indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Paste over a selection without losing what was yanked
map("x", "p", '"_dP', { desc = "Paste (keep register)" })

-- Move by screen line when lines wrap
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Keep the cursor centred while jumping
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Previous search result" })

-- Undo break-points so one undo does not wipe a whole sentence
for _, char in ipairs({ ",", ".", ";" }) do
  map("i", char, char .. "<C-g>u")
end

-- ── Diagnostics ─────────────────────────────────────────────
-- ]d / [d (next / previous diagnostic) are Neovim defaults.
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "]e", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Next error" })
map("n", "[e", function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Previous error" })

-- ── Quickfix ────────────────────────────────────────────────
map("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprevious<cr>zz", { desc = "Previous quickfix item" })

-- ── Terminal ────────────────────────────────────────────────
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })

-- ── Tools ───────────────────────────────────────────────────
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Plugins (Lazy)" })
