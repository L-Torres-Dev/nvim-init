local popup = require("plenary.popup")

local M = {}

wd_man_wind_id = nil
buffer = nil

-- 1. Save wd list file to root config directory (can only save up to 3)
function M.addWD()
    local wd = vim.fn.getcwd() .. "\\"
    local config_path = vim.fn.stdpath('config')

    local fileName = "wdRepo.txt"
    local filePath = vim.fs.joinpath(config_path, fileName)
    local wdRepo = io.open(filePath, "a")
    print(filePath)
    if wdRepo then
        print('adding new working directory')
        local lines = io.lines(filePath)
        local lines_list = {}

        for line in lines do
            table.insert(lines_list, line)
            print("Adding line to table: " .. line)
        end

        if lines_list ~= nil and #lines_list > 0 then
            print("lines found! Checking to append or replace oldest")
            print("line count: " .. #lines_list)
            
            if #lines_list >= 3 then
                print("too many working directories, replacing oldest") 
                wdRepo:close()
                wdRepo = io.open(filePath, "w")
                
                lines_list[1] = wd

                print("first, replacing oldest working directory:")
                for index, value in ipairs(lines_list) do
                    print(value)
                end
                
                local newContent = table.concat(lines_list, "\n")

                wdRepo:write(newContent)
                wdRepo:close()
            else
                wdRepo:close()
                wdRepo = io.open(filePath, "a")
                print("appending to list...")
                wdRepo:write(wd)
                wdRepo:close()
                print(wd .. " written to: " .. config_path)
            end


        else
                print("Lines not found. Adding first working directory")
                wdRepo:close()
                wdRepo = io.open(filePath, "a")
                wdRepo:write(wd)
                wdRepo:close()
                print(wd .. " written to: " .. config_path)
         
        end

    else
        print('Could not create or find the wd file')
    end
end

local function create_window()
    --log.trace("_create_window()")
    --local config = harpoon.get_menu_config()
    local width = 60
    local height = 10
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local bufnr = vim.api.nvim_create_buf(false, false)

    local wd_man_win_id, win = popup.create(bufnr, {
        title = "WD Manager",
        highlight = "WDManagerWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
    })
    
    vim.api.nvim_set_option_value("buftype", "nofile", {buf = bufnr})
    vim.api.nvim_set_option_value("bufhidden", "wipe", {buf = bufnr})
    vim.api.nvim_set_option_value("swapfile", false, {buf = bufnr})
    vim.api.nvim_set_option_value(
        "winhl",
        "Normal:WDManagerBorder",
        { win = win.border.win_id }
    )

    return {
        bufnr = bufnr,
        win_id = wd_man_win_id,
    }
end

function M.closeWDs()
    print(wd_man_wind_id)
    vim.api.nvim_win_close(wd_man_wind_id, true)
    
    wd_man_wind_id = nil
    buffer = nil
end

function M.openWDs()
    local win_info = create_window()
    content = {}

    wd_man_wind_id = win_info.win_id
    buffer = win_info.bufnr

    local dirs = getDirectories()
    
    vim.api.nvim_buf_set_lines(buffer, 0, 3, false, dirs)
    vim.api.nvim_buf_set_keymap(
        buffer,
        "n",
        "<CR>",
        "<Cmd> lua require('Lentor.wdManager').select_directory()<CR>",
        {}
    )

    vim.api.nvim_buf_set_keymap(
        buffer,
        "n",
        "<ESC>",
        "<Cmd> lua require('Lentor.wdManager').closeWDs()<CR>",
        {}
    )
    vim.api.nvim_buf_set_keymap(
        buffer,
        "n",
        "q",
        "<Cmd> lua require('Lentor.wdManager').closeWDs()<CR>",
        {}
    )
end

function M.select_directory()
    local index = vim.fn.line(".")-1
    local line_text = vim.api.nvim_buf_get_lines(buffer, index, index + 1, false)[1]
    
    M.closeWDs()
    if line_text and line_text ~= "" then
        line_text = line_text:gsub("%s+$", "")

        if line_text:sub(-1) == "\\" then
            line_text = line_text:sub(1, -2)
        end
        
        vim.api.nvim_set_current_dir(line_text)

        vim.cmd("edit " .. line_text)
        
        
    else
        print("Error: Line text was empty.")
    end

end

function M.checkDirectories()
    local wd = vim.fn.getcwd() .. "\\"
    local config_path = vim.fn.stdpath('config')
    local fileName = "wdRepo.txt"
    local filePath = vim.fs.joinpath(config_path, fileName)

    print("working directory: " .. wd)
    print("config path: " .. config_path)

    print("")
    print("Printing working directories")

    local lines = io.lines(filePath)
    local i = 0
    for line in lines do
        print(line)
        i = i + 1  
        if i > 3 then
            break
        end 
    end
end

function getDirectories()
    local wd = vim.fn.getcwd() .. "\\"
    local config_path = vim.fn.stdpath('config')
    local fileName = "wdRepo.txt"
    local filePath = vim.fs.joinpath(config_path, fileName)

    local lines = io.lines(filePath)
    
    local lines_list = {}

    for line in lines do
        table.insert(lines_list, line)
    end
    return lines_list
end

-- 2. Open Window that displays working directorys

vim.api.nvim_create_user_command('Addwd', M.addWD, {})
vim.api.nvim_create_user_command('Openwds', M.openWDs, {})
vim.api.nvim_create_user_command('SelectDir', M.select_directory, {})
vim.api.nvim_create_user_command('CheckPaths', M.checkDirectories, {})
vim.api.nvim_create_user_command('CloseWDs', M.closeWDs, {})
return M
