local m = require("neokit/vim")

---Check if a binding exists
---@param mode string The mode the binding has been registered for
---@param key string The expected key of the binding
---@param action string|function The expected action of the binding
---@param opts? table Expected opts values
---@return boolean # true if the binding exists, false otherwise
local function checkKeymap(mode, key, action, opts)
    if opts == nil then
        opts = {}
    end
    if type(mode) ~= "string" then
        error("argument 'mode': must be a string")
    end
    if type(key) ~= "string" then
        error("argument 'key': must be a string")
    end
    if type(action) ~= "string" and type(action) ~= "function" then
        error("argument 'action': must be a string or a function")
    end
    if type(opts) ~= "table" then
        error("argument 'opts': must be a table")
    end

    local keymaps = vim.api.nvim_get_keymap(mode)

    for _, t in ipairs(keymaps) do
        if t["lhs"] == key and (type(action) == "string" and t["rhs"] == action or t["callback"] == action) then
            local ok = true
            for k, v in pairs(opts) do
                if type(v) == "boolean" then
                    v = v and 1 or 0
                end
                if t[k] ~= v then
                    ok = false
                    break
                end
            end
            if ok then
                return true
            end
        end
    end

    return false
end

describe("[map]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.map()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.map(2)
            end)
        end)

        it("Should throw when argument 1 is not valid", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.map("blabla")
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.map("n")
            end)
        end)

        it("Should throw when argument 2 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.map("n", 2)
            end)
        end)

        -- Argument 3
        it("Should throw when argument 3 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.map("n", "<leader>G")
            end)
        end)

        it("Should throw when argument 3 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.map("n", "<leader>G", 2)
            end)
        end)

        -- Argument 4
        it("Should not throw when argument 4 is not given", function()
            assert.Not.has.errors(function()
                m.map("n", "<leader>G", "echo a")
            end)
        end)

        it("Should throw when argument 4 is not a table", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.map("n", "<leader>G", "echo a", 2)
            end)
        end)
    end)

    --- Using string action
    it("Should create a new keybind to the action in the associated mode", function()
        local mode = "i"
        local key = "randomkeybind"
        local action = "randomaction"

        m.map(mode, key, action)
        assert.is.True(checkKeymap(mode, key, action))

        mode = "n"
        m.map(mode, key, action)
        assert.is.True(checkKeymap(mode, key, action))
    end)

    it("Should force erase any previous keybind on the same key and mode", function()
        local mode = "n"
        local key = "anotherrandomkeybind"
        local action = "anotherrandomaction"

        m.map(mode, key, action)
        assert.is.True(checkKeymap(mode, key, action))

        action = "new anotherrandomaction"

        m.map(mode, key, action)
        assert.is.True(checkKeymap(mode, key, action))
    end)

    it("Should successfully use the neovim opts", function()
        local mode = "i"
        local key = "otherrandomkeybind"
        local action = "otherrandomaction"
        local opts = {
            desc = "Hello world",
            nowait = true,
            silent = true,
        }

        m.map(mode, key, action, opts)
        assert.is.True(checkKeymap(mode, key, action, opts))

        key = "new otherrandomkeybind"
        opts.silent = false

        m.map(mode, key, action, opts)
        assert.is.True(checkKeymap(mode, key, action, opts))
    end)

    it("Should successfully map in multiple modes", function()
        local mode = { "n", "i" }
        local key = "someotherrandomkeybind"
        local action = "someotherrandomaction"

        m.map(mode, key, action)
        assert.is.True(checkKeymap("n", key, action))
        assert.is.True(checkKeymap("i", key, action))
        assert.is.False(checkKeymap("v", key, action))
    end)

    it("Should successfully map in all modes when using *", function()
        local mode = "*"
        local key = "someanotherrandomkeybind"
        local action = "someanotherrandomaction"

        m.map(mode, key, action)
        assert.is.True(checkKeymap("n", key, action))
        assert.is.True(checkKeymap("v", key, action))
        assert.is.True(checkKeymap("i", key, action))
    end)

    -- Using function action
    it("Should create a new keybind to the function in the associated mode", function()
        local mode = "i"
        local key = "somerandomkeybind"
        local function action()
            print("Doing stuff")
        end

        m.map(mode, key, action)
        assert.is.True(checkKeymap(mode, key, action))
    end)

    it("Should force erase any previous keybind on the same key and mode", function()
        local mode = "n"
        local key = "anotherrandomkeybind"
        local function action()
            print("Doing stuff")
        end

        m.map(mode, key, action)
        assert.is.True(checkKeymap(mode, key, action))

        action = function()
            print("Something else")
        end

        m.map(mode, key, action)
        assert.is.True(checkKeymap(mode, key, action))
    end)

    it("Should successfully use the neovim opts", function()
        local mode = "i"
        local key = "otherrandomkeybind"
        local function action()
            print("Doing stuff")
        end
        local opts = {
            desc = "Hello world",
            nowait = true,
            silent = true,
        }

        m.map(mode, key, action, opts)
        assert.is.True(checkKeymap(mode, key, action, opts))

        key = "new otherrandomkeybind"
        opts.silent = false

        m.map(mode, key, action, opts)
        assert.is.True(checkKeymap(mode, key, action, opts))
    end)
