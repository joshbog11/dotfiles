-- LSP — mason + lspconfig
--
-- On macOS: npm-based servers (ts_ls, html, cssls, jsonls, lua_ls, pyright)
-- are installed via Homebrew in install.sh — no Mason/npm needed for those.
-- Mason only handles tools with GitHub binary releases (biome, stylua).
--
-- On Linux: Mason handles everything fine (no Nexus issue).

return {
  -- Mason: only install GitHub-binary tools (no npm)
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup({ ui = { border = "rounded" } })
    end,
  },

  -- mason-lspconfig: bridge for any servers Mason does manage
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      -- Only tools with GitHub binary releases — safe on corporate Macs
      ensure_installed = {
        "biome",   -- Rust binary from GitHub, no npm
        "stylua",  -- Rust binary from GitHub, no npm
      },
      automatic_installation = false,
    },
  },

  -- Core LSP config
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig    = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end
        map("gd",         vim.lsp.buf.definition,     "Go to definition")
        map("gD",         vim.lsp.buf.declaration,    "Go to declaration")
        map("gr",         vim.lsp.buf.references,     "References")
        map("gi",         vim.lsp.buf.implementation, "Go to implementation")
        map("K",          vim.lsp.buf.hover,          "Hover docs")
        map("<leader>ca", vim.lsp.buf.code_action,    "Code action")
        map("<leader>rn", vim.lsp.buf.rename,         "Rename symbol")
      end

      -- Servers installed via Homebrew (macOS) or Mason (Linux) — all in PATH
      for _, server in ipairs({ "html", "cssls", "jsonls", "pyright", "ts_ls" }) do
        lspconfig[server].setup({ capabilities = capabilities, on_attach = on_attach })
      end

      -- Biome (installed by Mason as a GitHub binary)
      lspconfig.biome.setup({
        capabilities = capabilities,
        on_attach    = on_attach,
        root_dir     = lspconfig.util.root_pattern("biome.json", "biome.jsonc"),
      })

      -- Lua (brew: lua-language-server)
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach    = on_attach,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
            telemetry   = { enable = false },
          },
        },
      })

      -- Rounded borders
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰠠 ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
        underline        = true,
        update_in_insert = false,
        severity_sort    = true,
        float            = { border = "rounded" },
      })
    end,
  },
}
