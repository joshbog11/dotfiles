-- Core editor options. Nothing here depends on a plugin.

-- Leader keys must be set before plugins load.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Format on save is on by default. Toggle with <leader>uf.
vim.g.autoformat = true

-- Make Homebrew tools (LSP servers, formatters, tree-sitter) visible even when
-- Neovim is started from an app that does not read the shell profile.
for _, dir in ipairs({ "/opt/homebrew/bin", "/usr/local/bin", "/home/linuxbrew/.linuxbrew/bin" }) do
  if vim.uv.fs_stat(dir) and not (":" .. vim.env.PATH .. ":"):find(":" .. dir .. ":", 1, true) then
    vim.env.PATH = dir .. ":" .. vim.env.PATH
  end
end

-- Unused remote-plugin providers only add startup work and :checkhealth noise.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation (per-project .editorconfig files override these automatically)
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftround = true
opt.smartindent = true
opt.breakindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split" -- live preview of :s replacements

-- Appearance
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.linebreak = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.showmode = false -- the statusline shows it
opt.laststatus = 3 -- one statusline for all windows
opt.pumheight = 12
opt.winborder = "rounded"
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldclose = "▸", foldsep = " ", diff = "╱" }
opt.smoothscroll = true
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Splits
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"

-- Files, undo and sessions
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.autowrite = true
opt.confirm = true -- ask instead of failing when quitting with unsaved changes
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Responsiveness
opt.updatetime = 200
opt.timeoutlen = 300

-- Editing
opt.mouse = "a"
opt.virtualedit = "block"
opt.completeopt = "menu,menuone,noselect"
opt.formatoptions = "jcroqlnt"
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"
opt.jumpoptions = "view"
opt.spelllang = { "en_gb", "en" }

-- System clipboard. Over SSH there is no pbcopy on the remote machine, so use
-- the terminal's OSC 52 support: yanks still land in your local clipboard.
opt.clipboard = "unnamedplus"
if vim.env.SSH_TTY then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
end

-- Folding uses Tree-sitter when a parser is available and is fully open by default.
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Terminal title. Rex reads this to tell whether a pane is running Neovim, so
-- Ctrl-h/j/k/l can be handed to Neovim instead of moving the Rex focus.
-- Keep the "nvim" prefix if you change it (see ~/.config/rex/init.lua).
opt.title = true
opt.titlestring = "nvim: %t"
opt.titleold = vim.fn.fnamemodify(vim.o.shell, ":t")
