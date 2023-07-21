local M = {}

---Concat tbl2 into tbl1
---@note Values from tbl1 will be taken over values from tbl2 unless 'force' argument is set to true
---@param tbl1 table The first table to concat the second into
---@param tbl2 table The second table to concat into the first
---@param force? boolean If
---@return table # A new table with tbl2 concat into tbl1
function M.concat(tbl1, tbl2, force)
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

---Check if a table contains a key
---If the key is associated to a nil value, it will be considered as not here
---@param tbl table The table to search the key in
---@param key any The key to search in the table. This cannot be nil
---@return boolean # true if tbl contains the key key
function M.contains(tbl, key)
    assert(type(tbl) == "table", "argument 'tbl': must be a table")
    assert(key ~= nil, "argument 'key': cannot be nil")

    return tbl[key] ~= nil
end

---Finds a key that is associated to the given value
---The first founded key with the value will be returned
---@param tbl table The table to search the value in
---@param value any The value to search in the table. This cannot be nil
---@return any|nil # The first key found with the given value if any, nil otherwise
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

return M
