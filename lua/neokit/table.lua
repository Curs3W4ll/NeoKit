local M = {}

---Concat tbl2 into tbl1
---For values with the same key, values from tbl1 will be taken over values from tbl2 unless 'force' argument is set to true
---@param tbl1 table The first table to concat the second into
---@param tbl2 table The second table to concat into the first
---@param force? boolean If
---@return table # A new table with tbl2 concat into tbl1
function M.concat(tbl1, tbl2, force)
    assert(type(tbl1) == "table", "argument 'tbl1': must be a table")
    assert(type(tbl2) == "table", "argument 'tbl2': must be a table")
    assert(type(force) == "boolean", "argument 'force': must be a boolean")

    local concat = {}

    for k,v in pairs(tbl1) do
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

return M
