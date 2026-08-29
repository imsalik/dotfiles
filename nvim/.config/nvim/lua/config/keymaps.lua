-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Exit insert mode with jj
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Seamless <C-hjkl> nav between nvim splits and herdr panes. Loaded here (not
-- in the plugin spec) so it wins over LazyVim's default <C-w> window maps,
-- which are set on VeryLazy before plugin config runs.
dofile(vim.fn.stdpath("config") .. "/lua/herdr-nav.lua")
