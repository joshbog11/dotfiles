-- LSP — mason + lspconfig
return {
  -- Mason: install LSP servers, linters, formatters
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup({ ui = { border = "rounded" } })
    end,
  },

  -- Bridge mason ↔ lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",    -- TypeScript / JavaScript
        "cssls",
        "jsonls",
        "pyright",
        "biome",    -- linter + formatter (replaces eslint)
        -- "html", -- removed: npm-based, hits Nexus. Install manually if needed:
        --         -- :MasonInstall html-lsp
      },
      automatic_installation = false, -- don't silently install on every open
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
        -- <leader>cf is handled by conform.nvim (format on save)
      end

      -- Simple servers
      for _, server in ipairs({ "cssls", "jsonls", "pyright" }) do
        lspconfig[server].setup({ capabilities = capabilities, on_attach = on_attach })
      end

      -- TypeScript
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach    = on_attach,
      })

      -- Biome (lint + format — used alongside conform.nvim)
      lspconfig.biome.setup({
        capabilities = capabilities,
        on_attach    = on_attach,
      })

      -- Lua
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

      -- Diagnostic config
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
