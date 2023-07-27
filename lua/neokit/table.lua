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
---local tbl1 = {"one": 1, "three": 3}
---local tbl2 = {"two": 2, 4: "four"}
---local tbl3 = concat(tbl1, tbl2)
--- -- tbl3 -> {"one": 1, "three": 3, "two": 2, 4: "four"}
function M.concat(tbl1, tbl2, force)
    if force == nil then
        force = false
    end
    assert(type(tbl1) == "table", "argument 'tbl1': must be a table")
    assert(type(tbl2) == "table", "argument 'tbl2': must be a table")
    assert(type(force) == "boolean", "argument 'force': must be a boolean")

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
---local tbl = {1: "one", "two": 2}
---if not contains(tbl, "two") then
---    print("Table has no entry 'two'")
---else
---    print("Table has an entry 'two'")
---end
function M.contains(tbl, key)
    assert(type(tbl) == "table", "argument 'tbl': must be a table")
    assert(key ~= nil, "argument 'key': cannot be nil")

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
---local tbl = {1: "one", 2: "two"}
---print(find(tbl, "two")) -- 2
function M.find(tbl, value)
    assert(type(tbl) == "table", "argument 'tbl': must be a table")
    assert(value ~= nil, "argument 'value': cannot be nil")

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
---local tbl = { "one": 1, "two": 2 }
---local tbl_copy = copy(tbl)
---tbl["one"] = 11
---print(tbl["one"]) -- 11
---print(tbl_copy["one"]) -- 1
function M.copy(tbl)
    assert(type(tbl) == "table", "argument 'tbl': must be a table")

    return copy_(tbl)
end

return M
