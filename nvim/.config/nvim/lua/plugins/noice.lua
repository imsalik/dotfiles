return {
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline", -- Use classic cmdline at bottom instead of floating
      },
      messages = {
        enabled = true,
        view = "notify", -- Keep notifications as popups
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext", -- Show search count in virtualtext
      },
    },
  },
}
