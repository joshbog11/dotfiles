-- Theme manager + a set of themes to pick from
-- Open picker: <leader>th  (or :Themery)
-- Your choice is saved and restored on next launch automatically

return {
	-- ── Themes ─────────────────────────────────────────────────
	{ "catppuccin/nvim", name = "catppuccin", lazy = true },
	{ "folke/tokyonight.nvim", lazy = true },
	{ "rebelot/kanagawa.nvim", lazy = true },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true },
	{ "ellisonleao/gruvbox.nvim", lazy = true },
	{ "EdenEast/nightfox.nvim", lazy = true },
	{ "sainnhe/everforest", lazy = true },
	{ "Aejkatappaja/sora", lazy = true },
	{ "olimorris/onedarkpro.nvim", lazy = true },
	{ "projekt0n/github-nvim-theme", lazy = true },
	{ "sainnhe/gruvbox-material", lazy = true },
	-- ── Themery — live preview theme switcher ──────────────────
	{
		"zaldih/themery.nvim",
		lazy = false, -- must load at startup to restore saved theme
		priority = 1000,
		opts = {
			themes = {
				{ name = "Catppuccin Mocha", colorscheme = "catppuccin-mocha" },
				{ name = "Catppuccin Latte", colorscheme = "catppuccin-latte" },
				{ name = "Catppuccin Frappe", colorscheme = "catppuccin-frappe" },
				{ name = "Catppuccin Macchiato", colorscheme = "catppuccin-macchiato" },
				{ name = "Tokyo Night", colorscheme = "tokyonight" },
				{ name = "Tokyo Night Storm", colorscheme = "tokyonight-storm" },
				{ name = "Tokyo Night Moon", colorscheme = "tokyonight-moon" },
				{ name = "Kanagawa Wave", colorscheme = "kanagawa-wave" },
				{ name = "Kanagawa Dragon", colorscheme = "kanagawa-dragon" },
				{ name = "Rose Pine", colorscheme = "rose-pine" },
				{ name = "Rose Pine Moon", colorscheme = "rose-pine-moon" },
				{ name = "Rose Pine Dawn", colorscheme = "rose-pine-dawn" },
				{ name = "Gruvbox Dark", colorscheme = "gruvbox" },
				{ name = "Gruvbox Light", colorscheme = "gruvbox", before = [[ vim.o.background = "light" ]] },
				{ name = "Gruvbox Dark", colorscheme = "gruvbox" },
				{ name = "Nightfox", colorscheme = "nightfox" },
				{ name = "Carbonfox", colorscheme = "carbonfox" },
				{ name = "Everforest", colorscheme = "everforest" },
				{
					name = "Sora",
					colorscheme = "sora",
					before = [[ require("sora").setup() ]],
				},
				{ name = "One Dark Pro", colorscheme = "onedark_dark" },
				{ name = "One Dark Pro Vivid", colorscheme = "onedark_vivid" },
				{ name = "One Dark Pro Warm", colorscheme = "onelight" },
				{ name = "Github Theme", colorscheme = "github_dark_high_contrast" },
				{ name = "Gruvbox Material Dark", colorscheme = "gruvbox-material" },
				{
					name = "Gruvbox Material Soft",
					colorscheme = "gruvbox-material",
					before = [[ vim.g.gruvbox_material_background = "soft" ]],
				},
				{
					name = "Gruvbox Material Medium",
					colorscheme = "gruvbox-material",
					before = [[ vim.g.gruvbox_material_background = "medium" ]],
				},
				{
					name = "Gruvbox Material Hard",
					colorscheme = "gruvbox-material",
					before = [[ vim.g.gruvbox_material_background = "hard" ]],
				},
			},
			livePreview = true,
		},
		keys = {
			{ "<leader>th", "<cmd>Themery<CR>", desc = "Theme picker" },
		},
	},
}
