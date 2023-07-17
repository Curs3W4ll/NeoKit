-- Lazy load everything into noekit.
local neokit = setmetatable({}, {
    __index = function(t, k)
        local ok, val = pcall(require, string.format("neokit.%s", k))

        if ok then
            rawset(t, k, val)
        end

        return val
    end,
})

return neokit
