-- Git tooling — lazygit + diffview + gitsigns
return {

  -- ── LazyGit — full git TUI in a floating window ──────────────
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd  = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border_chars = { "╭","─","╮","│","╯","─","╰","│" }
      vim.g.lazygit_use_neovim_remote = 0
    end,
  },

  -- ── Diffview — side-by-side diffs + file history ─────────────
  {
    "sindrets/diffview.nvim",
    lazy = true,
    cmd  = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>",              desc = "Diff working tree" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>",             desc = "Close diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>",     desc = "File history (current)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>",       desc = "File history (repo)" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
        },
      },
      file_panel = {
        listing_style = "tree",
        win_config    = { width = 35 },
      },
    },
  },

  -- ── Gitsigns — gutter indicators + hunk/blame keymaps ────────
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts  = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      current_line_blame = true,  -- always show blame inline
      current_line_blame_opts = {
        virt_text         = true,
        virt_text_pos     = "eol",
        delay             = 500,
        ignore_whitespace = false,
      },
      on_attach = function(bufnr)
        local gs  = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")

        -- Staging
        map("n", "<leader>hs", gs.stage_hunk,    "Stage hunk")
        map("n", "<leader>hS", gs.stage_buffer,  "Stage buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map("v", "<leader>hs",
          function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
          "Stage selected lines")

        -- Reset
        map("n", "<leader>hr", gs.reset_hunk,   "Reset hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")

        -- Inspect
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line (full)")
        map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle inline blame")
        map("n", "<leader>hd", gs.diffthis,     "Diff this")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff against last commit")

        -- Text object — select hunk with ih
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
      end,
    },
  },
}
