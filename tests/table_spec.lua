local m = require("neokit/table")

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

        -- Argument 3
        it("Should throw when argument 3 is not a boolean", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.concat({ 1, 2 }, { 3, 4 }, 2)
            end)
        end)
    end)

    it("Should return an empty table if both arguments are empty", function()
        local result = m.concat({}, {})

        assert.are.same({}, result)
    end)

    it("Should return tbl1 if tbl2 is empty", function()
        local tbl1 = {
            one = 1,
            two = 2,
        }
        local result = m.concat(tbl1, {})

        assert.are.same(tbl1, result)
    end)

    it("Should return tbl2 if tbl1 is empty", function()
        local tbl2 = {
            one = 1,
            two = 2,
        }
        local result = m.concat({}, tbl2)

        assert.are.same(tbl2, result)
    end)

    it("Should return tbl1 and tbl2 concatenated", function()
        local tbl1 = {
            one = 1,
            two = 2,
        }
        local tbl2 = {
            three = 3,
            four = 4,
        }
        local expected = {
            one = 1,
            two = 2,
            three = 3,
            four = 4,
        }
        local result = m.concat(tbl1, tbl2)

        assert.are.same(expected, result)
    end)

    it("Should take duplicate values from tbl1 over tbl2 when force is set to false or not given", function()
        local tbl1 = {
            one = 1,
            two = 2,
        }
        local tbl2 = {
            three = 3,
            one = 11,
        }
        local expected = {
            one = 1,
            two = 2,
            three = 3,
        }
        local result = m.concat(tbl1, tbl2, false)

        assert.are.same(expected, result)
    end)

    it("Should take duplicate values from tbl2 over tbl1 when force is set to true", function()
        local tbl1 = {
            one = 1,
            two = 2,
        }
        local tbl2 = {
            three = 3,
            one = 11,
        }
        local expected = {
            one = 11,
            two = 2,
            three = 3,
        }
        local result = m.concat(tbl1, tbl2, true)

        assert.are.same(expected, result)
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
    it("Should return true if tbl contains key", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }

        assert.is.True(m.contains(tbl, "two"))
    end)

    it("Should return true if tbl contains key at first", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }

        assert.is.True(m.contains(tbl, "one"))
    end)

    it("Should return true if tbl contains key at last", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }

        assert.is.True(m.contains(tbl, "three"))
    end)

    -- -- False cases
    it("Should return false if tbl is empty", function()
        assert.is.False(m.contains({}, 4))
    end)

    it("Should return false if tbl does not contain key", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }

        assert.is.False(m.contains(tbl, "four"))
    end)

    it("Should return false if tbl contains key as a value", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }

        assert.is.False(m.contains(tbl, 2))
    end)
end)

describe("[find]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.find()
            end)
        end)

        it("Should throw when argument 1 is not a table", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.find(2)
            end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            assert.has.errors(function()
                m.find({ 1, 2 })
            end)
        end)
    end)

    it("Should return the key if tbl contains value", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }

        assert.are.same("two", m.find(tbl, 2))
    end)

    it("Should return a key if tbl contains value multiple times", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
            uno = 1,
            eins = 1,
            un = 1,
        }

        local result = m.find(tbl, 1)

        assert.Not.Nil(result)
        assert.are.same(1, tbl[result])
    end)

    it("Should return the key if tbl contains value at start", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }

        assert.are.same("one", m.find(tbl, 1))
    end)

    it("Should return the key if tbl contains value at last", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }

        assert.are.same("three", m.find(tbl, 3))
    end)

    it("Should return nil if tbl does not contains value", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }

        assert.is.Nil(m.find(tbl, 4))
    end)

    it("Should return nil if tbl is empty", function()
        assert.is.Nil(m.find({}, 4))
    end)
end)

