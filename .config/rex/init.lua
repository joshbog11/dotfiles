-- Rex (https://www.superlogical.com/rex) configuration.
--
-- Goal: the same muscle memory as tmux + Neovim.
--   * Ctrl-h/j/k/l moves between Rex panes AND Neovim splits, seamlessly.
--   * Ctrl-Space is a tmux-style prefix for splits, tabs and sessions.
--   * Rex's own Cmd shortcuts are left alone (Cmd-D split, Cmd-T tab, Cmd-K sessions …).
--
-- Apply changes with `rex config reload` (or prefix then r). Validate with
-- `rex config check`; list what is loaded with `rex keymap`.
-- Written against the public docs for Rex Beta 0.1.x. Fonts, theme and window
-- settings are not here: Rex keeps those in the app's own Settings.

local TERMINAL = "com.superlogical.terminal"
local PREFIX = "ctrl+space"

-- ── Seamless navigation with Neovim ──────────────────────────
-- Neovim sets its terminal title to "nvim: <file>" (see nvim/lua/config/options.lua).
-- When the focused pane is Neovim the key is passed through, and Neovim moves
-- between its own splits. At the edge of its layout Neovim calls
-- `rex focus <direction>` itself (see nvim/lua/config/navigate.lua).
local function pane_runs_nvim(ctx)
  local result = rex.block.call(TERMINAL, "title", { block_id = ctx and ctx.block_id or nil })
  local title = result and result.title or ""
  return title:lower():find("^nvim") ~= nil
end

local directions = { h = "left", j = "down", k = "up", l = "right" }

for key, direction in pairs(directions) do
  rex.bind("ctrl+" .. key, function(ctx)
    if pane_runs_nvim(ctx) then
      return false -- not handled: Rex sends the key to the terminal
    end
    rex.session.focus_direction({ direction = direction })
    return true
  end)
end

-- ── Prefix keys (tmux habits) ────────────────────────────────
local function prefix(key, action, args)
  rex.bind(PREFIX .. ">" .. key, action, args)
end

-- Press the prefix twice to send a real Ctrl-Space to the program.
prefix(PREFIX, "pane.send_key", { key = PREFIX })
-- Ctrl-L is taken by navigation above; prefix then Ctrl-L clears the screen.
prefix("ctrl+l", "pane.send_key", { key = "ctrl+l" })

-- Panes
prefix("shift+\\", "pane.split", { direction = "right" }) -- |
prefix("shift+5", "pane.split", { direction = "right" }) -- %
prefix("-", "pane.split", { direction = "down" })
prefix("shift+'", "pane.split", { direction = "down" }) -- "
prefix("x", "pane.close")
prefix("z", "pane.zoom")
prefix("=", "pane.balance")
prefix("f", "pane.float")

for key, direction in pairs(directions) do
  prefix(key, "pane.focus", { direction = direction })
  prefix("shift+" .. key, "pane.resize", { direction = direction, amount = 5 })
end

-- Tabs (tmux "windows")
prefix("c", "client.tab.new")
prefix("n", "client.tab.next")
prefix("p", "client.tab.previous")
prefix(",", "client.tab.rename")
prefix("shift+7", "client.tab.close") -- &
for index = 1, 9 do
  prefix(tostring(index), "client.tab.goto", { index = index })
end

-- Sessions
prefix("s", "session.switch")
prefix("shift+4", "session.rename") -- $
prefix("shift+n", "session.new")

-- Rex itself
prefix("r", "client.config.reload")
prefix("b", "client.sidebar.toggle")
prefix("shift+/", "client.palette.toggle") -- ?

-- ── Custom actions (also in the command palette, and `rex do <name>`) ──
local SHELL = "com.superlogical.terminal.shell"

-- Working directory of the pane the action was started from, so new tabs open
-- in the same project. Returns nil (Rex's default directory) if it is unknown.
local function current_dir(ctx)
  local ok, result = pcall(rex.block.call, TERMINAL, "pwd", { block_id = ctx and ctx.block_id or nil })
  if ok and type(result) == "table" then
    local dir = result.pwd or result.path or result.cwd
    if type(dir) == "string" and dir ~= "" then
      return dir
    end
  end
end

-- Editor on the left, a shell on the right, in a new tab.
rex.action({
  name = "dev_layout",
  title = "Dev Layout: Neovim + Shell",
  category = "Layouts",
  keywords = "nvim neovim editor split",
  run = function(ctx)
    local cwd = current_dir(ctx)
    local _, err = rex.session.new_window({
      layout = rex.layout.horizontal(
        0.65,
        rex.layout.block({ flavor = SHELL, options = { cwd = cwd, initial_input = "nvim\n" } }),
        rex.layout.block({ flavor = SHELL, options = { cwd = cwd } })
      ),
    })
    if err ~= nil then
      rex.log("error", "dev_layout: " .. tostring(err))
    end
  end,
})
prefix("d", "dev_layout")

-- LazyGit in its own tab; the tab closes when LazyGit quits.
rex.action({
  name = "lazygit",
  title = "LazyGit",
  category = "Git",
  keywords = "git commit push",
  run = function(ctx)
    local _, err = rex.session.new_window({
      layout = rex.layout.block({
        flavor = SHELL,
        options = { cwd = current_dir(ctx), initial_input = "lazygit; exit\n" },
      }),
    })
    if err ~= nil then
      rex.log("error", "lazygit: " .. tostring(err))
    end
  end,
})
prefix("g", "lazygit")
