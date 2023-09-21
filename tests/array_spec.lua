local m = require("neokit/array")

describe("[concat]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.concat()
            end)
        end)

        it("Should throw when argument 1 is not a table", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.concat(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.concat({ 1, 2 })
            end)
        end)

        it("Should throw when argument 2 is not a table", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.concat({ 1, 2 }, 2)
            end)
        end)
    end)

    it("Should return an empty array if both arguments are empty", function()
        local result = m.concat({}, {})

        assert.are.same({}, result)
    end)

    it("Should return arr1 if arr2 is empty", function()
        local arr1 = { 1, 2 }
        local result = m.concat(arr1, {})

        assert.are.same(arr1, result)
    end)

    it("Should return arr2 if arr1 is empty", function()
        local arr2 = { 1, 2 }
        local result = m.concat({}, arr2)

        assert.are.same(arr2, result)
    end)

    it("Should return arr1 and arr2 concatenated", function()
        local result = m.concat({ 1, 2 }, { 3, 4 })

        assert.are.same({ 1, 2, 3, 4 }, result)
    end)

    it("Should duplicate same values between arrays", function()
        local result = m.concat({ 1, 2, 3 }, { 3, 4 })

        assert.are.same({ 1, 2, 3, 3, 4 }, result)
    end)
end)

describe("[contains]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.contains()
            end)
        end)

        it("Should throw when argument 1 is not a table", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.contains(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                m.contains({ 1, 2 })
            end)
        end)
    end)

    -- True cases
    it("Should return true if arr contains elem", function()
        local arr = { 1, 2, 3, 4 }

        assert.is.True(m.contains(arr, 3))
    end)

    it("Should return true if arr contains elem multiple times", function()
        local arr = { 1, 2, 1, 2, 1, 2 }

        assert.is.True(m.contains(arr, 2))
    end)

    it("Should return true if arr contains elem at first", function()
        local arr = { 1, 2, 3, 4 }

        assert.is.True(m.contains(arr, 1))
    end)

    it("Should return true if arr contains elem at last", function()
        local arr = { 1, 2, 3, 4 }

        assert.is.True(m.contains(arr, 4))
    end)

    -- False cases
    it("Should return false if arr is empty", function()
        assert.is.False(m.contains({}, 4))
    end)

    it("Should return false if arr does not contain elem", function()
        local arr = { 1, 2, 3, 4 }

        assert.is.False(m.contains(arr, 44))
    end)
end)

describe("[mergeTables]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.mergeTables()
            end)
        end)

        it("Should throw when argument 1 is not a table", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.mergeTables(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                m.mergeTables({ {}, {} })
            end)
        end)
    end)

    -- Single key
    it("Should return an empty array if none of arr's elements are tables", function()
        local arr = { "Hello", 1, 2 }

        assert.is.same({}, m.mergeTables(arr, "theKey"))
    end)

    it("Should return the list of key's values of child tables", function()
        local arr = {
            { name = "Brian", age = 23 },
            { name = "Michel", age = 38 },
            { name = "Sara", age = 27 },
        }

        assert.is.same({ "Brian", "Michel", "Sara" }, m.mergeTables(arr, "name"))
    end)

    it("Should return the list of key's values only if type is table", function()
        local arr = {
            { name = "Brian", age = 23 },
            "Hello",
            { name = "Michel", age = 38 },
            2,
            { name = "Sara", age = 27 },
        }

        assert.is.same({ "Brian", "Michel", "Sara" }, m.mergeTables(arr, "name"))
    end)

    it("Should return the list of key's values only if key is present", function()
        local arr = {
            { name = "Brian", age = 23 },
            { age = 38 },
            { name = "Sara", age = 27 },
        }

        assert.is.same({ "Brian", "Sara" }, m.mergeTables(arr, "name"))
    end)

    it("Should return the list of key's values multiple times", function()
        local arr = {
            { name = "Brian", age = 23 },
            { name = "Brian", age = 38 },
            { name = "Sara", age = 27 },
        }

        assert.is.same({ "Brian", "Brian", "Sara" }, m.mergeTables(arr, "name"))
    end)

    -- Multiple keys
    it("Should return fallbacks when main key is not present", function()
        local arr = {
            { name = "Component1", alias = "C1", fallback = "1" },
            { alias = "C2", fallback = "2" },
            { name = "Component3", alias = "C3", fallback = "3" },
            { fallback = "4" },
            { completely = "on", another = "thing" },
            { alias = "C5", fallback = "5" },
        }
        local expected = { "Component1", "C2", "Component3", "4", "C5" }

        assert.is.same(expected, m.mergeTables(arr, { "name", "alias", "fallback" }))
    end)
end)

describe("[allOf]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.allOf()
            end)
        end)

        it("Should throw when argument 1 is not a table", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.allOf(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.allOf({ 1, 2 })
            end)
        end)

        it("Should throw when argument 2 is not a function", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.allOf({ 1, 2 }, 2)
            end)
        end)

        it("Should throw when argument 2 returns something else than a boolean", function()
            assert.has.errors(function()
                m.allOf({ 1, 2 }, function()
                    return "Hello"
                end)
            end)
        end)
    end)

    it("Should call function with every arr's elements", function()
        local arr = { 1, 2, 3 }
        local passedElems = {}

        m.allOf(arr, function(elem)
            table.insert(passedElems, elem)
            return true
        end)
        assert.are.same(arr, passedElems)
    end)

    it("Should return true if every function call returned true", function()
        assert.is.True(m.allOf({ 1, 2, 3 }, function(_)
            return true
        end))
    end)

    it("Should return false if every function call returned false", function()
        assert.is.False(m.allOf({ 1, 2, 3 }, function(_)
            return false
        end))
    end)

    it("Should return false if one of the function call returned false", function()
        assert.is.False(m.allOf({ 1, 2, 3 }, function(elem)
            return elem ~= 2
        end))
    end)

    it("Should pass additional arguments has given to allOf", function()
        local arr = { 1, 2, 3 }
        local additionalArg = { "Another", "additional", "argument" }

        m.allOf(arr, function(_, fnAdditionalArg)
            assert.is.equal(additionalArg, fnAdditionalArg)
            return true
        end, additionalArg)
    end)
