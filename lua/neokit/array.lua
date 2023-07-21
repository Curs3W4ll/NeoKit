local M = {}

---Concat arr2 into arr1
---@param arr1 table The first array to concat the second into
---@param arr2 table The second array to concat into the first
---@return table # A new array with arr2 concat into arr1
function M.concat(arr1, arr2)
    assert(type(arr1) == "table", "argument 'arr1': must be a table")
    assert(type(arr2) == "table", "argument 'arr2': must be a table")

    local concat = {}

    for _,v in ipairs(arr1) do
        table.insert(concat, v)
    end
    for _,v in ipairs(arr2) do
        table.insert(concat, v)
    end

    return concat
end

---Check if an array contains an element
---@param arr table The array to search the element in
---@param elem any The element to search in the array. This cannot be nil
---@return boolean # true if arr contains elem, false otherwise
function M.contains(arr, elem)
    assert(type(arr) == "table", "argument 'arr': must be a table")
    assert(elem ~= nil, "argument 'elem': cannot be nil")

    for _,v in ipairs(arr) do
        if v == elem then
            return true
        end
    end

    return false
end

return M
