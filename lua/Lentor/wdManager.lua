local popup = require("plenary.popup")
-- 1. Save wd list file to root config directory (can only save up to 3)
function addWD()
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

    local Harpoon_win_id, win = popup.create(bufnr, {
        title = "WD Manager",
        highlight = "HarpoonWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
    })

    return {
        bufnr = bufnr,
        win_id = wd_man_win_id,
    }
end

function openWDs()

    local win_info = create_window()
    print(win_info)

end

function checkDirectories()
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

-- 2. Open Window that displays working directorys

vim.api.nvim_create_user_command('Addwd', addWD, {})
vim.api.nvim_create_user_command('Openwds', openWDs, {})
vim.api.nvim_create_user_command('CheckPaths', checkDirectories, {})
