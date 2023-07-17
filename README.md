# NeoKit

A standard module containing utility functions.

Note that this library is a bit useless outside of Neovim since some functions require Neovim functions. It should be usable with any recent version of Neovim though.

At the moment, this plugin is under construction. Expect changes to the way it is structured.

## Installation

Using [vim plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'Curs3W4ll/neokit'
```

Using [packer](https://github.com/wbthomason/packer.nvim):

```lua
use "Curs3W4ll/neokit"
```

Using [lazy](https://github.com/folke/lazy.nvim):

```lua
require("lazy").setup({
    "Curs3W4ll/NeoKit",
})
```

## Modules

- `neokit.str`
- `neokit.array`
