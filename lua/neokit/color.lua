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
    if
        not require("neokit.array").allOf(hexAsArray, function(e)
            return require("neokit.array").contains(validElems, e)
        end)
    then
        error("argument 'hex': invalid value")
    end

    return {
        r = tonumber(hex:sub(1, 2), 16),
        g = tonumber(hex:sub(3, 4), 16),
        b = tonumber(hex:sub(5, 6), 16),
    }
end

---Internal function used to get the luminance of a color
---@param color table The color to get the luminance of. In RGB format
---@return number # The relative luminance of the given color
local function getRelativeLuminance_(color)
    local r, g, b = color.r / 255, color.g / 255, color.b / 255

    local function adjust(c)
        if c <= 0.03928 then
            return c / 12.92
        else
            return ((c + 0.055) / 1.055) ^ 2.4
        end
    end
    r, g, b = adjust(r), adjust(g), adjust(b)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

---Check if a color need to be paired to a high or low contrast color according to its luminance
---@param hex string The hexadecimal color as a string
---@return "dark"|"light" # What the contrast should be
---@raise error if hex is not a string<br/>
---error if hex is not valid (no #, more than 6 values, invalid values)
---@usage
---print(getContrastColor("#000000")) -- black -> 'light' contrast
---print(getContrastColor("#ffffff")) -- white -> 'dark' contrast
function M.getContrastColor(hex)
    local colorAsRGB = M.hexToRGB(hex)
    local colorLuminance = getRelativeLuminance_(colorAsRGB)
    if colorLuminance > 0.179 then
        return "dark"
    else
        return "light"
    end
end

return M