describe("[copy]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.copy()
            end)
        end)

        it("Should throw when argument 1 is not a table", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.copy(2)
            end)
        end)
    end)

    it("Should return an identical table as tbl but with a different address", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }

        local result = m.copy(tbl)

        assert.are.same(tbl, result)
        assert.Not.are.equal(tbl, result)
    end)

    it("Should not alterate the original table when editing the copied one", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }

        local copy = m.copy(tbl)
        copy["aKey"] = "aValue"

        assert.Not.are.same(tbl, copy)
        assert.are.same({
            one = 1,
            two = 2,
            three = 3,
        }, tbl)
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
                m.allOf({ one = 1, two = 2 })
            end)
        end)

        it("Should throw when argument 2 is not a function", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.allOf({ one = 1, two = 2 }, 2)
            end)
        end)

        it("Should throw when argument 2 returns something else than a boolean", function()
            assert.has.errors(function()
                m.allOf({ one = 1, two = 2 }, function()
                    return "Hello"
                end)
            end)
        end)
    end)

    it("Should call function with every tbl's elements", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }
        local passedKV = {}

        m.allOf(tbl, function(key, value)
            passedKV[key] = value
            return true
        end)
        assert.are.same(tbl, passedKV)
    end)

    it("Should return true if every function call returned true", function()
        assert.is.True(m.allOf({ one = 1, two = 2 }, function(_, _)
            return true
        end))
    end)

    it("Should return false if every function call returned false", function()
        assert.is.False(m.allOf({ one = 1, two = 2 }, function(_, _)
            return false
        end))
    end)

    it("Should return false if one of the function call returned false", function()
        assert.is.False(m.allOf({ one = 1, two = 2 }, function(_, value)
            return value ~= 2
        end))
    end)

    it("Should pass additional arguments has given to allOf", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }
        local additionalArg = { "Another", "additional", "argument" }

        m.allOf(tbl, function(_, _, fnAdditionalArg)
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
                m.anyOf({ one = 1, two = 2 })
            end)
        end)

        it("Should throw when argument 2 is not a function", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.anyOf({ one = 1, two = 2 }, 2)
            end)
        end)

        it("Should throw when argument 2 returns something else than a boolean", function()
            assert.has.errors(function()
                m.anyOf({ one = 1, two = 2 }, function()
                    return "Hello"
                end)
            end)
        end)
    end)

    it("Should call function with every tbl's elements", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }
        local passedKV = {}

        m.anyOf(tbl, function(key, value)
            passedKV[key] = value
            return false
        end)
        assert.are.same(tbl, passedKV)
    end)

    it("Should return true if every function call returned true", function()
        assert.is.True(m.anyOf({ one = 1, two = 2 }, function(_, _)
            return true
        end))
    end)

    it("Should return true if one of the function call returned true", function()
        assert.is.True(m.anyOf({ one = 1, two = 2 }, function(_, value)
            return value == 2
        end))
    end)

    it("Should return false if every function call returned false", function()
        assert.is.False(m.anyOf({ one = 1, two = 2 }, function(_)
            return false
        end))
    end)

    it("Should pass additional arguments has given to anyOf", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }
        local additionalArg = { "Another", "additional", "argument" }

        m.anyOf(tbl, function(_, _, fnAdditionalArg)
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
                m.noneOf({ one = 1, two = 2 })
            end)
        end)

        it("Should throw when argument 2 is not a function", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.noneOf({ one = 1, two = 2 }, 2)
            end)
        end)

        it("Should throw when argument 2 returns something else than a boolean", function()
            assert.has.errors(function()
                m.noneOf({ one = 1, two = 2 }, function()
                    return "Hello"
                end)
            end)
        end)
    end)

    it("Should call function with every tbl's elements", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }
        local passedKV = {}

        m.noneOf(tbl, function(key, value)
            passedKV[key] = value
            return false
        end)
        assert.are.same(tbl, passedKV)
    end)

    it("Should return true if every function call returned false", function()
        assert.is.True(m.noneOf({ one = 1, two = 2 }, function(_, _)
            return false
        end))
    end)

    it("Should return false if every function call returned true", function()
        assert.is.False(m.noneOf({ one = 1, two = 2 }, function(_, _)
            return true
        end))
    end)

    it("Should return false if one of the function call returned true", function()
        assert.is.False(m.noneOf({ one = 1, two = 2 }, function(_, value)
            return value == 2
        end))
    end)

    it("Should pass additional arguments has given to noneOf", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }
        local additionalArg = { "Another", "additional", "argument" }

        m.noneOf(tbl, function(_, _, fnAdditionalArg)
            assert.is.equal(additionalArg, fnAdditionalArg)
            return true
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
                m.forEach({ one = 1, two = 2 })
            end)
        end)

        it("Should throw when argument 2 is not a function", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.forEach({ one = 1, two = 2 }, 2)
            end)
        end)
    end)

    it("Should call function with every tbl's elements", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }
        local passedKV = {}

        m.forEach(tbl, function(key, value)
            passedKV[key] = value
        end)
        assert.are.same(tbl, passedKV)
    end)

    it("Should pass additional arguments has given to forEach", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }
        local additionalArg = { "Another", "additional", "argument" }

        m.forEach(tbl, function(_, _, fnAdditionalArg)
            assert.is.equal(additionalArg, fnAdditionalArg)
        end, additionalArg)
    end)
end)
