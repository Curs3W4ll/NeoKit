local M = {}

---Ensure the last character of a string
---If the given string already contains the given character, do nothing, otherwise, add the character at the end of the string
---@param str string The string to ensure the last character of
---@param char string The string to ensure the last character of
---@return string # A string containing the last character
function M.ensureLastChar(str, char)
    assert(type(str) == "string", "argument 'str': must be a string")
    assert(type(char) == "string", "argument 'char': must be a string")

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
function M.contains(str, pattern)
    assert(type(str) == "string", "argument 'str': must be a string")
    assert(type(pattern) == "string", "argument 'pattern': must be a string")

    return vim.fn.match(str, pattern) >= 0
end

return M
