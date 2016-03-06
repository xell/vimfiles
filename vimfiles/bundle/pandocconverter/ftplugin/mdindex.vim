" Markdown index filetype plugin
" Language:	Mdindex
" Maintainer:	Xell Liu

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

command! -buffer -nargs=0 PandocIndex :call PandocConverterIndex()
nmap <buffer> <Leader>/ :PandocIndex<CR>

function! PandocConverterIndex()
    let file_head = expand('%:p:h')
    let file_content = readfile(expand('%:p'))

    let profile = ''

    " combine the files into list output
    let output_fname = 'bind_' . localtime()
    let output_fname_full = file_head . '/' . output_fname . '.md'
    let target_ext = ''
    let output = []
    " block
    call extend(output, file_content[0:3])
    call add(output, '')

    let line_num = 4
    let end_num = len(file_content)
    while(line_num < end_num)
        let cur = file_content[line_num]
        if cur =~? '^@'
            let profile = matchstr(cur, '@\s\+\zs[^ ]\+\ze')
            let target_ext = xelltoolkit#fname_ext(profile)
        elseif cur =~? '^<<'
            " including file
            call extend(output, readfile(file_head . '/' . matchstr(cur, '<<\[\zs[^]]\+\ze\]')))
            call add(output, '')
        endif

        let line_num += 1
    endwhile

    if profile == ''
        call xelltoolkit#echo_msg("No profile!")
        return
    endif

    call writefile(output, output_fname_full)
    let target = PandocConverter(output_fname_full, profile)[0]
    if delete(output_fname_full) != 0
        call xelltoolkit#echo_msg("Cannot delete combined middle file!")
        return
    endif
    if target == -1
        call xelltoolkit#echo_msg("Wrong profile and/or config!")
        return
    elseif target == -2
        call xelltoolkit#echo_msg("Cannot delete tmp middle file.")
        return
    endif
    let final_fname = expand('%:t:r') . '.' . target_ext
    if rename(target, file_head . '/' . final_fname) == 0
        echo "Generated [" . xelltoolkit#fname_name(profile) . '] ' . final_fname
    else
        call xelltoolkit#echo_msg('Cannot rename converted middle file.')
        return
    endif
endfunction

" Don't load another plugin for this buffer
let b:did_ftplugin = 1


