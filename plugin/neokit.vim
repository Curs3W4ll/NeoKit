" Title:        NeoKit
" Description:  A standard module containing utility functions.
" Maintainer:   Curs3W4ll <https://github.com/Curs3W4ll>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_neokit")
    finish
endif
let g:loaded_neokit = 1
