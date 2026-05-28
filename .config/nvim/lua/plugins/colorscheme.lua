-- Theme manager + a set of themes to pick from
-- Open picker: <leader>th  (or :Themery)
-- Your choice is saved and restored on next launch automatically

return {

  -- ── Themes ─────────────────────────────────────────────────
  { "catppuccin/nvim",           name = "catppuccin", lazy = true },
  { "folke/tokyonight.nvim",     lazy = true },
  { "rebelot/kanagawa.nvim",     lazy = true },
  { "rose-pine/neovim",          name = "rose-pine", lazy = true },
  { "ellisonleao/gruvbox.nvim",  lazy = true },
  { "EdenEast/nightfox.nvim",    lazy = true },
  { "sainnhe/everforest",        lazy = true },

  -- ── Themery — live preview theme switcher ──────────────────
  {
    "zaldih/themery.nvim",
    lazy = false,   -- must load at startup to restore saved theme
    priority = 1000,
    opts = {
      themes = {
        { name = "Catppuccin Mocha",    colorscheme = "catppuccin-mocha" },
        { name = "Catppuccin Latte",    colorscheme = "catppuccin-latte" },
        { name = "Catppuccin Frappe",   colorscheme = "catppuccin-frappe" },
        { name = "Catppuccin Macchiato",colorscheme = "catppuccin-macchiato" },
        { name = "Tokyo Night",         colorscheme = "tokyonight" },
        { name = "Tokyo Night Storm",   colorscheme = "tokyonight-storm" },
        { name = "Tokyo Night Moon",    colorscheme = "tokyonight-moon" },
        { name = "Kanagawa Wave",       colorscheme = "kanagawa-wave" },
        { name = "Kanagawa Dragon",     colorscheme = "kanagawa-dragon" },
        { name = "Rose Pine",           colorscheme = "rose-pine" },
        { name = "Rose Pine Moon",      colorscheme = "rose-pine-moon" },
        { name = "Gruvbox Dark",        colorscheme = "gruvbox" },
        { name = "Nightfox",            colorscheme = "nightfox" },
        { name = "Carbonfox",           colorscheme = "carbonfox" },
        { name = "Everforest",          colorscheme = "everforest" },
      },
      themeConfigFile = vim.fn.stdpath("data") .. "/themery.lua",
      livePreview = true,
    },
    keys = {
      { "<leader>th", "<cmd>Themery<CR>", desc = "Theme picker" },
    },
  },
}
