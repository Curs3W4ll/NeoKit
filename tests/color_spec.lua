local m = require("neokit/color")

describe("[hexToRGB]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.hexToRGB()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.hexToRGB(2)
            end)
        end)

        it("Should throw when argument 1 does not start with a #", function()
            assert.has.errors(function()
                m.hexToRGB("123")
            end)
        end)

        it("Should throw when argument 1 does not contains 6 color char", function()
            assert.has.errors(function()
                m.hexToRGB("#13f")
            end)
        end)

        it("Should throw when argument 1 contains an invalid character", function()
            assert.has.errors(function()
                m.hexToRGB("#123fxf")
            end)
        end)
    end)

    it("Should return correct rgb colors when giving an hexadecimal one | test 1", function()
        assert.are.same({ r = 50, g = 168, b = 82 }, m.hexToRGB("#32a852"))
    end)

    it("Should return correct rgb colors when giving an hexadecimal one | test 2", function()
        assert.are.same({ r = 136, g = 103, b = 201 }, m.hexToRGB("#8867c9"))
    end)

    it("Should return correct rgb colors when giving an hexadecimal one | test 3", function()
        assert.are.same({ r = 189, g = 83, b = 57 }, m.hexToRGB("#bd5339"))
    end)
end)
