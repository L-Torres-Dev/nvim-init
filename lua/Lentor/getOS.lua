local M = {}
function M.get_os()
    if os.getenv("WINDIR") or os.getenv("COMSPEC") then
        return "Windows"
    end
    return "Unix/Linux/macOS"
end

return M
