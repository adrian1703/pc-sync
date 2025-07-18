-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- vim.api.nvim_set_keymap("i", "k(", "<Esc>", { noremap = false })
vim.api.nvim_set_keymap("n", ";", ":", { noremap = false })
vim.api.nvim_set_keymap("n", "XX", ":qa<Enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "SS", ":wa<Enter>", { noremap = false })

vim.api.nvim_set_keymap("t", "<C-Space>", [[<C-\><C-n>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>t", ":split | terminal<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>T", ":vsplit | terminal<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "tk", ":blast<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "tj", ":bfirst<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "td", ":bdelete<enter>", { noremap = false })
