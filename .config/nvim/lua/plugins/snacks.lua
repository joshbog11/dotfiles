-- snacks.nvim: one well-maintained plugin for the fuzzy finder, file explorer,
-- dashboard, notifications, LazyGit window, indent guides and UI toggles.

-- Focus the explorer if it is already open instead of closing it.
local function explorer_focus()
  local open = Snacks.picker.get({ source = "explorer" })[1]
  if open then
    open:focus("list")
  else
    Snacks.explorer()
  end
end

local function explorer_close()
  local open = Snacks.picker.get({ source = "explorer" })[1]
  if open then
    open:close()
  end
end

return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 900,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true, replace_netrw = true },
      indent = { enabled = true, animate = { enabled = false } },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      lazygit = { configure = true }, -- LazyGit follows the Neovim colours
      picker = {
        enabled = true,
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          explorer = { hidden = true },
        },
        win = {
          input = {
            keys = {
              -- One <Esc> closes the picker (no normal-mode detour).
              ["<Esc>"] = { "close", mode = { "n", "i" } },
            },
          },
        },
      },
    },
    keys = {
      -- ── The four you will use constantly ──
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Find file (smart)" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Search in project" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Open files" },
      { "<leader>e", explorer_focus, desc = "File explorer (open / focus)" },
      { "<leader>E", explorer_close, desc = "File explorer (close)" },

      -- ── Find ──
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep (search text)" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Open files" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Neovim config files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fR", function() Snacks.rename.rename_file() end, desc = "Rename current file" },

      -- ── Search ──
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Word under cursor / selection", mode = { "n", "x" } },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Lines in this file" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help pages" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics (project)" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics (this file)" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "Symbols in this file" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Symbols in project" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jump list" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo history" },
      { "<leader>sn", function() Snacks.picker.notifications() end, desc = "Notification history" },
      { "<leader>s.", function() Snacks.picker.resume() end, desc = "Resume last picker" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command history" },

      -- ── Git ──
      { "<leader>gg", function() Snacks.lazygit() end, desc = "LazyGit" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "LazyGit log" },
      { "<leader>gL", function() Snacks.lazygit.log_file() end, desc = "LazyGit log (this file)" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Changed files" },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Branches" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser", mode = { "n", "x" } },

      -- ── Buffers ──
      { "<leader>x", function() Snacks.bufdelete() end, desc = "Close file" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Close file" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Close other files" },

      -- ── Terminal, zen, references ──
      { "<C-/>", function() Snacks.terminal() end, desc = "Toggle terminal", mode = { "n", "t" } },
      { "<C-_>", function() Snacks.terminal() end, desc = "which_key_ignore", mode = { "n", "t" } },
      { "<leader>uz", function() Snacks.zen() end, desc = "Zen mode" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous reference", mode = { "n", "t" } },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- UI toggles. which-key shows the current state of each one.
          Snacks.toggle.option("spell", { name = "spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "line wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "relative numbers" }):map("<leader>uL")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ui")
          Snacks.toggle.dim():map("<leader>uD")
          Snacks.toggle
            .new({
              id = "autoformat",
              name = "format on save",
              get = function()
                return vim.g.autoformat ~= false
              end,
              set = function(state)
                vim.g.autoformat = state
              end,
            })
            :map("<leader>uf")
        end,
      })
    end,
  },
}
