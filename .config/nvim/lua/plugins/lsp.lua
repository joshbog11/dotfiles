-- Language servers, using Neovim's native LSP client (vim.lsp.config / vim.lsp.enable).
--
-- How servers get onto a machine:
--   * macOS / Linuxbrew: ./install.sh installs them with Homebrew. No npm
--     involved, so this works behind a corporate registry such as Nexus.
--   * Anywhere else: open :Mason and install what you need.
-- A server is enabled only when its executable exists, so a missing tool never
-- produces an error. Run :checkhealth vim.lsp to see what is attached.

-- server name (nvim-lspconfig) → executable that must be on PATH
local servers = {
  -- Web
  { "vtsls", "vtsls" }, -- TypeScript / JavaScript (same engine as VS Code)
  { "ts_ls", "typescript-language-server", unless = "vtsls" },
  { "eslint", "vscode-eslint-language-server" },
  { "biome", "biome" },
  { "html", "vscode-html-language-server" },
  { "cssls", "vscode-css-language-server" },
  { "tailwindcss", "tailwindcss-language-server" },
  { "jsonls", "vscode-json-language-server" },
  -- Config and infrastructure
  { "yamlls", "yaml-language-server" },
  { "helm_ls", "helm_ls" },
  { "dockerls", "docker-langserver" },
  { "terraformls", "terraform-ls" },
  { "taplo", "taplo" },
  { "bashls", "bash-language-server" },
  -- Languages
  { "lua_ls", "lua-language-server" },
  { "basedpyright", "basedpyright-langserver" },
  { "pyright", "pyright-langserver", unless = "basedpyright" },
  { "ruff", "ruff" },
  { "gopls", "gopls" },
  { "rust_analyzer", "rust-analyzer" },
  { "clangd", "clangd" },
  { "marksman", "marksman" },
}

local function configure_servers()
  local has_schemastore, schemastore = pcall(require, "schemastore")

  local inlay_hints = {
    parameterNames = { enabled = "literals" },
    parameterTypes = { enabled = true },
    variableTypes = { enabled = false },
    propertyDeclarationTypes = { enabled = true },
    functionLikeReturnTypes = { enabled = true },
    enumMemberValues = { enabled = true },
  }

  vim.lsp.config("vtsls", {
    settings = {
      complete_function_calls = true,
      vtsls = {
        autoUseWorkspaceTsdk = true, -- use the project's own TypeScript version
        enableMoveToFileCodeAction = true,
        experimental = { completion = { enableServerSideFuzzyMatch = true }, maxInlayHintLength = 30 },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = { completeFunctionCalls = true },
        preferences = { importModuleSpecifier = "shortest" },
        inlayHints = inlay_hints,
      },
      javascript = {
        updateImportsOnFileMove = { enabled = "always" },
        inlayHints = inlay_hints,
      },
    },
  })

  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        completion = { callSnippet = "Replace" },
        hint = { enable = true, arrayIndex = "Disable" },
        telemetry = { enable = false },
      },
    },
  })

  vim.lsp.config("jsonls", {
    settings = {
      json = {
        schemas = has_schemastore and schemastore.json.schemas() or nil,
        validate = { enable = true },
      },
    },
  })

  vim.lsp.config("yamlls", {
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        keyOrdering = false,
        format = { enable = true },
        validate = true,
        -- Use SchemaStore.nvim's catalogue instead of the server's built-in one.
        schemaStore = { enable = false, url = "" },
        schemas = has_schemastore and schemastore.yaml.schemas() or nil,
      },
    },
  })

  vim.lsp.config("basedpyright", {
    settings = {
      basedpyright = { analysis = { typeCheckingMode = "standard" } },
    },
  })

  vim.lsp.config("gopls", {
    settings = {
      gopls = {
        gofumpt = true,
        staticcheck = true,
        usePlaceholders = true,
        hints = { parameterNames = true, compositeLiteralFields = true, constantValues = true },
      },
    },
  })
end

local function enable_servers()
  local enabled = {}
  for _, server in ipairs(servers) do
    local name, bin = server[1], server[2]
    if vim.fn.executable(bin) == 1 and not (server.unless and enabled[server.unless]) then
      enabled[name] = true
      vim.lsp.enable(name)
    end
  end
end

-- Keymaps that only make sense once a server is attached to the buffer.
local function on_attach(event)
  local buf = event.buf
  local client = vim.lsp.get_client_by_id(event.data.client_id)

  local function map(lhs, rhs, desc, mode)
    vim.keymap.set(mode or "n", lhs, rhs, { buffer = buf, desc = desc })
  end

  -- Navigation (pickers with a preview when there is more than one result)
  map("gd", function() Snacks.picker.lsp_definitions() end, "Go to definition")
  map("gD", function() Snacks.picker.lsp_declarations() end, "Go to declaration")
  map("gr", function() Snacks.picker.lsp_references() end, "References")
  map("gI", function() Snacks.picker.lsp_implementations() end, "Go to implementation")
  map("gy", function() Snacks.picker.lsp_type_definitions() end, "Go to type definition")

  -- K (hover) is a Neovim default. Signature help: <C-k> in insert mode.
  map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
  map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
  map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  map("<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP status")
  map("<leader>cR", function() Snacks.rename.rename_file() end, "Rename file (updates imports)")

  if client and client:supports_method("textDocument/codeAction") then
    map("<leader>co", function()
      vim.lsp.buf.code_action({ apply = true, context = { only = { "source.organizeImports" }, diagnostics = {} } })
    end, "Organise imports")
    map("<leader>cA", function()
      vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
    end, "Source actions (whole file)")
  end

  -- Let Ruff own formatting and linting; basedpyright owns hover.
  if client and client.name == "ruff" then
    client.server_capabilities.hoverProvider = false
  end
end

return {
  -- Server definitions (commands, filetypes, root markers). No setup() calls:
  -- Neovim 0.11+ reads them through vim.lsp.config.
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "b0o/SchemaStore.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      vim.diagnostic.config({
        severity_sort = true,
        update_in_insert = false,
        underline = true,
        virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
        float = { source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.INFO] = "●",
            [vim.diagnostic.severity.HINT] = "○",
          },
        },
      })

      -- Completion capabilities for every server.
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("dotfiles_lsp_attach", { clear = true }),
        callback = on_attach,
      })

      configure_servers()
      enable_servers()
    end,
  },

  -- Optional installer UI for machines without Homebrew. Nothing is installed
  -- automatically; anything you install here is picked up on the next start.
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = { ui = { border = "rounded" } },
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason (install tools)" } },
  },

  -- JSON / YAML schemas: package.json, tsconfig, GitHub workflows, Helm, OpenAPI, …
  { "b0o/SchemaStore.nvim", lazy = true, version = false },
}
