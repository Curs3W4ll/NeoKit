---String utilities module
---@module str
---@alias M

local M = {}

---Ensure the last character of a string<br/>
---If the last character of the given string is correct do nothing, otherwise add the character at the end of the string
---@param str string The string to ensure the last character of
---@param char string The string to ensure the last character of
---@return string # A string containing the last character
---@raise error if str is not a string<br/>
---error if char is not a char
---@usage print(ensureLastChar("Hello", "!") -- Hello!
function M.ensureLastChar(str, char)
    if type(str) ~= "string" then error("argument 'str': must be a string") end
    if type(char) ~= "string" then error("argument 'char': must be a string") end

    if string.len(char) > 1 or string.len(char) < 0 then
        error("argument 'char': must be one character long")
    end

    if string.sub(str, -1) ~= char then
        return str .. char
    end
    return str
end

---Check if a pattern is contained in a string
---@param str string The string to search the pattern in
---@param pattern string The pattern to search in the string
---@return boolean # true if str contains at least one time pattern, false otherwise
---@raise error if str is not a string<br/>
---error if pattern is not a string
---@usage
---local str = "This is me Mario!"
---if contains(str, "Mario") then
---    print("The string contains 'Mario' at least one time")
---else
---    print("The string does not contains 'Mario'")
---end
function M.contains(str, pattern)
    if type(str) ~= "string" then error("argument 'str': must be a string") end
    if type(pattern) ~= "string" then error("argument 'pattern': must be a string") end

    if pattern == "" then
        return false
    end

    return vim.fn.match(str, pattern) >= 0
end

return M
