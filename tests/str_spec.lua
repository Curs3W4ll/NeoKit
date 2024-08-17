local m = require("neokit/str")

describe("[contains]:", function()
    describe("arguments:", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.contains()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.contains(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.contains("Hello")
            end)
        end)

        it("Should throw when argument 2 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
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
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.ensureLastChar()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.ensureLastChar(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.ensureLastChar("Hello world")
            end)
        end)

        it("Should throw when argument 2 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
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

describe("[startWith]:", function()
    describe("arguments:", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.startWith()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.startWith(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.startWith("Hello world")
            end)
        end)

        it("Should throw when argument 2 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.startWith("Hello world", 2)
            end)
        end)
    end)

    it("Should return true if str start with the given pattern", function()
        assert.is.True(m.startWith("Hello world!", "Hel"))
    end)

    it("Should return false if str does not start with the given pattern", function()
        assert.is.False(m.startWith("Hello world!", "No"))
    end)

    it("Should return false if str contains the given pattern but not at the start", function()
        assert.is.False(m.startWith("Hello world!", "llo"))
    end)
end)

describe("[toArray]:", function()
    describe("arguments:", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.startWith()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.startWith(2)
            end)
        end)
    end)

    it("Should return a valid array contained str splitted for each letter | test 1", function()
        local str = "Hello world!"
        local expected = { "H", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d", "!" }
        assert.are.same(expected, m.toArray(str))
    end)

    it("Should return a valid array contained str splitted for each letter | test 2", function()
        local str = "Hello world!"
        local expected = { "H", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d", "!" }
        assert.are.same(expected, m.toArray(str))
    end)

    it("Should return an empty array when str is empty", function()
        assert.are.same({}, m.toArray(""))
    end)
end)

describe("[count]:", function()
    describe("arguments:", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.count()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.count(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.count("")
            end)
        end)

        it("Should throw when argument 2 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.count("", 2)
            end)
        end)

        it("Should throw when argument 2 is empty", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.count("", "")
            end)
        end)
    end)

    it("Should return 0 when string does not contain the searched string", function()
        local str = "Hello world!"
        assert.are.same(0, m.count(str, "a"))
    end)

    it("Should return occurence number of the searched string in the source string", function()
        local str = "Hello world!"
        assert.are.same(1, m.count(str, "e"))
        assert.are.same(2, m.count(str, "o"))
        assert.are.same(1, m.count(str, "lo"))
    end)
end)
