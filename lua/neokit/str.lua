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
    if type(str) ~= "string" then
        error("argument 'str': must be a string")
    end
    if type(char) ~= "string" then
        error("argument 'char': must be a string")
    end

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
    if type(str) ~= "string" then
        error("argument 'str': must be a string")
    end
    if type(pattern) ~= "string" then
        error("argument 'pattern': must be a string")
    end

    if pattern == "" then
        return false
    end

    return vim.fn.match(str, pattern) >= 0
end

---Check if a string starts with a specified string
---@param str string The string to search the pattern in
---@param pattern string The pattern to search at the start of the string
---@return boolean # true if str starts with pattern, false otherwise
---@raise error if str is not a string<br/>
---error if pattern is not a string
---@usage
---local str = "This is me Mario!"
---if startWith(str, "This") then
---    print("The string starts with 'This'")
---else
---    print("The string does not starts with 'This'")
---end
function M.startWith(str, pattern)
    if type(str) ~= "string" then
        error("argument 'str': must be a string")
    end
    if type(pattern) ~= "string" then
        error("argument 'pattern': must be a string")
    end

    return string.sub(str, 1, string.len(pattern)) == pattern
end

---Convert a string to an array with an element for each character of the string
---@param str string The string to convert into an array
---@return table # The string as an array of letters
---@raise error if str is not a string
---@usage
---local str = "Hello"
---local strAsArr = toArray(str) -- { "H", "e", "l", "l", "o" }
function M.toArray(str)
    if type(str) ~= "string" then
        error("argument 'str': must be a string")
    end

    local result = {}

    ---@diagnostic disable-next-line discard-returns
    string.gsub(str, ".", function(c)
        table.insert(result, c)
    end)

    return result
end

---Count the number of occurrences of a character in a string
---@param str string The string to search in
---@param str2 string The string to search in str
---@return number # The number of times str2 occurs in str
---@raise error if str is not a string<br/>
---error if str2 is not a string<br/>
---error if str2 is empty
---@usage
---local str = "Hello"
---local nbr = count(str, "l") -- 2
function M.count(str, str2)
    if type(str) ~= "string" then
        error("argument 'str': must be a string")
    end
    if type(str2) ~= "string" then
        error("argument 'str2': must be a string")
    end
    if string.len(str2) < 1 then
        error("argument 'str2': must be at least 1 char long")
    end

    local count = 0
    for _ in str:gmatch(str2) do
        count = count + 1
    end

    return count
end

return M