end)

describe("[mapExists]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.mapExists()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.mapExists(2)
            end)
        end)

        it("Should throw when argument 1 is not valid", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.mapExists("blabla")
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.mapExists("n")
            end)
        end)

        it("Should throw when argument 2 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.mapExists("n", 2)
            end)
        end)
    end)

    it("Should return true if mapping exists", function()
        local mode = "i"
        local key = "arandomkeybind"
        local action = "arandomaction"

        m.map(mode, key, action)
        assert.is.True(m.mapExists(mode, key))
    end)

    it("Should return false if mapping does not exists", function()
        local mode = "n"
        local key = "arandomkeybindthatdoesnotexist"

        assert.is.False(m.mapExists(mode, key))
    end)

    it("Should return false if mapping has been unmapped", function()
        local mode = "n"
        local key = "arandomkeybindreplaced"
        local action = "arandomactionreplaced"

        m.map(mode, key, action)
        assert.is.True(m.mapExists(mode, key))

        m.unmap(mode, key)
        assert.is.False(m.mapExists(mode, key))
    end)
end)

describe("[getMap]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.getMap()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.getMap(2)
            end)
        end)

        it("Should throw when argument 1 is not valid", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.getMap("blabla")
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.getMap("n")
            end)
        end)

        it("Should throw when argument 2 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.getMap("n", 2)
            end)
        end)
    end)

    it("Should return a table if mapping exists", function()
        local mode = "i"
        local key = "arandomkeybind"
        local action = "arandomaction"

        m.map(mode, key, action)
        assert.are.same("table", type(m.getMap(mode, key)))
    end)

    it("Should return nil if mapping does not exists", function()
        local mode = "n"
        local key = "arandomkeybindthatdoesnotexist"

        assert.is.Nil(m.getMap(mode, key))
    end)

    it("Should return a table with valid values if mapping exists", function()
        local mode = "n"
        local key = "somerandomkeybind"
        local action = "somerandomaction"
        local opts = {
            nowait = true,
            silent = true,
            desc = "This is the description of this custom keybind",
        }

        m.map(mode, key, action, opts)
        local result = m.getMap(mode, key)
        assert.Not.is.Nil(result)
        ---@diagnostic disable-next-line: need-check-nil
        assert.are.same(mode, result["mode"])
        ---@diagnostic disable-next-line: need-check-nil
        assert.are.same(key, result["lhs"])
        ---@diagnostic disable-next-line: need-check-nil
        assert.are.same(action, result["rhs"])
        for k, v in pairs(opts) do
            if type(v) == "boolean" then
                ---@diagnostic disable-next-line: cast-local-type
                v = v and 1 or 0
            end
            ---@diagnostic disable-next-line: need-check-nil
            assert.are.same(v, result[k])
        end
    end)
