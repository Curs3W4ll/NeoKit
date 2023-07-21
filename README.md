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

## Modules

- `neokit.str`
- `neokit.array`
- `neokit.table`
