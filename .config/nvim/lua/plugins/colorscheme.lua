-- Catppuccin Mocha — matches tmux theme
return {
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    lazy     = false,   -- must load at startup so lualine can use its theme
    priority = 1000,
    opts = {
      flavour          = "mocha",
      transparent_background = false,
      integrations = {
        cmp           = true,
        gitsigns      = true,
        nvimtree      = false,
        neo_tree      = true,
        treesitter    = true,
        telescope     = { enabled = true },
        lsp_trouble   = true,
        which_key     = true,
        indent_blankline = { enabled = true },
        mason         = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
