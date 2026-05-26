local M = {}
function M.startUnity()
    local wd = vim.fn.getcwd() .. "\\"
    local projectDir = vim.fs.joinpath(wd, "..\\") 
    local versionFilePath = vim.fs.joinpath(projectDir, "ProjectSettings\\ProjectVersion.txt")  
    versionFilePath = vim.fs.normalize(versionFilePath)
    print(versionFilePath)

    if vim.uv.fs_stat(versionFilePath) == nil then 
        print("Error, this is not a Unity project")

        return nil
    end

    local regex = "^([^:]+):%s*(.+)$"

    local versionFile = io.open(versionFilePath)
    local versionContent = versionFile:read("l")

    local vKey, version = versionContent:match(regex)
    version = version:gsub("%s+$", "")

    local config_path = vim.fn.stdpath('config')

    local fileName = "unity.txt"
    local filePath = vim.fs.joinpath(config_path, fileName)
    local unityFile = io.open(filePath, "r") 

    local rawContent = unityFile:read("*all")
    print(rawContent)
    local key, unityPath = rawContent:match(regex)
    unityPath = unityPath:gsub("%s+$", "")

    print("Unity Path: " .. unityPath)
    print("Unity Version: " .. version)
    local toEXE = version .. "\\Editor\\Unity.exe"
    local unityEXE = vim.fs.joinpath(unityPath, toEXE )

    print("Unity exe: " .. unityEXE)
    projectDir = vim.fs.normalize(vim.fs.joinpath(wd, "..\\"))
    print("Project Dir: " .. projectDir)
    local cmd = string.format('"%s" -projectPath "%s"', unityEXE, projectDir)
    local cmdT = {unityEXE,"-projectPath",  projectDir}
    print("cmd: " .. cmd)

    versionFile:close()
    unityFile:close()
    vim.system(cmdT, {detach = true})
end
vim.api.nvim_create_user_command("Unity", M.startUnity, {})
return M
