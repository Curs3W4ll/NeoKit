local m = require("neokit/fs")

describe("[directoryExists]:", function()
    local test_path = "/tmp/neokit.test.directory"

    before_each(function()
        os.execute("rm -rf " .. test_path)
    end)

    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function() m.directoryExists() end)
        end)

        it("Should throw when argument 1 is not a string", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.directoryExists(2) end)
        end)
    end)

    -- True cases
    it("Should return true when path is an empty directory", function()
        os.execute("mkdir -p " .. test_path)

        assert.True(m.directoryExists(test_path))
    end)

    it("Should return true when path is a non-empty directory", function()
        os.execute("mkdir -p " .. test_path)
        os.execute("touch " .. test_path .. "/test.file")

        assert.True(m.directoryExists(test_path))
    end)

    -- False cases
    it("Should return false when path does not exist", function()
        assert.False(m.directoryExists(test_path))
    end)

    it("Should return false when path is a file", function()
        os.execute("touch " .. test_path)
        assert.False(m.directoryExists(test_path))
    end)

    -- Clear
    os.execute("rm -rf " .. test_path)
end)

describe("[fileExists]:", function()
    local test_file = "neokit.test.file"
    local test_path = "/tmp/neokit.test.directory"
    local test_filepath = test_path .. "/" .. test_file

    before_each(function()
        os.execute("rm -rf " .. test_path)
    end)

    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function() m.fileExists() end)
        end)

        it("Should throw when argument 1 is not a string", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.fileExists(2) end)
        end)

        -- Argument 2
        it("Should not throw when argument 2 is not given", function()
            assert.Not.has.errors(function() m.fileExists("Hello world!") end)
        end)

        it("Should throw when argument 2 is not a string", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.fileExists("Hello world!", 2) end)
        end)
    end)

    -- True cases | 1 argument
    it("Should return true when path is an empty file", function()
        os.execute("mkdir -p " .. test_path)
        os.execute("touch " .. test_filepath)

        assert.True(m.fileExists(test_filepath))
    end)

    it("Should return true when path is a non-empty file", function()
        os.execute("mkdir -p " .. test_path)
        os.execute("touch " .. test_filepath)
        os.execute("echo Hello world > " .. test_filepath)

        assert.True(m.fileExists(test_filepath))
    end)

    -- True cases | 2 arguments
    it("Should return true when filename is an empty file in path", function()
        os.execute("mkdir -p " .. test_path)
        os.execute("touch " .. test_filepath)

        assert.True(m.fileExists(test_path, test_file))
    end)

    it("Should return true when filename is a non-empty file in path", function()
        os.execute("mkdir -p " .. test_path)
        os.execute("touch " .. test_filepath)
        os.execute("echo Hello world > " .. test_filepath)

        assert.True(m.fileExists(test_path, test_file))
    end)

    -- False cases | 1 argument
    it("Should return false when path does not exist", function()
        assert.False(m.fileExists(test_filepath))
    end)

    it("Should return false when path is a directory", function()
        os.execute("mkdir -p " .. test_filepath)
        assert.False(m.fileExists(test_filepath))
    end)

    -- False cases | 2 arguments
    it("Should throw when path does not exist", function()
        assert.has.errors(function() m.fileExists("/tmp/adfafhasfihefafeaf/adsfasddfaf", test_file) end)
    end)

    it("Should return false when filename does not exists in path", function()
        os.execute("mkdir -p " .. test_path)
        os.execute("touch " .. test_path .. "/this.is.another.file")

        assert.False(m.fileExists(test_path, test_file))
    end)

    it("Should return false when filename is a directory in path", function()
        os.execute("mkdir -p " .. test_filepath)

        assert.False(m.fileExists(test_path, test_file))
        os.execute("touch /tmp/test.lolilol")
    end)

    -- Clear
    os.execute("rm -rf " .. test_path)
end)

describe("[ensureDirectory]:", function()
    local test_path = "/tmp/neokit.test.directory"

    before_each(function()
        os.execute("rm -rf " .. test_path)
    end)

    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            ---@diagnostic disable-next-line: missing-parameter
            assert.has.errors(function() m.ensureDirectory() end)
        end)

        it("Should throw when argument 1 is not a string", function()
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            assert.has.errors(function() m.ensureDirectory(2) end)
        end)
    end)

    -- True cases
    it("Should create a directory when it does not exists", function()
        assert.True(m.ensureDirectory(test_path))
        assert.True(m.directoryExists(test_path))
    end)

    it("Should do nothing when the directory already exists", function()
        os.execute("mkdir -p " .. test_path)

        assert.True(m.ensureDirectory(test_path))
        assert.True(m.directoryExists(test_path))
    end)

    it("Should create needed parent directory(ies)", function()
        local childTest = "/another/dir"
        assert.True(m.ensureDirectory(test_path .. childTest))
        assert.True(m.directoryExists(test_path .. childTest))
    end)

    -- False cases
    it("Should return false when path is already a file", function()
        os.execute("touch " .. test_path)

        assert.False(m.ensureDirectory(test_path))
        assert.True(m.fileExists(test_path))
    end)

    -- Clear
    os.execute("rm -rf " .. test_path)
end)
