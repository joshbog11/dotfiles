-- conform.nvim — format on save via biome
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd   = { "ConformInfo" },
    keys  = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        desc = "Format file",
      },
    },
    opts = {
      -- Biome handles JS/TS/JSON/CSS — add more filetypes as needed
      formatters_by_ft = {
        javascript      = { "biome" },
        javascriptreact = { "biome" },
        typescript      = { "biome" },
        typescriptreact = { "biome" },
        json            = { "biome" },
        jsonc           = { "biome" },
        css             = { "biome" },
        lua             = { "stylua" },  -- optional: install via :MasonInstall stylua
      },
      -- Format automatically on save
      format_on_save = {
        timeout_ms   = 500,
        lsp_fallback = true,  -- fall back to LSP formatter if biome isn't available
      },
    },
  },
}
