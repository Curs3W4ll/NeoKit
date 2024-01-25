local m = require("neokit/fs")

describe("[directoryExists]:", function()
    local test_path = "/tmp/neokit.test.directory"

    before_each(function()
        os.execute("rm -rf " .. test_path)
    end)

    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.directoryExists()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.directoryExists(2)
            end)
        end)
    end)

    -- True cases
    it("Should return true when path is an empty directory", function()
        os.execute("mkdir -p " .. test_path)

        assert.is.True(m.directoryExists(test_path))
    end)

    it("Should return true when path is a non-empty directory", function()
        os.execute("mkdir -p " .. test_path)
        os.execute("touch " .. test_path .. "/test.file")

        assert.is.True(m.directoryExists(test_path))
    end)

    -- False cases
    it("Should return false when path does not exist", function()
        assert.is.False(m.directoryExists(test_path))
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
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.fileExists()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.fileExists(2)
            end)
        end)

        -- Argument 2
        it("Should not throw when argument 2 is not given", function()
            assert.Not.has.errors(function()
                m.fileExists("Hello world!")
            end)
        end)

        it("Should throw when argument 2 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.fileExists("Hello world!", 2)
            end)
        end)
    end)

    -- True cases | 1 argument
    it("Should return true when path is an empty file", function()
        os.execute("mkdir -p " .. test_path)
        os.execute("touch " .. test_filepath)

        assert.is.True(m.fileExists(test_filepath))
    end)

    it("Should return true when path is a non-empty file", function()
        os.execute("mkdir -p " .. test_path)
        os.execute("touch " .. test_filepath)
        os.execute("echo Hello world > " .. test_filepath)

        assert.is.True(m.fileExists(test_filepath))
    end)

    -- True cases | 2 arguments
    it("Should return true when filename is an empty file in path", function()
        os.execute("mkdir -p " .. test_path)
        os.execute("touch " .. test_filepath)

        assert.is.True(m.fileExists(test_path, test_file))
    end)

    it("Should return true when filename is a non-empty file in path", function()
        os.execute("mkdir -p " .. test_path)
        os.execute("touch " .. test_filepath)
        os.execute("echo Hello world > " .. test_filepath)

        assert.is.True(m.fileExists(test_path, test_file))
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
        assert.has.errors(function()
            m.fileExists("/tmp/adfafhasfihefafeaf/adsfasddfaf", test_file)
        end)
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
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.ensureDirectory()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.ensureDirectory(2)
            end)
        end)
    end)

    -- True cases
    it("Should create a directory when it does not exists", function()
        assert.is.True(m.ensureDirectory(test_path))
        assert.is.True(m.directoryExists(test_path))
    end)

    it("Should do nothing when the directory already exists", function()
        os.execute("mkdir -p " .. test_path)

        assert.is.True(m.ensureDirectory(test_path))
        assert.is.True(m.directoryExists(test_path))
    end)

    it("Should create needed parent directory(ies)", function()
        local childTest = "/another/dir"
        assert.is.True(m.ensureDirectory(test_path .. childTest))
        assert.is.True(m.directoryExists(test_path .. childTest))
    end)

    -- False cases
    it("Should return false when path is already a file", function()
        os.execute("touch " .. test_path)

        assert.False(m.ensureDirectory(test_path))
        assert.is.True(m.fileExists(test_path))
    end)

    -- Clear
    os.execute("rm -rf " .. test_path)
end)

