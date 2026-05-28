-- Neo-tree — file explorer
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch       = "v3.x",
    cmd          = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>",          desc = "Toggle file explorer" },
      { "<leader>o", "<cmd>Neotree focus<CR>",           desc = "Focus file explorer" },
      { "<leader>ge", "<cmd>Neotree git_status<CR>",     desc = "Git status tree" },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file  = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = false,
          hide_dotfiles   = false,
          hide_gitignored = false,
        },
      },
      window = {
        width    = 30,
        position = "left",
        mappings = {
          ["<space>"] = "none",
        },
      },
      default_component_configs = {
        indent    = { indent_size = 2, with_expanders = true },
        icon      = {
          folder_closed = "",
          folder_open   = "",
          folder_empty  = "󰜌",
        },
        git_status = {
          symbols = {
            added     = "",
            modified  = "",
            deleted   = "✖",
            renamed   = "󰁕",
            untracked = "",
            ignored   = "",
            unstaged  = "󰄱",
            staged    = "",
            conflict  = "",
          },
        },
      },
    },
  },
}
