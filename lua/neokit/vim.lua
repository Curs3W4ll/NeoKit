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

return M
