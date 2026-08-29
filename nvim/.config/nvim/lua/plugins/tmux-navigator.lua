return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    -- Disable the plugin's own <C-hjkl> maps; herdr-nav owns them and falls
    -- back to TmuxNavigate* when outside a herdr pane.
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    -- <C-hjkl> maps live in lua/config/keymaps.lua (herdr-nav), which loads
    -- after LazyVim's defaults so it wins. This spec just provides the
    -- TmuxNavigate* commands herdr-nav falls back to outside herdr.
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
  },
}