end)

describe("[unmap]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.unmap()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.unmap(2)
            end)
        end)

        it("Should throw when argument 1 is not valid", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.unmap("blabla")
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.unmap("n")
            end)
        end)

        it("Should throw when argument 2 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.unmap("n", 2)
            end)
        end)
    end)

    it("Should do nothing if the keybind does not exists", function()
        local mode = "i"
        local key = "randomkeybindthatdoesnotexist"
        local action = "randomactionthatdoesnotexist"

        assert.is.False(m.unmap(mode, key))
        assert.is.False(checkKeymap(mode, key, action))
    end)

    it("Should remove the keybind if it exists", function()
        local mode = "i"
        local key = "randomkeybind"
        local action = "randomaction"

        m.map(mode, key, action)
        assert.is.True(checkKeymap(mode, key, action))

        assert.is.True(m.unmap(mode, key))
        assert.is.False(checkKeymap(mode, key, action))
    end)

    it("Should remove built-in keybinds", function()
        local mode = "i"
        local key = "<C-W>"
        local action = "<C-G>u<C-W>"

        assert.is.True(checkKeymap(mode, key, action))
        assert.is.True(m.unmap(mode, key))
        assert.is.False(checkKeymap(mode, key, action))
    end)

    it("Should remove map in multiple modes", function()
        local mode = { "n", "i" }
        local key = "someotherrandomkeybind"
        local action = "someotherrandomaction"

        m.map(mode, key, action)
        assert.is.True(checkKeymap("n", key, action))
        assert.is.True(checkKeymap("i", key, action))
        m.unmap(mode, key)
        assert.is.False(checkKeymap("n", key, action))
        assert.is.False(checkKeymap("i", key, action))
    end)

    it("Should successfully unmap in all modes when using *", function()
        local mode = "*"
        local key = "someanotherrandomkeybind"
        local action = "someanotherrandomaction"

        m.map(mode, key, action)
        assert.is.True(checkKeymap("n", key, action))
        assert.is.True(checkKeymap("v", key, action))
        assert.is.True(checkKeymap("i", key, action))
        m.unmap(mode, key)
        assert.is.False(checkKeymap("n", key, action))
        assert.is.False(checkKeymap("v", key, action))
        assert.is.False(checkKeymap("i", key, action))
    end)
end)

describe("[getOption]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.getOption()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.getOption(2)
            end)
        end)

        it("Should throw when the argument 1 is not valid", function()
            assert.has.errors(function()
                m.getOption("notvalid")
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not a table", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.getOption("mouse", 2)
            end)
        end)
    end)

    it("Should return the value of the given option", function()
        local option = "mouse"
        local value = "n"

        vim.api.nvim_set_option_value(option, value, {})

        assert.are.same(m.getOption(option), value)
    end)

    it("Should return the value of the given option after change", function()
        local option = "mouse"
        local value = "n"

        vim.api.nvim_set_option_value(option, value, {})
        assert.are.same(m.getOption(option), value)

        value = "i"
        vim.api.nvim_set_option_value(option, value, {})
        assert.are.same(m.getOption(option), value)
    end)
end)

describe("[setOption]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.setOption()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.setOption(2)
            end)
        end)

        it("Should throw when the argument 1 is not valid", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.setOption("notvalid")
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.setOption("mouse")
            end)
        end)

        it("Should throw when argument 2 is not a string/number/boolean", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.setOption("mouse", {})
            end)
        end)
    end)

    it("Should change the value of the option", function()
        local option = "mouse"
        local value = "nvi"

        m.setOption(option, value)
        assert.are.same(vim.api.nvim_get_option_value(option, {}), value)

        value = "ni"
        m.setOption(option, value)
        assert.are.same(vim.api.nvim_get_option_value(option, {}), value)
    end)
end)

describe("[isStringBeforeCursor]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.isStringBeforeCursor()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.isStringBeforeCursor(2)
            end)
        end)
    end)
end)
