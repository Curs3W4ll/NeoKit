---Neovim utilities module
---@module vim
---@alias M

local M = {}

local uarray = require("neokit.array")

---Map a keybind for the Neovim instance
---@param mode string The mode the key bind will created for
---@param key string The key combination that will trigger the binding
---@param action string|function The action that will take place when the binding is being triggered
---@param opts? table Additional options passed to nvim_set_keymap function<br/>
---       opts.noremap: non-recursive mapping
---       opts.desc: human-readable description
---       opts.replace_keycodes: replace keycodes in the resulting string
---       opts.nowait: Do not wait if another key bing use the same start of key
---       opts.silent: Do not produce any message
---       opts.script: Remap only mappings starting with <SID>
---       opts.expr: Treat the keybind as an expression
---       opts.unique: Do not erase the previous mapping if any before it
---@raise error if mode is not a string<br/>
---error if mode does not have a valid value<br/>
---error if key is not a string<br/>
---error if action is not a string<br/>
---error if opts is given and is not a table
---@usage
---map("i", "jk", "<ESC>", { nowait = true })
function M.map(mode, key, action, opts)
    if opts == nil then
        opts = {}
    end
    if type(mode) ~= "string" then
        error("argument 'mode': must be a string")
    end
    local validModes = { "n", "i", "c", "v", "x", "!", "" }
    if not uarray.contains(validModes, mode) then
        error("argument 'mode': invalid, must be one of: " .. uarray.join(validModes, ", "))
    end
    if type(key) ~= "string" then
        error("argument 'key': must be a string")
    end
    if type(action) ~= "string" and type(action) ~= "function" then
        error("argument 'action': must be a string or a function")
    end
    if type(opts) ~= "table" then
        error("argument 'opts': must be a table")
    end

    if type(action) == "function" then
        opts.callback = action
        vim.api.nvim_set_keymap(mode, key, "", opts)
    else
        vim.api.nvim_set_keymap(mode, key, action, opts)
    end
end

---Check if a keybind exist for the Neovim instance
---@param mode string The mode the key bind should be set for
---@param key string The key combination the key bind should be triggered by
---@return boolean # true if a keybind exists for the given mode and key, false otherwise
---@raise error if mode is not a string<br/>
---error if mode does not have a valid value<br/>
---error if key is not a string
---@usage
---map("i", "jk", "<ESC>")
---mapExists("i", "jk") -- true
---mapExists("i", "notset") -- false
function M.mapExists(mode, key)
    if type(mode) ~= "string" then
        error("argument 'mode': must be a string")
    end
    local validModes = { "n", "i", "c", "v", "x", "!", "" }
    if not uarray.contains(validModes, mode) then
        error("argument 'mode': invalid, must be one of: " .. uarray.join(validModes, ", "))
    end
    if type(key) ~= "string" then
        error("argument 'key': must be a string")
    end

    local keymaps = vim.api.nvim_get_keymap(mode)

    for _,t in ipairs(keymaps) do
        if t["lhs"] == key then
            return true
        end
    end

    return false
end

---Get a keybind details for the Neovim instance
---@param mode string The mode to get the keybind in
---@param key string The key combination defining the keybind to get
---@return table|nil # A valid table contains details about the keybind if the keybind exists, nil otherwise
---@raise error if mode is not a string<br/>
---error if mode does not have a valid value<br/>
---error if key is not a string
---@usage
---map("i", "jk", "<ESC>", { nowait = true })
---print(getMap("i", "jk")) -- { mode = "i", lhs = "jk", rhs = "<Esc>", nowait = true, ... }
function M.getMap(mode, key)
    if type(mode) ~= "string" then
        error("argument 'mode': must be a string")
    end
    local validModes = { "n", "i", "c", "v", "x", "!", "" }
    if not uarray.contains(validModes, mode) then
        error("argument 'mode': invalid, must be one of: " .. uarray.join(validModes, ", "))
    end
    if type(key) ~= "string" then
        error("argument 'key': must be a string")
    end

    local keymaps = vim.api.nvim_get_keymap(mode)

    for _,t in ipairs(keymaps) do
        if t["lhs"] == key then
            return t
        end
    end

    return nil
end

---Unmap a keybind for the Neovim instance
---@param mode string The mode the key bind will deleted for
---@param key string The key combination that will be deleted
---@return boolean # true if a keybind have been deleted, false if the keybind does not exist
---@raise error if mode is not a string<br/>
---error if mode does not have a valid value<br/>
---error if key is not a string
---@usage
---map("i", "jk", "<ESC>", { nowait = true })
---unmap("i", "jk") -- true
---unmap("i", "notexist") -- false
function M.unmap(mode, key)
    if type(mode) ~= "string" then
        error("argument 'mode': must be a string")
    end
    local validModes = { "n", "i", "c", "v", "x", "!", "" }
    if not uarray.contains(validModes, mode) then
        error("argument 'mode': invalid, must be one of: " .. uarray.join(validModes, ", "))
    end
    if type(key) ~= "string" then
        error("argument 'key': must be a string")
    end

    if not M.mapExists(mode, key) then
        return false
    end

    vim.api.nvim_del_keymap(mode, key)

    return true
end

---Get the value of an option for the Neovim instance
---@param option string The option name to get the value of
---@return any # Option information
---@raise error if option is not a string<br/>
---error if option is not a valid option
---@usage
function M.getOption(option)
    if type(option) ~= "string" then
        error("argument 'option': must be a string")
    end
    local options = vim.api.nvim_get_all_options_info()
    if not options[option] then
        error("argument 'option'(" .. option .. "): not a valid option")
    end

    return vim.api.nvim_get_option_value(option, {})
end

return M
