local m = require("neokit/vim")

describe("[map]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function() m.map() end)
        end)

        it("Should throw when argument 1 is not a string", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.map(2) end)
        end)

        it("Should throw when argument 1 is not valid", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.map("blabla") end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.map("n") end)
        end)

        it("Should throw when argument 2 is not a string", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.map("n", 2) end)
        end)

        -- Argument 3
        it("Should throw when argument 3 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.map("n", "<leader>G") end)
        end)

        it("Should throw when argument 3 is not a string", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.map("n", "<leader>G", 2) end)
        end)

        -- Argument 4
        it("Should not throw when argument 4 is not given", function()
            assert.Not.has.errors(function() m.map("n", "<leader>G", "echo a") end)
        end)

        it("Should throw when argument 4 is not a table", function()
            ---@diagnostic disable-next-line: param-type-mismatch
            assert.has.errors(function() m.map("n", "<leader>G", "echo a", 2) end)
        end)
    end)

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

        local keymaps = vim.api.nvim_get_keymap(mode)

        for _,t in ipairs(keymaps) do
            if t["lhs"] == key and (type(action) == "string" and t["rhs"] == action or t["callback"] == action) then
                local ok = true
                for k,v in pairs(opts) do
                    if type(v) == "boolean" then
                        v = v and 1 or 0
                    end
                    if t[k] ~= v then
                        ok = false
                        break
                    end
                end
                if ok then return true end
            end
        end

        return false
    end

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
            noremap = true,
            desc = "Hello world",
            nowait = true,
            silent = true,
        }

        m.map(mode, key, action, opts)
        assert.is.True(checkKeymap(mode, key, action, opts))

        key = "new otherrandomkeybind"
        opts.noremap = false
        opts.silent = false

        m.map(mode, key, action, opts)
        assert.is.True(checkKeymap(mode, key, action, opts))
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
            noremap = true,
            desc = "Hello world",
            nowait = true,
            silent = true,
        }

        m.map(mode, key, action, opts)
        assert.is.True(checkKeymap(mode, key, action, opts))

        key = "new otherrandomkeybind"
        opts.noremap = false
        opts.silent = false

        m.map(mode, key, action, opts)
        assert.is.True(checkKeymap(mode, key, action, opts))
    end)
end)
