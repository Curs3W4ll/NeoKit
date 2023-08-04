[![CI](https://github.com/Curs3W4ll/NeoKit/workflows/CI/badge.svg)](https://github.com/Curs3W4ll/NeoKit/actions)

# NeoKit

A standard module containing utility functions.  
Make your code more explicit and meaningful.

Note that this library is a bit useless outside of Neovim since some functions require Neovim functions. It should be usable with any recent version of Neovim though.

At the moment, this plugin is under construction. Expect changes to the way it is structured.

## Installation

Using [Vim plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'Curs3W4ll/neokit'
```

Using [Packer](https://github.com/wbthomason/packer.nvim):

```lua
use "Curs3W4ll/neokit"
```

Using [Lazy](https://github.com/folke/lazy.nvim):

```lua
require("lazy").setup({
    "Curs3W4ll/NeoKit",
})
```

## Usage

Use it like any Lua module

```lua
local neokit = require("neokit")

print(neokit.str.ensureLastChar("Hello", "!")) -- Hello!

-- OR

local str = require("neokit.str")

print(str.ensureLastChar("Hello", "!")) -- Hello!
```

## Modules

You can find more details about modules at https://curs3w4ll.github.io/NeoKit/

- [`neokit.array`](https://curs3w4ll.github.io/NeoKit/modules/array.html)
- [`neokit.fs`](https://curs3w4ll.github.io/NeoKit/modules/fs.html)
- [`neokit.str`](https://curs3w4ll.github.io/NeoKit/modules/str.html)
- [`neokit.table`](https://curs3w4ll.github.io/NeoKit/modules/table.html)
- [`neokit.vim`](https://curs3w4ll.github.io/NeoKit/modules/vim.html)

# Contributing

Help is welcome!  
You are encouraged to submit new issues and pull requests to improve this plugin.

Please read the [contribution guidelines](./CONTRIBUTING.md) first.

## Useful commands

To ease interactions with the project, you can use the project's Makefile.  
This Makefile defines a set of rules running commands for you.

You can execute `make help` to get more details about Makefile rules defined for the project.

With the Makefile, you can run tests, linter, formatter, and generate documentation...

## Run unit tests

You can use `make test` to run the project's unit test.  
Test files are located under the `tests/` directory.

Note that this will run every test of the project.  
If you want to run a specific test, you can run only one test file by defining the `TEST_FILE` argument.
```sh
make test TEST_FILE=arrray_spec.lua
```

## Watchers

To ease the unit tests development and the use of [TDD method](https://fr.wikipedia.org/wiki/Test_driven_development), 

> [!IMPORTANT]
> These watchers are available for UNIX users only.

There are currently two watchers, one to run the linter, and one to run unit tests.  
These watchers will execute the command again each time the code is modified.

```sh
make watch-lint
make watch-test
```

> [!NOTE]
> You can use the `TEST_FILE` argument with the watcher too

## Automatic workflows

Some things are automatically done by the Github workflow made for the project.

### Formatting

Each time new code is pushed on the `main` branch, the formatter will be launched automatically and the new version of the formatted code will be pushed.

### Documentation generation

Each time new code is pushed on the `main` branch, the workflow will automatically generate a new version of the HTML documentation and publish it [here](https://curs3w4ll.github.io/NeoKit/).

### Mandatory checks

Some checks (that are mandatory to merge a PR) are automatically done by workflow too.

Each time a new PR is created or updated, the workflow will automatically check if:
- Unit tests are passing
- Linter does not yell any warning
