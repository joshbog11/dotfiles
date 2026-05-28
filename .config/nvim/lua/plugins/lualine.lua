-- Lualine — statusline (catppuccin theme)
return {
  {
    "nvim-lualine/lualine.nvim",
    event        = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "catppuccin/nvim",   -- ensure catppuccin is loaded before lualine applies the theme
    },
    opts = {
      options = {
        theme                = "catppuccin",
        globalstatus         = true,
        disabled_filetypes   = { statusline = { "dashboard", "alpha", "starter" } },
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          { "diagnostics" },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename",  path = 1, symbols = { modified = "  ", readonly = " ", unnamed = "" } },
        },
        lualine_x = {
          { "diff", symbols = { added = " ", modified = " ", removed = " " } },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
