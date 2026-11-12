-- Format on save with conform.nvim.
--
--   <leader>cf   format now (file or selection)
--   <leader>uf   toggle format on save
--   :ConformInfo shows which formatter ran and why
--
-- JS/TS/JSON/CSS: Biome when the project has a biome.json, otherwise Prettier.
-- A formatter that is not installed is skipped, falling back to the language server.

local function has_biome_config(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr)
  local dir = file ~= "" and vim.fs.dirname(file) or vim.uv.cwd()
  return vim.fs.find({ "biome.json", "biome.jsonc" }, { upward = true, path = dir })[1] ~= nil
end

local function web(bufnr)
  if has_biome_config(bufnr) then
    return { "biome" }
  end
  return { "prettierd", "prettier", stop_after_first = true }
end

local prettier = { "prettierd", "prettier", stop_after_first = true }

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "x" },
        desc = "Format file / selection",
      },
    },
    init = function()
      -- gq uses conform too.
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        javascript = web,
        javascriptreact = web,
        typescript = web,
        typescriptreact = web,
        json = web,
        jsonc = web,
        css = web,
        graphql = web,
        scss = prettier,
        html = prettier,
        vue = prettier,
        svelte = prettier,
        markdown = prettier,
        yaml = prettier,
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        go = { "goimports", "gofmt" },
        rust = { "rustfmt" },
        toml = { "taplo" },
        terraform = { "terraform_fmt" },
      },
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function(bufnr)
        if vim.g.autoformat == false or vim.b[bufnr].autoformat == false then
          return
        end
        return { timeout_ms = 2000, lsp_format = "fallback" }
      end,
      formatters = {
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
      },
    },
  },
}