describe("[shortenPath]:", function()
    describe("(arguments)", function()
        -- Argument 1
        it("Should throw when argument 1 is not given", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.shortenPath()
            end)
        end)

        it("Should throw when argument 1 is not a string", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.shortenPath(2)
            end)
        end)

        -- Argument 2
        it("Should not throw when argument 2 is not given", function()
            assert.has.Not.errors(function()
                ---@diagnostic disable-next-line: missing-parameter
                m.shortenPath("/tmp/path")
            end)
        end)

        it("Should throw when argument 2 is not a table", function()
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.shortenPath("/tmp/path", "opts")
            end)
            assert.has.errors(function()
                ---@diagnostic disable-next-line: param-type-mismatch
                m.shortenPath("/tmp/path", 2)
            end)
        end)

        -- Opts
        it("Should throw when opts.len is less than 1", function()
            assert.Not.has.errors(function()
                m.shortenPath("/tmp/path", { len = 5 })
            end)
            assert.has.errors(function()
                m.shortenPath("/tmp/path", { len = 0 })
            end)
            assert.has.errors(function()
                m.shortenPath("/tmp/path", { len = -1 })
            end)
            assert.has.errors(function()
                m.shortenPath("/tmp/path", { len = -10 })
            end)
        end)

        it("Should throw when opts.tail is less than 0", function()
            assert.Not.has.errors(function()
                m.shortenPath("/tmp/path", { tail = 5 })
            end)
            assert.has.errors(function()
                m.shortenPath("/tmp/path", { tail = -1 })
            end)
            assert.has.errors(function()
                m.shortenPath("/tmp/path", { tail = -10 })
            end)
        end)

        it("Should not throw when opts.tail is equals to 0", function()
            assert.Not.has.errors(function()
                m.shortenPath("/tmp/path", { tail = 0 })
            end)
        end)

        it("Should throw when opts.maxComponents is less than 2", function()
            assert.has.errors(function()
                m.shortenPath("/tmp/path", { maxComponents = -5 })
            end)
            assert.has.errors(function()
                m.shortenPath("/tmp/path", { maxComponents = 1 })
            end)
            assert.Not.has.errors(function()
                m.shortenPath("/tmp/path", { maxComponents = 5 })
            end)
        end)

        it("Should not throw when opts.maxComponents is equal to 0", function()
            assert.Not.has.errors(function()
                m.shortenPath("/tmp/path", { maxComponents = 0 })
            end)
        end)

        it("Should throw when opts.maxLength is negative", function()
            assert.has.errors(function()
                m.shortenPath("/tmp/path", { maxLength = -5 })
            end)
            assert.has.errors(function()
                m.shortenPath("/tmp/path", { maxLength = -1 })
            end)

            assert.Not.has.errors(function()
                m.shortenPath("/tmp/path", { maxLength = 1 })
            end)
        end)

        it("Should not throw when opts.maxLength is 0", function()
            assert.Not.has.errors(function()
                m.shortenPath("/tmp/path", { maxLength = 0 })
            end)
        end)
    end)

    it("Should return a shorter version of the path", function()
        assert.are.same("/a/b/myfile", m.shortenPath("/adir/bdir/myfile"))

        assert.are.same("/t/a/b/c/myfile", m.shortenPath("/tmp/adir/bdir/cdir/myfile"))
    end)

    it("Should limit the size of the components before tail when giving opts.len = 2", function()
        local opts = {
            len = 2,
        }
        assert.are.same("/ad/bd/myfile", m.shortenPath("/adir/bdir/myfile", opts))

        opts.len = 3
        assert.are.same("/tmp/adi/bdi/cdi/myfile", m.shortenPath("/tmp/adir/bdir/cdir/myfile", opts))
    end)

    it("Should left components untouched when len is above the components length", function()
        local opts = {
            len = 10,
        }
        assert.are.same("/adir/bdir/myfile", m.shortenPath("/adir/bdir/myfile", opts))
    end)

    it(
        "Should return a shorter version of the path with the last two components unedited when giving opts.tail = 2",
        function()
            local opts = {
                tail = 2,
            }
            assert.are.same("/a/bdir/myfile", m.shortenPath("/adir/bdir/myfile", opts))

            assert.are.same("/t/a/b/cdir/myfile", m.shortenPath("/tmp/adir/bdir/cdir/myfile", opts))
        end
    )

    it("Should trim 2-n components when components number is greater than maxComponents", function()
        local opts = {
            maxComponents = 2,
        }
        assert.are.same("/a/…/myfile", m.shortenPath("/a/bdir/myfile", opts))

        assert.are.same("/a/…/myfile", m.shortenPath("/a/bdir/cdir/ddir/myfile", opts))

        opts.maxComponents = 3
        assert.are.same("/a/…/d/myfile", m.shortenPath("/a/bdir/cdir/ddir/myfile", opts))
    end)

    it("Should compress only needed components when specifying a length limit", function()
        local opts = {
            maxLength = 23,
            tail = 2,
            len = 3,
        }
        assert.are.same("/roo/…/a/lot/of/nodes", m.shortenPath("/root/really/long/path/with/a/lot/of/nodes", opts))

        opts.maxLength = 18
        assert.are.same("/pat/…/super/file", m.shortenPath("/path/to/my/super/file", opts))

        opts.maxLength = 12
        assert.are.same("/pat/…/file", m.shortenPath("/path/to/my/file", opts))

        opts.maxLength = 0
        assert.are.same("/pat/to/my/file", m.shortenPath("/path/to/my/file", opts))

        opts.maxComponents = 3
        assert.are.same("/pat/…/my/file", m.shortenPath("/path/to/my/file", opts))
    end)
end)
