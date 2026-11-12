-- Git inside the editor.
--
--   <leader>gg   LazyGit (full TUI: stage, commit, push, branches). `q` returns to the code.
--   <leader>gd   side-by-side diff of everything changed    <leader>gf  history of this file
--   ]h / [h      next / previous change      <leader>gh…  act on the change under the cursor
-- (LazyGit and the git pickers are defined in snacks.lua.)

local function toggle_diffview()
  if require("diffview.lib").get_current_view() then
    vim.cmd("DiffviewClose")
  else
    vim.cmd("DiffviewOpen")
  end
end

return {
  -- Change markers in the gutter, inline blame, stage / reset individual hunks.
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 400, virt_text_pos = "eol" },
      current_line_blame_formatter = "<author>, <author_time:%R> · <summary>",
      on_attach = function(buf)
        local gs = require("gitsigns")

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end

        -- Jump between changes (falls back to the built-in keys in diff mode).
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next change")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Previous change")

        map("n", "<leader>ghs", gs.stage_hunk, "Stage / unstage change")
        map("n", "<leader>ghr", gs.reset_hunk, "Discard change")
        map("x", "<leader>ghs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage selection")
        map("x", "<leader>ghr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Discard selection")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage whole file")
        map("n", "<leader>ghR", gs.reset_buffer, "Discard all changes in file")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview change")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line (full)")
        map("n", "<leader>ghB", gs.blame, "Blame whole file")
        map("n", "<leader>ghd", gs.diffthis, "Diff file against index")
        map("n", "<leader>ug", gs.toggle_current_line_blame, "Toggle inline blame")

        -- Text object: `vih` selects the change, `dih` deletes it.
        map({ "o", "x" }, "ih", gs.select_hunk, "Change (hunk)")
      end,
    },
  },

  -- Review changes and history in a dedicated tab.
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    opts = {
      enhanced_diff_hl = true,
      view = { merge_tool = { layout = "diff3_mixed" } },
    },
    keys = {
      { "<leader>gd", toggle_diffview, desc = "Diff view (toggle)" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "History of this file" },
      { "<leader>gF", "<cmd>DiffviewFileHistory<cr>", desc = "History of the repository" },
      { "<leader>gf", ":DiffviewFileHistory<cr>", mode = "x", desc = "History of selected lines" },
    },
  },
}
