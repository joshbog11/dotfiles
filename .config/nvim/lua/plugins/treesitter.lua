-- Treesitter — syntax highlighting + indentation
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy  = false,
    config = function()
      -- Re-apply highlighting when switching buffers (catches files opened before parsers installed)
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        callback = function(args)
          local buf = args.buf
          if vim.bo[buf].buftype ~= "" then return end
          local ok, _ = pcall(vim.treesitter.start, buf)
          if not ok then return end
        end,
      })
      -- Use system C compiler — no tree-sitter CLI needed
      require("nvim-treesitter.install").compilers = { "cc", "clang", "gcc" }

      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then return end

      configs.setup({
        ensure_installed = {
          "bash", "c", "css", "dockerfile", "gitcommit",
          "go", "html", "javascript", "json", "lua",
          "markdown", "markdown_inline", "python",
          "rust", "toml", "tsx", "typescript", "vim",
          "vimdoc", "yaml",
        },
        auto_install = true,
        highlight = {
          enable = true,
          -- yaml parser has build issues on some machines — falls back to built-in syntax
          disable = { "yaml" },
        },
        indent = { enable = true },
      })
    end,
  },
}
