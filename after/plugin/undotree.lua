vim.g.undotree_DiffCommand = "FC" -- strictly for windows. Remove if using linux
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
