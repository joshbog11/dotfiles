-- One set of keys for moving between Neovim splits and multiplexer panes.
--
-- Ctrl-h/j/k/l first tries to move to a Neovim window. When the cursor is
-- already at the edge, the keypress is handed to whichever multiplexer hosts
-- this Neovim: tmux, or Rex (https://www.superlogical.com/rex).
--
-- The other half of the handshake lives in the multiplexer config:
--   tmux  ~/.config/tmux/tmux.conf  passes the keys through when the pane runs vim
--   Rex   ~/.config/rex/init.lua    passes the keys through when the title starts with "nvim"

local M = {}

local directions = {
  h = { rex = "left", tmux = "L" },
  j = { rex = "down", tmux = "D" },
  k = { rex = "up", tmux = "U" },
  l = { rex = "right", tmux = "R" },
}

-- Rex exports REX_BIN_DIR into every pane, but shell startup files often reset
-- PATH, so prefer the explicit location.
local function rex_bin()
  local dir = vim.env.REX_BIN_DIR
  if dir and vim.fn.executable(dir .. "/rex") == 1 then
    return dir .. "/rex"
  end
  if vim.fn.executable("rex") == 1 then
    return "rex"
  end
end

---@param key "h"|"j"|"k"|"l"
function M.move(key)
  local before = vim.api.nvim_get_current_win()
  vim.cmd.wincmd(key)
  if vim.api.nvim_get_current_win() ~= before then
    return
  end

  local dir = directions[key]

  -- tmux first: a tmux started inside Rex inherits the REX_* variables.
  if vim.env.TMUX then
    -- Do nothing while the pane is zoomed, otherwise tmux would unzoom it.
    vim.system({ "tmux", "if-shell", "-F", "#{?window_zoomed_flag,0,1}", "select-pane -" .. dir.tmux })
  elseif vim.env.REX_BLOCK then
    local rex = rex_bin()
    if rex then
      vim.system({ rex, "focus", dir.rex })
    end
  end
end

function M.setup()
  for key in pairs(directions) do
    vim.keymap.set("n", "<C-" .. key .. ">", function()
      M.move(key)
    end, { desc = "Go to window / pane " .. directions[key].rex, silent = true })
  end
end

return M
