-- Miscellaneous quality-of-life plugins
return {
  -- Which-key — keymap hints popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {
      icons    = { mappings = false },
      defaults = {},
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { "<leader>f",  group = "find (telescope)" },
        { "<leader>h",  group = "git hunks" },
        { "<leader>b",  group = "buffer" },
        { "<leader>c",  group = "code / LSP" },
      })
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main  = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts  = {
      indent = { char = "│" },
      scope  = { enabled = true },
    },
  },

  -- Auto-pairs
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    opts   = { check_ts = true },
  },

  -- Comment toggling  (gcc / gc<motion>)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts  = {},
  },

  -- Surround motions (ys / cs / ds)
  {
    "kylechui/nvim-surround",
    event   = "VeryLazy",
    version = "*",
    opts    = {},
  },

  -- Better UI for vim.ui.select / input
  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = {},
  },

  -- Highlight todo/fixme/note comments
  {
    "folke/todo-comments.nvim",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = {},
    keys = {
      { "]t",          function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t",          function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
      { "<leader>ft",  "<cmd>TodoTelescope<CR>",                           desc = "Find todos" },
    },
  },
}
