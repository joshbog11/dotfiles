-- Tree-sitter: accurate syntax highlighting, indentation and folding.
--
-- This uses the rewritten nvim-treesitter (`main` branch). It needs the
-- `tree-sitter` CLI and a C compiler to build parsers; install.sh provides
-- both (brew install tree-sitter-cli). Without the CLI Neovim falls back to
-- its classic regex highlighting, so files are never left uncoloured.
--
--   :TSInstall <lang>   :TSUpdate   :checkhealth nvim-treesitter

local ensure_installed = {
  "bash", "c", "css", "diff", "dockerfile", "git_config", "git_rebase", "gitcommit",
  "gitignore", "go", "gomod", "graphql", "hcl", "helm", "html", "javascript", "jsdoc",
  "json", "json5", "lua", "luadoc", "make", "markdown", "markdown_inline", "python",
  "query", "regex", "rust", "scss", "sql", "terraform", "toml", "tsx", "typescript",
  "vim", "vimdoc", "xml", "yaml",
}

-- Filetypes where Tree-sitter indentation is worse than the built-in one.
local no_ts_indent = { python = true, yaml = true, markdown = true }

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- this plugin does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      local has_cli = vim.fn.executable("tree-sitter") == 1

      -- Run `fn` once an install task has finished.
      local function after(task, fn)
        if type(task) == "table" and type(task.await) == "function" then
          return pcall(task.await, task, function()
            vim.schedule(fn)
          end)
        end
        return false
      end

      -- First launch on a machine: build every parser in the list (async).
      local bootstrap
      if has_cli then
        bootstrap = ts.install(ensure_installed) -- no-op for parsers already installed
        after(bootstrap, function()
          bootstrap = nil
        end)
      else
        vim.schedule(function()
          vim.notify(
            "tree-sitter CLI not found: using basic highlighting.\nInstall it with: brew install tree-sitter-cli",
            vim.log.levels.WARN
          )
        end)
      end

      local available = {}
      local ok, list = pcall(ts.get_available)
      if ok and type(list) == "table" then
        for _, lang in ipairs(list) do
          available[lang] = true
        end
      end

      local function start(buf, lang)
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        if not pcall(vim.treesitter.start, buf, lang) then
          return
        end
        if not no_ts_indent[vim.bo[buf].filetype] then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("dotfiles_treesitter", { clear = true }),
        callback = function(event)
          local buf = event.buf
          local lang = vim.treesitter.language.get_lang(event.match) or event.match

          -- Parser already on disk: highlight immediately.
          local loaded = select(2, pcall(vim.treesitter.language.add, lang))
          if loaded == true then
            start(buf, lang)
            return
          end

          -- Known language without a parser yet: build it, then highlight.
          if has_cli and available[lang] then
            local task = bootstrap and vim.tbl_contains(ensure_installed, lang) and bootstrap or ts.install({ lang })
            after(task, function()
              start(buf, lang)
            end)
          end
        end,
      })
    end,
  },

  -- Keeps the current function / class header pinned at the top while scrolling.
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = { max_lines = 3, multiline_threshold = 1 },
    keys = {
      { "<leader>uc", "<cmd>TSContext toggle<cr>", desc = "Toggle sticky context" },
    },
  },

  -- Auto-close and auto-rename HTML / JSX tags.
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
