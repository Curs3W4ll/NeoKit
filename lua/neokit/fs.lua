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
    if type(path) ~= "string" then
        error("argument 'path': must be a string")
    end

    return vim.fn.isdirectory(path) ~= 0
end

---Check if a file exists
---@param path string The path that contains the file to find
---@param filename string|nil The name of the file to check if it exists.<br/>
---If this argument is nil, the filename should be contained inside path
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
    if type(path) ~= "string" then
        error("argument 'path': must be a string")
    end
    if filename ~= nil and type(filename) ~= "string" then
        error("argument 'filename': must be a string (or nil)")
    end

    if filename == nil then
        if M.directoryExists(path) then
            return false
        end
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
    if type(path) ~= "string" then
        error("argument 'path': must be a string")
    end

    if not M.directoryExists(path) then
        if M.fileExists(path) then
            return false -- Cannot create a directory (is already a file)
        end
        vim.cmd("silent ! mkdir -p " .. path)
    end

    return true
end

---Get a shorter version of a path
---@param path string The path to shorten
---@param opts? table Optional table of parameters to custom the returned value<br/>
---       opts.len: The maximum length of a path component, shortened components will be of size len. Default: 1<br/>
---       opts.tail: The number of tail components to keep unshortened. Default: 1<br/>
---       opts.maxComponents: The maximum number of components to keep. If the path is composed of too many components, the head component will be kept and everything following the head will be replaced by "…" to match the component number. Cannot be under 2. 0 means no limit. Default: 0<br/>
---       opts.relative: If the path should be made relative to the current working directory. Default: true
---@return string # The path shorten as string
---@raise error if path is not a string<br/>
---error if opts is not nil and not a table
---@usage
---local path = "/tmp/adir/bdir/cdir/myfile"
---print(shortenPath()) -- "/t/a/b/c/myfile"
---print(shortenPath(), { len = 3 }) -- "/tmp/adi/bdi/cdi/myfile"
---print(shortenPath(), { tail = 2 }) -- "/t/a/b/cdir/myfile"
---print(shortenPath(), { len = 2, maxComponents = 3 }) -- "/tm/…/cd/myfile"
function M.shortenPath(path, opts)
    local uarray = require("neokit.array")
    local ustr = require("neokit.str")

    if type(path) ~= "string" then
        error("argument 'path': must be a string")
    end
    opts = opts or {}
    if opts ~= nil and type(opts) ~= "table" then
        error("argument 'opts': must be a table")
    end
    opts.len = opts.len or 1
    opts.tail = opts.tail or 1
    opts.maxComponents = opts.maxComponents or 0
    opts.relative = opts.relative or true
    if type(opts.len)  ~= "number" then
        error("argument 'opts.len': must be a number")
    end
    if type(opts.tail)  ~= "number" then
        error("argument 'opts.tail': must be a number")
    end
    if type(opts.maxComponents)  ~= "number" then
        error("argument 'opts.maxComponents': must be a number")
    end
    if type(opts.relative)  ~= "boolean" then
        error("argument 'opts.relative': must be a boolean")
    end

    if opts.len < 1 then
        error("argument 'opts.len': must be positive")
    end
    if opts.tail < 0 then
        error("argument 'opts.len': must 0 or positive")
    end
    if opts.maxComponents ~= 0 and opts.maxComponents < 2 then
        error("argument 'opts.maxComponents': Cannot be under 2 (or 0)")
    end

    if opts.relative then
        path = vim.fn.fnamemodify(path, ':.') or path
    end

    local separator = require("plenary.path").path.sep

    local headingSeparator = false
    if string.len(path) > 0 and ustr.startWith(path, separator) then
        path = path:sub(string.len(separator) + 1)
        headingSeparator = true
    end

    local components = vim.split(path, separator)

    local i = 1
    while i <= #components - opts.tail do
        if string.len(components[i]) > 1 then
            components[i] = string.sub(components[i], 1, opts.len)
        end
        i = i + 1
    end

    if opts.maxComponents ~= 0 and #components > opts.maxComponents then
        components[2] = "…"
        i = 3
        local limit = #components - opts.maxComponents + 1
        while i <= limit do
            table.remove(components, 3)
            i = i + 1
        end
    end

    return (headingSeparator and separator or "") .. uarray.join(components, separator)
end

return M
