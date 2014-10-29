let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_shelldo')
    finish
endif

command! -nargs=1 -complete=customlist,shelldo#command_complete
    \ Shelldo call shelldo#do_command( <f-args> )

let g:loaded_shelldo = 1

let &cpo = s:save_cpo
unlet s:save_cpo
