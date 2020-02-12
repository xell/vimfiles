
command -buffer -nargs=0 RebuildProxyGroup call <SID>rebuild_proxy_group()

function s:rebuild_proxy_group()
    " Stop when not saved
    if &modified
        echoerr 'Please save file!'
        return
    endif
    let config_file = expand('%:p')
    " Stop when not clashx config
    if config_file !~? '\.config\/clash'
        echoerr 'Only for clash config files!'
        return
    endif

    let file = readfile(config_file)

    " Read Proxy names
    let server_list = []
    let server_auto_list = []
    for line in file
        " Only if Proxy Group: is AFTER Proxy:
        if line =~? '^Proxy Group:[^:]*$'
            break
        endif
        if line =~? '^\s*-\s*{\s*name:\s*"'
            call add(server_list, '"' . matchstr(line, 'name:\s*"\zs[^"]\+\ze"'). '"')
            if match(line, '# AUTO') + 1
                call add(server_auto_list, '"' . matchstr(line, 'name:\s*"\zs[^"]\+\ze"') . '"')
            endif
        endif
    endfor

    " Write to Proxy Group
    let index = 0
    let stop_flag = 3
    while stop_flag
        if file[index] =~? 'type: url-test'
            let newline = '- { name: "auto", type: url-test, proxies: ['
            let newline .= join(server_auto_list, ', ')
            let newline .= '], url: "http://www.gstatic.com/generate_204", interval: 300 }'
            let file[index] = newline
            let stop_flag -= 1
        endif

        if file[index] =~? 'type: fallback'
            let newline = '- { name: "fallback-auto", type: fallback, proxies: ['
            let newline .= join(server_auto_list, ', ')
            let newline .= '], url: "http://www.gstatic.com/generate_204", interval: 300 }'
            let file[index] = newline
            let stop_flag -= 1
        endif

        if file[index] =~? 'type: select' && file[index] !~# 'Switch'
            let newline = '- { name: "Proxy", type: select, proxies: ['
            let newline .= join(server_list, ', ')
            let newline .= ', "auto"] }'
            let file[index] = newline
            let stop_flag -= 1
        endif

        let index += 1
    endwhile

    call writefile(file, config_file)
endfunction

