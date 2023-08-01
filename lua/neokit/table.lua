---Tables utilities module
---@module table
---@alias M

local M = {}

---Concat tbl2 into tbl1<br/>
---Values from tbl1 will be taken over values from tbl2 unless 'force' argument is set to true
---@param tbl1 table The first table to concat the second into
---@param tbl2 table The second table to concat into the first
---@param force? boolean If tbl2 values should be taking over values from tbl1
---@return table # A new table with tbl2 concat into tbl1
---@raise error if tbl1 is not a table<br/>
---error if tbl2 is not a table<br/>
---error if force is not a boolean
---@usage
---local tbl1 = { one = 1, three = 3 }
---local tbl2 = { two = 2, 4 = "four" }
---local tbl3 = concat(tbl1, tbl2)
--- -- tbl3 -> { one = 1, three = 3, two = 2, 4 = "four" }
function M.concat(tbl1, tbl2, force)
    if force == nil then
        force = false
    end
    if type(tbl1) ~= "table" then
        error("argument 'tbl1': must be a table")
    end
    if type(tbl2) ~= "table" then
        error("argument 'tbl2': must be a table")
    end
    if type(force) ~= "boolean" then
        error("argument 'force': must be a boolean")
    end

    local concat = {}

    for k, v in pairs(tbl1) do
        concat[k] = v
    end
    for k, v in pairs(tbl2) do
        -- Append only if force is set to true or if the key is not in the table
        if force or concat[k] == nil then
            concat[k] = v
        end
    end

    return concat
end

---Check if a table contains a key<br/>
---If the key is associated to a nil value, it will be considered as not here
---@param tbl table The table to search the key in
---@param key any The key to search in the table. This cannot be nil
---@return boolean # true if tbl contains the key key
---@raise error if tbl is not a table<br/>
---error if key is nil
---@usage
---local tbl = { 1 = "one", "two" = 2 }
---if not contains(tbl, "two") then
---    print("Table has no entry 'two'")
---else
---    print("Table has an entry 'two'")
---end
function M.contains(tbl, key)
    if type(tbl) ~= "table" then
        error("argument 'tbl': must be a table")
    end
    if key == nil then
        error("argument 'key': cannot be nil")
    end

    return tbl[key] ~= nil
end

---Finds a key that is associated to the given value<br/>
---The first founded key with the value will be returned
---@param tbl table The table to search the value in
---@param value any The value to search in the table. This cannot be nil
---@return any|nil # The first key found with the given value if any, nil otherwise
---@raise error if tbl is not a table<br/>
---error if value is nil
---@usage
---local tbl = { 1 = "one", 2 = "two" }
---print(find(tbl, "two")) -- 2
function M.find(tbl, value)
    if type(tbl) ~= "table" then
        error("argument 'tbl': must be a table")
    end
    if value == nil then
        error("argument 'value': cannot be nil")
    end

    for k, v in pairs(tbl) do
        if v == value then
            return k
        end
    end

    return nil
end

---Internal function use to recursively copy a table
---@param obj any The object to copy
---@return any # A deep copy of obj
local function copy_(obj)
    if not obj or type(obj) ~= "table" then
        return obj
    end

    local res = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do
        res[copy_(k)] = copy_(v)
    end

    return res
end
---Deep copy a table with all its content
---@param tbl table The table to copy
---@return table # A new table that is a clone of tbl
---@raise error if tbl is not a table
---@usage
---local tbl = { one = 1, two = 2 }
---local tbl_copy = copy(tbl)
---tbl["one"] = 11
---print(tbl["one"]) -- 11
---print(tbl_copy["one"]) -- 1
function M.copy(tbl)
    if type(tbl) ~= "table" then
        error("argument 'tbl': must be a table")
    end

    return copy_(tbl)
end

