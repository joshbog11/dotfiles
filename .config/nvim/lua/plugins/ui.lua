-- What the editor looks like: icons, statusline, buffer tabs.

return {
  -- File-type icons (also answers requests for nvim-web-devicons).
  {
    "nvim-mini/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- Statusline: mode, branch, diagnostics, file path, LSP, position.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local function lsp_names()
        local names = {}
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
          names[#names + 1] = client.name
        end
        return table.concat(names, " ")
      end

      return {
        options = {
          -- Provided by tinted-nvim; follows the active Tinty scheme. ("auto" would
          -- pick lualine's own base16 theme, which needs a plugin we don't use.)
          theme = "tinted",
          globalstatus = true,
          section_separators = "",
          component_separators = "│",
          disabled_filetypes = { statusline = { "snacks_dashboard" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            { "diagnostics" },
            { "filename", path = 1, symbols = { modified = "●", readonly = "[ro]", unnamed = "[new]" } },
          },
          lualine_x = {
            { lsp_names, color = "Comment" },
            { "filetype", icon_only = false },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "lazy", "quickfix", "trouble" },
      }
    end,
  },

  -- Open files as tabs along the top. <Tab> / <S-Tab> cycle through them.
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "thin",
        close_command = function(n) Snacks.bufdelete(n) end,
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        offsets = {
          { filetype = "snacks_layout_box" },
        },
      },
    },
    keys = {
      { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next file" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous file" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next file" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous file" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin file" },
      { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close files to the right" },
      { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close files to the left" },
      { "<leader>b<", "<cmd>BufferLineMovePrev<cr>", desc = "Move file left" },
      { "<leader>b>", "<cmd>BufferLineMoveNext<cr>", desc = "Move file right" },
    },
  },
}
