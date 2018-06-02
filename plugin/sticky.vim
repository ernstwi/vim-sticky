if !exists('g:sticky_all')
    let g:sticky_all = []
endif

if !exists('g:sticky_gui')
    let g:sticky_gui = []
endif

if !exists('g:sticky_term')
    let g:sticky_term = []
endif

let s:db_path = expand('<sfile>:p:h') . '/sticky_data.vim'

if !exists('g:sticky_data')
    if filereadable(s:db_path)
        execute 'source' s:db_path
    else
        let g:sticky_data = {'all': {}, 'gui': {}, 'term': {}}
    endif
endif

function! s:load_from_file(mode, options)
    for [option, value] in items(g:sticky_data[a:mode])
        if index(a:options, option) == -1 " Option no longer in g:sticky_*
            call remove(g:sticky_data[a:mode], option) " Remove from dictionary
            call writefile(['let g:sticky_data = ' . string(g:sticky_data)], s:db_path)
        elseif option == 'colorscheme'
            execute 'noautocmd colorscheme' value
        else
            try
                execute 'noautocmd set' option . '=' . fnameescape(value)
            catch 474 " Invalid argument -> Boolean option
                if value == 0
                    execute 'noautocmd set no' . option
                else
                    call assert_equal(1, value)
                    execute 'noautocmd set' option
                endif
            endtry
        endif
    endfor
endfunction

function! s:set_autocmds(mode, options)
    for option in a:options
        if option == 'colorscheme'
            execute
                \ "autocmd! ColorScheme * call s:stick('" . a:mode . "',"
                \ "'colorscheme', expand('<amatch>'))"
        else
            execute
                \ "autocmd! OptionSet" option "if v:option_type == 'global' |"
                \ "call s:stick('" . a:mode . "', expand('<amatch>'), v:option_new) |"
                \ "endif"
        endif
    endfor
endfunction

function! s:stick(mode, option, value)
    let g:sticky_data[a:mode][a:option] = a:value
    call writefile(['let g:sticky_data = ' . string(g:sticky_data)], s:db_path)
endfunction

augroup sticky
    autocmd!
    call s:load_from_file('all', g:sticky_all)
    call s:set_autocmds('all', g:sticky_all)
    if has("gui_running")
        call s:load_from_file('gui', g:sticky_gui)
        call s:set_autocmds('gui', g:sticky_gui)
    else
        call s:load_from_file('term', g:sticky_term)
        call s:set_autocmds('term', g:sticky_term)
    endif
augroup END
