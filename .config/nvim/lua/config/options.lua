-- ============================================================
-- options.lua — core vim options
-- ============================================================

-- Force public npm registry at startup so Mason installs never hit internal Nexus
vim.env.NPM_CONFIG_REGISTRY = "https://registry.npmjs.org"

local opt = vim.opt

-- Line numbers
opt.number         = true
opt.relativenumber = true

-- Indentation
opt.tabstop        = 2
opt.shiftwidth     = 2
opt.expandtab      = true
opt.smartindent    = true

-- Wrapping
opt.wrap           = false

-- Search
opt.ignorecase     = true
opt.smartcase      = true
opt.hlsearch       = false
opt.incsearch      = true

-- Appearance
opt.termguicolors  = true
opt.signcolumn     = "yes"
opt.cursorline     = true
opt.scrolloff      = 8
opt.sidescrolloff  = 8

-- Splits open to the right / below (feels natural)
opt.splitright     = true
opt.splitbelow     = true

-- Clipboard — sync with system clipboard
opt.clipboard      = "unnamedplus"

-- Persistent undo
opt.undofile       = true

-- Faster update time (for gitsigns etc.)
opt.updatetime     = 250
opt.timeoutlen     = 300

-- Don't show mode in cmdline (lualine handles it)
opt.showmode       = false

-- Keep signcolumn on by default
opt.signcolumn     = "yes"

-- Reset terminal color palette when nvim exits so other apps (k9s etc.) are unaffected
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    io.write("\027]104\007")  -- reset terminal color palette
    io.write("\027]110\007")  -- reset terminal foreground
    io.write("\027]111\007")  -- reset terminal background
    io.write("\027]112\007")  -- reset cursor color
  end,
})
