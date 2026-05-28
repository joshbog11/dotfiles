-- Bufferline — open files shown as tabs at the top
return {
  {
    "akinsho/bufferline.nvim",
    version      = "*",
    lazy         = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<S-l>",      "<cmd>BufferLineCycleNext<CR>",     desc = "Next buffer" },
      { "<S-h>",      "<cmd>BufferLineCyclePrev<CR>",     desc = "Prev buffer" },
      { "<leader>bd", "<cmd>bdelete<CR>",                 desc = "Close buffer" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<CR>",     desc = "Pin buffer" },
      { "<leader>bD", "<cmd>BufferLineCloseOthers<CR>",   desc = "Close other buffers" },
    },
    opts = {
      options = {
        mode              = "buffers",
        numbers           = "none",
        diagnostics       = "nvim_lsp",
        show_buffer_close_icons = true,
        show_close_icon         = false,
        separator_style         = "slant",
        always_show_bufferline  = true,
        offsets = {
          {
            filetype   = "neo-tree",
            text       = "Explorer",
            text_align = "center",
            separator  = true,
          },
        },
      },
    },
  },
}
