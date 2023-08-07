local m = require("neokit/str")

describe("[contains]:", function()
    describe("arguments:", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function()
                m.contains()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function()
                m.contains(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function()
                m.contains("Hello")
            end)
        end)

        it("Should throw when argument 2 is not a string", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function()
                m.contains("Hello", 2)
            end)
        end)
    end)

    -- True cases
    it("Should return true if str contains the pattern 1 time at start", function()
        assert.is.True(m.contains("Hello world!", "Hello"))
    end)

    it("Should return true if str contains the pattern 1 time at midle", function()
        assert.is.True(m.contains("Hello world!", "wor"))
    end)

    it("Should return true if str contains the pattern 1 time at end", function()
        assert.is.True(m.contains("Hello world!", "ld!"))
    end)

    it("Should return true if str contains the pattern multiple times", function()
        assert.is.True(m.contains("Hello world!", "o"))
    end)

    -- False cases
    it("Should return false if str is empty", function()
        assert.is.False(m.contains("", "o"))
    end)

    it("Should return false if pattern is empty", function()
        assert.is.False(m.contains("o", ""))
    end)

    it("Should return false if both str and pattern are empty", function()
        assert.is.False(m.contains("", ""))
    end)

    it("Should return false if str does not contains the pattern", function()
        assert.is.False(m.contains("Hello world!", "carrot"))
    end)
end)

describe("[ensureLastChar]:", function()
    describe("arguments:", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function()
                m.ensureLastChar()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function()
                m.ensureLastChar(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function()
                m.ensureLastChar("Hello world")
            end)
        end)

        it("Should throw when argument 2 is not a string", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function()
                m.ensureLastChar("Hello world", 2)
            end)
        end)

        it("Should throw when argument 2 is more than 1 char long", function()
            assert.has.errors(function()
                m.ensureLastChar("Hello wo", "rld")
            end)
        end)
    end)

    it("Should add char at end of str if not already present", function()
        local result = m.ensureLastChar("Hello world", "!")
        assert.are.same("Hello world!", result)
    end)

    it("Should not add char at end of str if already present", function()
        local result = m.ensureLastChar("Hello world!", "!")
        assert.are.same("Hello world!", result)
    end)

    it("Should not change str when not adding char at the end", function()
        local source = "Hello world!"
        local result = m.ensureLastChar(source, "!")
        assert.are.same(source, result)
    end)

    it("Should not change str except last char when adding it", function()
        local source = "Hello world"
        local result = m.ensureLastChar(source, "!")
        assert.are.same(source, result:sub(1, -2))
    end)
end)
