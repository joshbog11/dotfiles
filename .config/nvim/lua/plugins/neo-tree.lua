-- Neo-tree — file explorer with auto-resize based on longest filename
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
      { "<leader>e",  "<cmd>Neotree reveal<CR>",         desc = "Open file explorer" },
      { "<leader>E",  "<cmd>Neotree close<CR>",         desc = "Close file explorer" },
      { "<leader>ge", "<cmd>Neotree git_status<CR>",   desc = "Git status tree" },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file    = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible        = false,
          hide_dotfiles  = false,
          hide_gitignored = false,
        },
      },
      window = {
        width    = 30,
        position = "left",
        mappings = { ["<space>"] = "none" },
      },
      default_component_configs = {
        indent     = { indent_size = 2, with_expanders = true },
        icon       = {
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
      -- Auto-resize window to fit the longest visible filename
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.defer_fn(function()
              local winid = vim.fn.bufwinid(vim.fn.bufnr())
              if winid == -1 then return end
              local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
              local max_width = 30
              for _, line in ipairs(lines) do
                max_width = math.max(max_width, #line + 2)
              end
              -- Cap between 30 and 60 so it doesn't get ridiculous
              max_width = math.min(max_width, 60)
              vim.api.nvim_win_set_width(winid, max_width)
            end, 50)
          end,
        },
      },
    },
  },
}
