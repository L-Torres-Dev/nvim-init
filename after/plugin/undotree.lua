local get_os = require("Lentor.getOS")
os = get_os.get_os()
if os == "Windows" then
    vim.g.undotree_DiffCommand = "FC"
    print("Undo Tree: Windows") 
end
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
