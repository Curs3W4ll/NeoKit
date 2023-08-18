---Color utilities module
---@module color
---@alias M

local M = {}

---Convert an hexadecimal color to rgb value
---@param hex string The hexadecimal color as a string
---@return table # A table with three keys, r, g, and b containing numbers
---@raise error if hex is not a string<br/>
---error if hex is not valid (no #, more than 6 values, invalid values)
---@usage
---print(hexToRGB("#32a852")) -- -> { r = 50, g = 168, b = 82 }
function M.hexToRGB(hex)
    if type(hex) ~= "string" then
        error("argument 'hex': must be a string")
    end
    if not require("neokit.str").startWith(hex, "#") then
        error("argument 'hex': must start with a '#'")
    end
    hex = string.gsub(hex, "#", "", 1)
    if string.len(hex) ~= 6 then
        error("argument 'hex': must contains 6 values")
    end
    local validElems = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" }
    local hexAsArray = require("neokit.str").toArray(hex)
    if not require("neokit.array").allOf(hexAsArray, function(e)
        return require("neokit.array").contains(validElems, e)
    end) then
        error("argument 'hex': invalid value")
    end

    return {
        r = tonumber(hex:sub(1, 2), 16),
        g = tonumber(hex:sub(3, 4), 16),
        b = tonumber(hex:sub(5, 6), 16),
    }
end

return M
