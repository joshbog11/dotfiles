-- Treesitter — syntax highlighting + indentation
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy  = false,
    config = function()
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
          "vimdoc",
        },
        auto_install = true,
        highlight = {
          enable  = true,
          -- yaml and xml parsers fail to build without tree-sitter CLI
          -- nvim's built-in syntax highlighter handles these fine
          disable = { "yaml", "xml" },
        },
        indent = { enable = true },
      })
    end,
  },
}
