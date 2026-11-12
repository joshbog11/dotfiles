-- Neovim entry point. Everything else lives in lua/config and lua/plugins.
--
--   lua/config/options.lua    editor options (no plugins needed)
--   lua/config/lazy.lua       plugin manager bootstrap
--   lua/config/keymaps.lua    global keymaps (plugin keymaps live with the plugin)
--   lua/config/autocmds.lua   small quality-of-life automations
--   lua/config/navigate.lua   Ctrl-h/j/k/l across Neovim splits, tmux and Rex
--   lua/plugins/*.lua         one file per concern

if vim.fn.has("nvim-0.12") == 0 then
  vim.api.nvim_echo({
    { "This config needs Neovim 0.12 or newer.\n", "ErrorMsg" },
    { "Upgrade with: brew upgrade neovim\n", "WarningMsg" },
  }, true, {})
  return
end

vim.loader.enable()

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
