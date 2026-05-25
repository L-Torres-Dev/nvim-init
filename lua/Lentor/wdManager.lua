-- 1. Save wd list file to root config directory (can only save up to 3)
function addWD()
    local wd = vim.fn.getcwd() .. "\\"
    local config_path = vim.fn.stdpath('config')

    local fileName = "wdRepo.txt"
    local filePath = vim.fs.joinpath(wd, fileName)
    local wdRepo = io.open(filePath, "w")
    print(filePath)
    if wdRepo then
        print('adding new working directory')

        local lines = io.lines(filePath)
       
        local lines_list = {}
        for line in lines do
            table.insert(lines_list, line)
        end

        if lines_list ~= nil then
            print("lines found! Checking to append or replace oldest")
            print("line count: " .. #lines_list)
            
            if #lines_list >= 3 then
                print("too many working directories, replacing oldest") 
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
                wdRepo.close()
                wdRepo = io.open(filePath, "a")
                wdRepo:write(wd)
                wdRepo:close()
                print(wd .. " written to: " .. config_path)
         
        end

    else
        print('Could not create or find the wd file')
    end
end

-- 2. Open Window that displays working directorys

vim.api.nvim_create_user_command('Addwd', addWD, {})
