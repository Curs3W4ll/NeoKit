---Array utilities module
---@module array
---@alias M

local M = {}

---Concat arr2 into arr1
---@param arr1 table The first array to concat the second into
---@param arr2 table The second array to concat into the first
---@return table # A new array with arr2 concat into arr1
---@raise error if arr1 is not a table<br/>
---error if arr2 is not a table
---@usage
---local arr1 = {"one", "three"}
---local arr2 = {"two", 4}
---local arr3 = concat(arr1, arr2)
--- -- arr3 -> {"one", "three", "two", 4}
function M.concat(arr1, arr2)
    assert(type(arr1) == "table", "argument 'arr1': must be a table")
    assert(type(arr2) == "table", "argument 'arr2': must be a table")

    local concat = {}

    for _, v in ipairs(arr1) do
        table.insert(concat, v)
    end
    for _, v in ipairs(arr2) do
        table.insert(concat, v)
    end

    return concat
end

---Check if an array contains an element
---@param arr table The array to search the element in
---@param elem any The element to search in the array. This cannot be nil
---@return boolean # `true` if arr contains elem, `false` otherwise
---@raise error if arr is not a table<br/>
---error if elem is nil
---@usage
---local arr = {1, 2, 4}
---if not contains(arr, 3) then
---    print("Array does not contains a 3")
---else
---    print("Array contains a 3")
---end
function M.contains(arr, elem)
    assert(type(arr) == "table", "argument 'arr': must be a table")
    assert(elem ~= nil, "argument 'elem': cannot be nil")

    for _, v in ipairs(arr) do
        if v == elem then
            return true
        end
    end

    return false
end

return M
