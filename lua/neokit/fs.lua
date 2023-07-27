---Filesystem utilities module
---@module fs
---@alias M

local M = {}

---Check if a directory exists
---@param path string The path of the directory to check
---@return boolean # true if path is a directory, false otherwise (non existent or file)
---@raise error if path is not a string
---@usage
---if directoryExists("/tmp/mydir") then
---    print("My dir exists!")
---else
---    print("My dir does not exists :(
---end
function M.directoryExists(path)
    assert(type(path) == "string", "argument 'path': must be a string")

    return not vim.fn.isdirectory(path) == 0
end

---Check if a file exists
---@param path string The path that contains the file to find
---@param filename string|nil The name of the file to check if it exists. If this argument is nil, the filename should be contained inside path
---@return boolean # true if file exists, false otherwise (non existent or directory)
---@raise error if path is not a string<br/>
---error if filename is not nil and not a string
---@usage
---local path = "/tmp/mydir/"
---local filename = "myfile.txt"
---if fileExists(path, filename) then
---    print("My file exists!")
---else
---    print("My file does not exists :(")
---end
--- -- OR
---local filepath = "/tmp/mydir/myfile.txt"
---if fileExists(filepath) then
---    print("My file exists!")
---else
---    print("My file does not exists :(")
---end
function M.fileExists(path, filename)
    assert(type(path) == "string", "argument 'path': must be a string")
    assert(filename == nil or type(filename) == "string", "argument 'filename': must be a string (or nil)")

    if filename == nil then
        local f = io.open(path, "r")
        if f == nil then
            return false
        else
            io.close(f)
            return true
        end
    else
        if not M.directoryExists(path) then
            error("Path not found: '" .. path .. "'")
        end

        return vim.fn.findfile(filename, path) ~= ""
    end
end

---Ensure the given path is a directory
---@param path string The path of the directory to check
---@return boolean # true if the path is a directory, false if something went wrong (e.g. cannot create directory)
---@raise error if path is not a string
---@usage
---local path = "/tmp/mydir"
---if directoryExists(path) then -- No
---    print("Yes")
---end
---if ensureDirectory(path) then -- No
---    print("An error occured while ensuring dir exists")
---end
---if directoryExists(path) then -- Yes
---    print("Yes")
---end
---if ensureDirectory(path) then -- No
---    print("An error occured while ensuring dir exists")
---end
---if directoryExists(path) then -- Yes
---    print("Yes")
---end
function M.ensureDirectory(path)
    assert(type(path) == "string", "argument 'path': must be a string")

    if not M.directoryExists(path) then
        if M.fileExists(path) then
            return false -- Cannot create a directory (is already a file)
        end
        vim.cmd("silent !mkdir " .. path)
    end

    return true
end

return M
