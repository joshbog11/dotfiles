-- LSP — mason + vim.lsp.config (nvim 0.11+ native API)
--
-- On macOS: all servers installed via Homebrew (install.sh) — no Mason/npm.
-- Mason kept for its UI only.

return {
  { "williamboman/mason.nvim",
    cmd    = "Mason",
    config = function()
      require("mason").setup({ ui = { border = "rounded" } })
    end,
  },

  { "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed    = {},  -- everything via Homebrew on macOS
      automatic_installation = false,
    },
  },

  -- nvim-lspconfig: provides server definitions consumed by vim.lsp.config
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
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

      -- ── Global defaults (applied to every server) ──────────────
      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach    = on_attach,
      })

      -- ── Per-server overrides ────────────────────────────────────
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
            telemetry   = { enable = false },
          },
        },
      })

      vim.lsp.config("biome", {
        root_dir = function(fname)
          return vim.fs.root(fname, { "biome.json", "biome.jsonc" })
        end,
      })

      -- ── Enable servers (all installed via Homebrew) ─────────────
      vim.lsp.enable({
        "html", "cssls", "jsonls",
        "pyright", "ts_ls",
        "lua_ls", "biome",
      })

      -- ── UI polish ───────────────────────────────────────────────
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