---Ensure every key/value pair of tbl produce a true return of fn
---@param tbl table The tbl to test key/value pairs with fn
---@param fn function The function to call with tbl's key/value pairs.<br/>
---This function should return a boolean and take a key of tbl as first argument and a value of tbl as second argument
---@param ... any Additional arguments to pass to fn
---@return boolean # true if all call of fn with each of tbl's key/value pairs returned true, false otherwise
---@raise error if tbl is not a table<br/>
---error if fn is not a function<br/>
---error if fn returned something else than a boolean
---@usage
---local tbl = { one = 1, two = 2 }
---if allOf(tbl, function(key, value)
---    return type(value) == "number"
---end)
---    print("All table values are numbers")
---else
---    print("One or more table value(s) is not a number")
---end
function M.allOf(tbl, fn, ...)
    if type(tbl) ~= "table" then
        error("argument 'tbl': must be a table")
    end
    if type(fn) ~= "function" then
        error("argument 'fn': must be a function")
    end

    for key,value in pairs(tbl) do
        local result = fn(key, value, ...)
        if type(result) ~= "boolean" then
            error("argument 'fn': returned something else than a boolean")
        end

        if not result then
            return false
        end
    end

    return true
end

---Check if one of the key/value pair of tbl produce a true return of fn
---@param tbl table The tbl to test key/value pairs with fn
---@param fn function The function to call with tbl's key/value pairs.<br/>
---This function should return a boolean and take a key of tbl as first argument and a value of tbl as second argument
---@param ... any Additional arguments to pass to fn
---@return boolean # true if one of the calls of fn with each of tbl's key/value pairs returned true, false otherwise
---@raise error if tbl is not a table<br/>
---error if fn is not a function<br/>
---error if fn returned something else than a boolean
---@usage
---local tbl = { one = 1, two = 2, hello = "world" }
---if anyOf(tbl, function(key, value)
---    return type(value) == "string"
---end)
---    print("One or more of the table value(s) is a string")
---else
---    print("None of the table value is a string")
---end
function M.anyOf(tbl, fn, ...)
    if type(tbl) ~= "table" then
        error("argument 'tbl': must be a table")
    end
    if type(fn) ~= "function" then
        error("argument 'fn': must be a function")
    end

    for key,value in pairs(tbl) do
        local result = fn(key, value, ...)
        if type(result) ~= "boolean" then
            error("argument 'fn': returned something else than a boolean")
        end

        if result then
            return true
        end
    end

    return false
end

---Check if all of tbl's key/value pais produce a false return of fn
---@param tbl table The tbl to test key/value pairs with fn
---@param fn function The function to call with tbl's key/value pairs.<br/>
---This function should return a boolean and take a key of tbl as first argument and a value of tbl as second argument
---@param ... any Additional arguments to pass to fn
---@return boolean # true if none of the calls of fn with each of tbl's key/value returned true, false otherwise
---@raise error if tbl is not a table<br/>
---error if fn is not a function<br/>
---error if fn returned something else than a boolean
---@usage
---local tbl = { one = 1, two = 2 }
---if noneOf(tbl, function(key, value)
---    return type(value) == "string"
---end)
---    print("The table does not contains string values")
---end
function M.noneOf(tbl, fn, ...)
    if type(tbl) ~= "table" then
        error("argument 'tbl': must be a table")
    end
    if type(fn) ~= "function" then
        error("argument 'fn': must be a function")
    end

    for key,value in pairs(tbl) do
        local result = fn(key, value, ...)
        if type(result) ~= "boolean" then
            error("argument 'fn': returned something else than a boolean")
        end

        if result then
            return false
        end
    end

    return true
end

---Execute a function with all key/value pair of a table
---@param tbl table The tbl to test key/value pairs with fn
---@param fn function The function to call with tbl's key/value pairs.<br/>
---This function should take a key of tbl as first argument and a value of tbl as second argument
---@param ... any Additional arguments to pass to fn
---@raise error if tbl is not a table<br/>
---error if fn is not a function
---@usage
---local tbl = { one = 1, two = 2 }
---forEach(tbl, function(key, value)
---    print(key .. ": " .. value)
---end)
--- -- one: 1
--- -- two: 2
function M.forEach(tbl, fn, ...)
    if type(tbl) ~= "table" then
        error("argument 'tbl': must be a table")
    end
    if type(fn) ~= "function" then
        error("argument 'fn': must be a function")
    end

    for key,value in pairs(tbl) do
        fn(key, value, ...)
    end
end

return M
