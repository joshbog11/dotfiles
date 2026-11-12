-- Colours come from Tinty (https://github.com/tinted-theming/tinty), the single
-- theme source for the terminal, tmux and Neovim. tinted-nvim watches Tinty's
-- current scheme and re-themes every running Neovim the moment it changes.
--
--   <leader>ut   pick a theme (applies everywhere)      shell: `theme`
--   <leader>ub   toggle a transparent background (remembered between sessions)

local state_file = vim.fn.stdpath("state") .. "/transparent"

local function is_transparent()
  return vim.uv.fs_stat(state_file) ~= nil
end

local function tinted_opts()
  return {
    -- Used when Tinty is not installed or has no scheme applied yet.
    default_scheme = "base16-gruvbox-dark-medium",
    ui = { transparent = is_transparent() },
    selector = { enabled = true, mode = "file", watch = true },
  }
end

local function toggle_transparency()
  if is_transparent() then
    vim.uv.fs_unlink(state_file)
  else
    vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
    vim.fn.writefile({ "1" }, state_file)
  end

  -- setup() re-reads the options and re-applies the current scheme.
  require("tinted-nvim").setup(tinted_opts())
  vim.notify("Transparent background " .. (is_transparent() and "on" or "off"))
end

local function pick_theme()
  if vim.fn.executable("tinty") == 0 then
    vim.notify("tinty is not installed. Run ~/dotfiles/install.sh", vim.log.levels.WARN)
    return
  end
  local result = vim.system({ "tinty", "list" }, { text = true }):wait()
  if result.code ~= 0 then
    vim.notify("tinty list failed. Run `tinty sync` in a shell first.", vim.log.levels.WARN)
    return
  end
  local schemes = vim.split(vim.trim(result.stdout), "\n", { trimempty = true })
  vim.ui.select(schemes, { prompt = "Theme (terminal + tmux + Neovim)" }, function(choice)
    if not choice then
      return
    end
    vim.system({ "tinty", "apply", choice }, { text = true }, function(out)
      vim.schedule(function()
        if out.code == 0 then
          vim.notify("Theme: " .. choice)
        else
          vim.notify("tinty apply failed:\n" .. (out.stderr or ""), vim.log.levels.ERROR)
        end
      end)
    end)
  end)
end

return {
  {
    "tinted-theming/tinted-nvim",
    lazy = false,
    priority = 1000,
    opts = tinted_opts,
    keys = {
      { "<leader>ut", pick_theme, desc = "Pick theme" },
      { "<leader>ub", toggle_transparency, desc = "Toggle transparent background" },
    },
  },
}
