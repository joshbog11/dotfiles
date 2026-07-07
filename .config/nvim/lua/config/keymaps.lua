-- ============================================================
-- keymaps.lua — global keymaps (non-plugin)
-- ============================================================

local map = vim.keymap.set

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Normal mode ──────────────────────────────────────────────
-- Save
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
-- Quit
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Better window navigation (also handled by vim-tmux-navigator)
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- Move lines up/down
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Paste without overwriting register
map("v", "p", '"_dP')

-- ── Buffer navigation ─────────────────────────────────────────
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>x", function()
	-- Switch to prev buffer first so the window stays open
	local bufs = vim.fn.getbufinfo({ buflisted = 1 })
	if #bufs > 1 then
		vim.cmd("bprevious")
	end
	vim.cmd("bdelete #")
end, { desc = "Close current buffer" })

-- ── Diagnostics ───────────────────────────────────────────────
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- UFO Fold Keymaps --
vim.keymap.set("n", "zR", function()
	require("ufo").openAllFolds()
end, { desc = "Open all folds" })
vim.keymap.set("n", "zM", function()
	require("ufo").openAllFolds()
end, { desc = "Close all folds" })

-- Yank --
map("x", "<leader>p", [["_dP"]], opts)
map({ "n", "v" }, "<leader>y", [["+y]], opts)
map("n", "<leader>Y", [["+Y]], opts)

-- Selection Macros --
map("n", "<leader>sa", "ggVG", { desc = "Select entire file contents" })
map("n", "<leader>sw", "viw", { desc = "Select inner word" })
map("n", "<leader>sb", "vi(", { desc = "Select inner parenthesis" })
map("n", "<leader>sB", "vi{", { desc = "Select inner curly braces" })
map("n", "<leader>sq", 'vi"', { desc = "Select inner double quotes" })

-- Replacement Macros --
map("n", "<leader>rp", [[:%s/\<<C-r><C-w>\>/]], { desc = "Replace word under cursor" })
