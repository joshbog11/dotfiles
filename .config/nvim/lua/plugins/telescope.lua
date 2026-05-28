-- Telescope — fuzzy finder
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd          = "Telescope",
    version      = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond  = function() return vim.fn.executable("make") == 1 end,
      },
    },
    opts = {
      defaults = {
        prompt_prefix   = "  ",
        selection_caret = " ",
        path_display    = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
        },
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>",              desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",               desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",                 desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",               desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>",                desc = "Recent files" },
      { "<leader>fc", "<cmd>Telescope grep_string<CR>",             desc = "Find word under cursor" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>",             desc = "Diagnostics" },
      { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer fuzzy find" },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
