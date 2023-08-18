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

describe("[getContrastColor]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.getContrastColor()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.getContrastColor(2)
            end)
        end)

        it("Should throw when argument 1 does not start with a #", function()
            assert.has.errors(function()
                m.getContrastColor("123")
            end)
        end)

        it("Should throw when argument 1 does not contains 6 color char", function()
            assert.has.errors(function()
                m.getContrastColor("#13f")
            end)
        end)

        it("Should throw when argument 1 contains an invalid character", function()
            assert.has.errors(function()
                m.getContrastColor("#123fxf")
            end)
        end)
    end)

    it("Should return 'light' for dark colors | test 1", function()
        assert.are.same("light", m.getContrastColor("#4d3432"))
    end)

    it("Should return 'light' for dark colors | test 2", function()
        assert.are.same("light", m.getContrastColor("#2f1769"))
    end)

    it("Should return 'light' for dark colors | test 3", function()
        assert.are.same("light", m.getContrastColor("#800f33"))
    end)

    it("Should return 'light' for black", function()
        assert.are.same("light", m.getContrastColor("#000000"))
    end)

    it("Should return 'dark' for light colors | test 1", function()
        assert.are.same("dark", m.getContrastColor("#e0a060"))
    end)

    it("Should return 'dark' for light colors | test 2", function()
        assert.are.same("dark", m.getContrastColor("#c7a5b0"))
    end)

    it("Should return 'dark' for light colors | test 3", function()
        assert.are.same("dark", m.getContrastColor("#79c79b"))
    end)

    it("Should return 'dark' for white", function()
        assert.are.same("dark", m.getContrastColor("#ffffff"))
    end)
end)
