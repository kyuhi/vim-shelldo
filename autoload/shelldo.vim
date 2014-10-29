let g:shelldo_commands = get( g:, 'shelldo_commands', {} )


func! shelldo#do_command( command_name )

    " check command has keys.
    if !has_key( g:shelldo_commands, a:command_name )
        call s:echow( printf( 'shelldo invalid command: %s', a:command_name ) )
        return
    elseif !has_key( g:shelldo_commands[ a:command_name ], 'command' )
        call s:echow( 'shelldo key "command" could not find' )
        return
    elseif !has_key( g:shelldo_commands[ a:command_name ], 'exec_lines' )
        call s:echow( 'shelldo key "exec_lines" could not find' )
        return
    endif
    let command = g:shelldo_commands[ a:command_name ]

    " check command is function or string.
    if type( command.command ) == type( function('tr') )
        let cmd = command.command()
    elseif type( command.command ) == type( '' )
        let cmd = command.command
    else
        call s:echow( 'shelldo key "command" must be a function or string' )
        return
    endif

    " check exec_line is function
    if type( command.exec_lines ) != type( function( 'tr' ) )
        call s:echow( 'shelldo key "exec_lines" must be a function' )
        return
    endif

    " now execute the command.
    let results = systemlist( cmd )
    if type(results) == type('') && results == ''
        return
    endif
    call g:shelldo_commands[ a:command_name ].exec_lines( results )
    exec "normal! \<c-l>"
endfunc


func! shelldo#command_complete( arglead, cmdline, cursorpos )
    let predicate = printf( 'v:val =~ "%s"', a:arglead )
    return filter( keys( g:shelldo_commands ), predicate )
endfunc


func! s:echow( message )
    echohl WarningMsg | echomsg a:message | echohl None
endfunc
