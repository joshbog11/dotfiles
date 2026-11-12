-- Moving around a project: key hints, diagnostics list, file marks, search and
-- replace, sessions, TODO comments.

return {
  -- Shows what every key does. Press <Space> (or any prefix) and wait.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>b", group = "buffers" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find / files" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit / session" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "trouble (lists)" },
        { "<leader>u", group = "ui toggles" },
        { "[", group = "previous" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "z", group = "fold / view" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Keys for this buffer" },
    },
  },

  -- A proper panel for diagnostics, references and quickfix.
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { focus = true },
    keys = {
      { "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (project)" },
      { "<leader>tb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (this file)" },
      { "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols outline" },
      { "<leader>tr", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "References / definitions" },
      { "<leader>tq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
      { "<leader>tl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
    },
  },

  -- TODO / FIXME / NOTE comments: highlighted and searchable.
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO" },
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "TODOs" },
      { "<leader>tT", "<cmd>Trouble todo toggle<cr>", desc = "TODOs" },
    },
  },

  -- Harpoon: pin the handful of files you are working on and jump instantly.
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { settings = { save_on_toggle = true } },
    keys = function()
      local keys = {
        { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon: pin this file" },
        {
          "<leader>h",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon: pinned files",
        },
      }
      for i = 1, 5 do
        table.insert(keys, {
          "<leader>" .. i,
          function() require("harpoon"):list():select(i) end,
          desc = "Harpoon: go to file " .. i,
        })
      end
      return keys
    end,
  },

  -- Project-wide search and replace with a live preview.
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>sr",
        function()
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          require("grug-far").open({
            transient = true,
            prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil },
          })
        end,
        mode = { "n", "x" },
        desc = "Search and replace",
      },
    },
  },

  -- Sessions: reopen a project exactly where you left it.
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session (this folder)" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qS", function() require("persistence").select() end, desc = "Pick a session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Do not save this session" },
    },
  },
}
