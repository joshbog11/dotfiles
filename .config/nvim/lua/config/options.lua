-- ============================================================
-- options.lua — core vim options
-- ============================================================

-- Force public npm registry at startup so Mason installs never hit internal Nexus
vim.env.NPM_CONFIG_REGISTRY = "https://registry.npmjs.org"

-- Ensure Homebrew binaries are visible to nvim (Apple Silicon + Intel)
local brew_paths = { "/opt/homebrew/bin", "/usr/local/bin" }
for _, p in ipairs(brew_paths) do
	if not vim.env.PATH:find(p, 1, true) then
		vim.env.PATH = p .. ":" .. vim.env.PATH
	end
end

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Splits open to the right / below (feels natural)
opt.splitright = true
opt.splitbelow = true

-- Clipboard — sync with system clipboard
opt.clipboard = "unnamedplus"

-- Persistent undo
opt.undofile = true

-- Faster update time (for gitsigns etc.)
opt.updatetime = 250
opt.timeoutlen = 300

-- Don't show mode in cmdline (lualine handles it)
opt.showmode = false

-- Keep signcolumn on by default
opt.signcolumn = "yes"

-- Enable treesitter for data structure folding
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Enable built-in syntax highlighting for filetypes not handled by treesitter
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "yaml", "xml", "ts", "js", "md", "json", "sh" },
	callback = function()
		if not vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
			vim.cmd("syntax on")
		end
	end,
})

-- Force correct filetypes — overrides any bad detection from plugins or path matching
vim.filetype.add({
	extension = {
		ts = "typescript",
		tsx = "typescriptreact",
		js = "javascript",
		jsx = "javascriptreact",
		mts = "typescript",
		cts = "typescript",
		yaml = "yaml",
		yml = "yaml",
		txt = "markdown",
	},
})

-- Autocmd fallback: force yaml for .yaml/.yml files that slip through
-- (swagger, helm-overrides, and similar get misdetected by plugins)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.yaml", "*.yml" },
	callback = function(args)
		if vim.bo[args.buf].filetype ~= "yaml" then
			vim.bo[args.buf].filetype = "yaml"
		end
	end,
})

-- Reset terminal color palette when nvim exits so other apps (k9s etc.) are unaffected
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		io.write("\027]104\007") -- reset terminal color palette
		io.write("\027]110\007") -- reset terminal foreground
		io.write("\027]111\007") -- reset terminal background
		io.write("\027]112\007") -- reset cursor color
	end,
})