end)

describe("[anyOf]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.anyOf()
            end)
        end)

        it("Should throw when argument 1 is not a table", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.anyOf(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.anyOf({ 1, 2 })
            end)
        end)

        it("Should throw when argument 2 is not a function", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.anyOf({ 1, 2 }, 2)
            end)
        end)

        it("Should throw when argument 2 returns something else than a boolean", function()
            assert.has.errors(function()
                m.anyOf({ 1, 2 }, function()
                    return "Hello"
                end)
            end)
        end)
    end)

    it("Should call function with every arr's elements", function()
        local arr = { 1, 2, 3 }
        local passedElems = {}

        m.anyOf(arr, function(elem)
            table.insert(passedElems, elem)
            return false
        end)
        assert.are.same(arr, passedElems)
    end)

    it("Should return true if every function call returned true", function()
        assert.is.True(m.anyOf({ 1, 2, 3 }, function(_)
            return true
        end))
    end)

    it("Should return true if one of the function call returned true", function()
        assert.is.True(m.anyOf({ 1, 2, 3 }, function(elem)
            return elem == 2
        end))
    end)

    it("Should return false if every function call returned false", function()
        assert.is.False(m.anyOf({ 1, 2, 3 }, function(_)
            return false
        end))
    end)

    it("Should pass additional arguments has given to anyOf", function()
        local arr = { 1, 2, 3 }
        local additionalArg = { "Another", "additional", "argument" }

        m.anyOf(arr, function(_, fnAdditionalArg)
            assert.is.equal(additionalArg, fnAdditionalArg)
            return true
        end, additionalArg)
    end)
end)

describe("[noneOf]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.noneOf()
            end)
        end)

        it("Should throw when argument 1 is not a table", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.noneOf(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.noneOf({ 1, 2 })
            end)
        end)

        it("Should throw when argument 2 is not a function", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.noneOf({ 1, 2 }, 2)
            end)
        end)

        it("Should throw when argument 2 returns something else than a boolean", function()
            assert.has.errors(function()
                m.noneOf({ 1, 2 }, function()
                    return "Hello"
                end)
            end)
        end)
    end)

    it("Should call function with every arr's elements", function()
        local arr = { 1, 2, 3 }
        local passedElems = {}

        m.noneOf(arr, function(elem)
            table.insert(passedElems, elem)
            return false
        end)
        assert.are.same(arr, passedElems)
    end)

    it("Should return true if every function call returned false", function()
        assert.is.True(m.noneOf({ 1, 2, 3 }, function(_)
            return false
        end))
    end)

    it("Should return false if every function call returned true", function()
        assert.is.False(m.noneOf({ 1, 2, 3 }, function(_)
            return true
        end))
    end)

    it("Should return false if one of the function call returned true", function()
        assert.is.False(m.noneOf({ 1, 2, 3 }, function(elem)
            return elem == 2
        end))
    end)

    it("Should pass additional arguments has given to noneOf", function()
        local arr = { 1, 2, 3 }
        local additionalArg = { "Another", "additional", "argument" }

        m.noneOf(arr, function(_, fnAdditionalArg)
            assert.is.equal(additionalArg, fnAdditionalArg)
            return false
        end, additionalArg)
    end)
end)

describe("[forEach]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.forEach()
            end)
        end)

        it("Should throw when argument 1 is not a table", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                m.forEach(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.forEach({ 1, 2 })
            end)
        end)

        it("Should throw when argument 2 is not a function", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.forEach({ 1, 2 }, 2)
            end)
        end)
    end)

    it("Should call function with every arr's elements", function()
        local arr = { 1, 2, 3 }
        local passedElems = {}

        m.forEach(arr, function(elem)
            table.insert(passedElems, elem)
        end)
        assert.are.same(arr, passedElems)
    end)

    it("Should pass additional arguments has given to forEach", function()
        local arr = { 1, 2, 3 }
        local additionalArg = { "Another", "additional", "argument" }

        m.forEach(arr, function(_, fnAdditionalArg)
            assert.is.equal(additionalArg, fnAdditionalArg)
        end, additionalArg)
    end)
end)

describe("[join]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
---@diagnostic disable-next-line: missing-parameter
                m.join()
            end)
        end)

        it("Should throw when argument 1 is not a table", function()
            assert.has.errors(function()
---@diagnostic disable-next-line: param-type-mismatch
                m.join(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not a string", function()
            assert.has.errors(function()
---@diagnostic disable-next-line: param-type-mismatch
                m.join({ 1, 2 }, 2)
            end)
        end)
    end)

    it("Should produce empty string when trying to join empty array", function()
        assert.are.same("", m.join({}))
    end)

    it("Should join together elements without separator if not specified", function()
        local arr = { 1, 2, 3 }
        local expected = "123"

        assert.are.same(expected, m.join(arr))
    end)

    it("Should join together elements separated by the specified separator", function()
        local arr = { 1, 2, 3 }
        local expected = "1, 2, 3"

        assert.are.same(expected, m.join(arr, ", "))
    end)
end)
