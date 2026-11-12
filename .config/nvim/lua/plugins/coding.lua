-- Typing code: completion, snippets, pairs, surround, text objects, jumping.

return {
  -- Completion. Fast (Rust fuzzy matcher), LSP + path + snippets + buffer words.
  --   <CR>            accept          <Tab>/<S-Tab>  next / previous item or snippet field
  --   <C-Space>       open menu/docs  <C-e>          dismiss
  --   <C-b>/<C-f>     scroll docs     <C-k>          signature help
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    opts_extend = { "sources.default" },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        list = { selection = { preselect = true, auto_insert = false } },
        accept = { auto_brackets = { enabled = true } },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        menu = { draw = { treesitter = { "lsp" } } },
      },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      -- Falls back to a Lua matcher if the prebuilt binary cannot be downloaded
      -- (for example behind a corporate proxy).
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },

  -- Makes the Lua language server understand the Neovim API in this config.
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim", "LazySpec" } },
      },
    },
  },

  -- Auto-close brackets and quotes.
  { "nvim-mini/mini.pairs", event = "InsertEnter", opts = {} },

  -- Surround: ysiw"  add   cs"'  change   ds"  delete
  { "kylechui/nvim-surround", version = "*", event = "VeryLazy", opts = {} },

  -- Better text objects: va) ci" daa (argument) vif (function call) etc.
  { "nvim-mini/mini.ai", event = "VeryLazy", opts = { n_lines = 500 } },

  -- gcc / gc{motion} comments are built into Neovim; this picks the right
  -- comment style inside JSX/TSX and other embedded languages.
  { "folke/ts-comments.nvim", event = "VeryLazy", opts = {} },

  -- Jump anywhere on screen: s + two characters + label.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Jump (flash)" },
      { "S", function() require("flash").treesitter() end, mode = { "n", "o" }, desc = "Select syntax node (flash)" },
      { "r", function() require("flash").remote() end, mode = "o", desc = "Remote flash" },
    },
  },
}
