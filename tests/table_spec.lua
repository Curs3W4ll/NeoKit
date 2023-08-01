local m = require("neokit/table")

describe("[concat]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function() m.concat() end)
        end)

        it("Should throw when argument 1 is not a table", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.concat(2) end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function() m.concat({ 1, 2 }) end)
        end)

        it("Should throw when argument 2 is not a table", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.concat({ 1, 2 }, 2) end)
        end)

        -- Argument 3
        it("Should throw when argument 3 is not a boolean", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.concat({ 1, 2 }, { 3, 4 }, 2) end)
        end)
    end)

    it("Should return an empty table if both arguments are empty", function()
        local result = m.concat({}, {})

        assert.are.same(result, {})
    end)

    it("Should return tbl1 if tbl2 is empty", function()
        local tbl1 = {
            one = 1,
            two = 2,
        }
        local result = m.concat(tbl1, {})

        assert.are.same(result, tbl1)
    end)

    it("Should return tbl2 if tbl1 is empty", function()
        local tbl2 = {
            one = 1,
            two = 2,
        }
        local result = m.concat({}, tbl2)

        assert.are.same(result, tbl2)
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

        assert.are.same(result, expected)
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

        assert.are.same(result, expected)
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

        assert.are.same(result, expected)
    end)
end)

describe("[contains]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function() m.contains() end)
        end)

        it("Should throw when argument 1 is not a table", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.contains(2) end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function() m.contains({ 1, 2 }) end)
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
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function() m.find() end)
        end)

        it("Should throw when argument 1 is not a table", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.find(2) end)
        end)

        -- Argument 2
        it("Should throw when argument 2 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function() m.find({ 1, 2 }) end)
        end)
    end)

    it("Should return the key if tbl contains value", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }

        assert.are.same(m.find(tbl, 2), "two")
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
        assert.are.same(tbl[result], 1)
    end)

    it("Should return the key if tbl contains value at start", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }

        assert.are.same(m.find(tbl, 1), "one")
    end)

    it("Should return the key if tbl contains value at last", function()
        local tbl = {
            one = 1,
            two = 2,
            three = 3,
        }

        assert.are.same(m.find(tbl, 3), "three")
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
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function() m.copy() end)
        end)

        it("Should throw when argument 1 is not a table", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.copy(2) end)
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
        assert.are.same(tbl, {
            one = 1,
            two = 2,
            three = 3,
        })
    end)
end)
