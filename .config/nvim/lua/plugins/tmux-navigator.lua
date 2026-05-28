-- vim-tmux-navigator — seamless pane navigation between nvim and tmux
-- Uses the same C-h/j/k/l bindings as the tmux config
return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<C-h>",  "<cmd>TmuxNavigateLeft<CR>" },
      { "<C-j>",  "<cmd>TmuxNavigateDown<CR>" },
      { "<C-k>",  "<cmd>TmuxNavigateUp<CR>" },
      { "<C-l>",  "<cmd>TmuxNavigateRight<CR>" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>" },
    },
  },
}
