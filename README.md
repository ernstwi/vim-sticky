# vim-sticky

This Vim plugin remembers the state of a user-defined set of "sticky" options between launches. When a sticky option is changed interactively (eg `:set number`) its state is saved, to be restored the next time Vim is launched.

This is meant to be used as a lightweight way to toggle options you change a lot, as an alternative to editing your vimrc.

## Configuration

Sticky options are configured by setting `g:sticky_all` to a list of (long) option names. Besides option names, the string `colorscheme` can also be in this list.

```vim
let g:sticky_all = ['cursorline', 'breakindent', 'colorscheme']
```

Different sticky options may be set for terminal and gui Vim.

```vim
" Make number sticky in terminal
let g:sticky_term = ['number']

" Make number and guifont sticky in gui
let g:sticky_gui = ['number', 'guifont']

" Make cursorline and breakindent sticky across both terminal and gui
let g:sticky_all = ['cursorline', 'breakindent']
```

Note that `number` is in both `g:sticky_term` and `g:sticky_gui`. This means that the option will stick in both terminal and gui Vim, but may be set to a different value in each mode. If `number` was instead in `g:sticky_all`, a single state would be shared between terminal and gui.

After installing and configuring the plugin, you might want to manually `:source ~/.vimrc` to populate the plugin's data store with settings from your vimrc.

## Similar plugins

- [AutoSaveSetting](https://www.vim.org/scripts/script.php?script_id=3626) by Kien Nguyen
