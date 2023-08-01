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
    if type(arr1) ~= "table" then
        error("argument 'arr1': must be a table")
    end
    if type(arr2) ~= "table" then
        error("argument 'arr2': must be a table")
    end

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
    if type(arr) ~= "table" then
        error("argument 'arr': must be a table")
    end
    if elem == nil then
        error("argument 'elem': cannot be nil")
    end

    for _, v in ipairs(arr) do
        if v == elem then
            return true
        end
    end

    return false
end

---Merge keys of tables into a simple array
---@param arr table The array containing tables to merge keys from
---@param keys any|table The keys to build the new array from values<br/>
---You can submit one or multiple keys through a table.<br/>
---If multiple keys are submitted, the first found one will be used, others will be used as fallbacks
---@raise error if arr is not a table<br/>
---error if keys is nil
---@usage
---local arr = {
---    {
---        name = "Component1",
---        description = "This is the description of the Component1",
---        alias = "C1",
---    },
---    {
---        name = "Component2",
---        description = "This is the description of the Component2",
---        alias = "C2",
---    },
---    {
---        name = "Component3",
---        description = "This is the description of the Component3",
---    },
---}
---local test1 = mergeTables(arr, "name") -- { "Component1", "Component2", "Component3" }
---local test2 = mergeTables(arr, { "name", "alias" }) -- { "Component1", "Component2", "Component3" }
---local test3 = mergeTables(arr, { "alias", "name" }) -- { "C1", "C2", "Component3" }
function M.mergeTables(arr, keys)
    if type(arr) ~= "table" then
        error("argument 'arr': must be a table")
    end
    if keys == nil then
        error("argument 'keys': cannot be nil")
    end

    if type(keys) ~= "table" then
        keys = { keys }
    end

    local list = {}

    for _, elem in ipairs(arr) do
        if type(elem) == "table" then
            for _, key in ipairs(keys) do
                if require("neokit.table").contains(elem, key) then
                    table.insert(list, elem[key])
                    break
                end
            end
        end
    end

    return list
end

---Ensure every element of arr produce a true return of fn
---@param arr table The array to test element with fn
---@param fn function The function to call with arr elements.<br/>
---This function should return a boolean and take an element of arr as first argument
---@param ... any Additional arguments to pass to fn
---@return boolean # true if all call of fn with each of arr's elements returned true, false otherwise
---@raise error if arr is not a table<br/>
---error if fn is not a function
function M.allOf(arr, fn, ...)
    if type(arr) ~= "table" then
        error("argument 'arr': must be a table")
    end
    if type(fn) ~= "function" then
        error("argument 'fn': must be a function")
    end

    for _,elem in ipairs(arr) do
        local result = fn(elem, ...)
        if type(result) ~= "boolean" then
            error("argument 'fn': returned something else than a boolean")
        end

        if not result then
            return false
        end
    end

    return true
end

---Check if one of arr's element produce a true return of fn
---@param arr table The array to test element with fn
---@param fn function The function to call with arr elements.<br/>
---This function should return a boolean and take an element of arr as first argument
---@param ... any Additional arguments to pass to fn
---@return boolean # true if one of the calls of fn with each of arr's elements returned true, false otherwise
---@raise error if arr is not a table<br/>
---error if fn is not a function
function M.anyOf(arr, fn, ...)
    if type(arr) ~= "table" then
        error("argument 'arr': must be a table")
    end
    if type(fn) ~= "function" then
        error("argument 'fn': must be a function")
    end

    for _,elem in ipairs(arr) do
        local result = fn(elem, ...)
        if type(result) ~= "boolean" then
            error("argument 'fn': returned something else than a boolean")
        end

        if result then
            return true
        end
    end

    return false
end

return M
