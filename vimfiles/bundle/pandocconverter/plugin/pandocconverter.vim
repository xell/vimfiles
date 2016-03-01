" Author:   Xell Liu <xell DOT liu AT gmail.com>
" License:  Same terms as Vim itself (see :help license).
"

" Pre {{{1
if exists("g:loaded_pandoc_converter") || v:version < 700
  finish
endif
let g:loaded_pandoc_converter = 1

let s:savecpo = &cpo
set cpo&vim
" }}}

command! -nargs=* Pandoc :call PandocConverter(<f-args>)
let s:target_profile_default = 'normal'
let s:pandoc_config_file = '/Users/xell/.pandoc/pdconfig'

function! PandocConverter(...) " {{{1
    let input_type = &ft

    " Check if it's supported
    let runnable = 0
    let g:pandocconverter_scope = ['pandoc', 'markdown']
    if match(g:pandocconverter_scope, input_type) == -1
        call xelltoolkit#echo_msg("Pandoc doesn't support this filetype!")
        return
    endif

    " Read the profile
    if a:0 == 0
        let target_profile = s:target_profile_default
    elseif a:0 == 1
        let target_profile = a:1
    else
        call xelltoolkit#echo_msg("Too many args!")
        return
    endif
    let [pandoc_options, pandoc_target_ext] = s:read_profile(target_profile)
    if pandoc_options == -1
        call xelltoolkit#echo_msg("PDCONFIG is broken!")
        return
    elseif pandoc_options == ''
        call xelltoolkit#echo_msg("Profile is empty!")
        return
    endif
    call xelltoolkit#system('pandoc ' . pandoc_options . '-o "' . expand('%:p:r') . '.' . pandoc_target_ext . '" "' . expand('%:p') . '"')
endfunction

function! s:read_profile(profile)
    let pandoc_config = readfile(s:pandoc_config_file)
    let pandoc_options = ''
    let pandoc_target_ext = ''

    " check if there's the profile AND the ext
    let profile_linenum = match(pandoc_config, '^\[' . a:profile . '\.[^ ]\+\]')
    if profile_linenum == -1
        return [-1, '']
    endif

    let pandoc_target_ext = matchstr(pandoc_config[profile_linenum], '\.\zs[^ ]\+\ze\]')
	let end = len(pandoc_config)
    let line_num = profile_linenum + 1
    while(line_num < end)
        let line_content = pandoc_config[line_num]
        if line_content =~? '^\['
            break
        endif
        if line_content =~? '^#'
            let line_num = line_num + 1
            continue
        endif
        let pandoc_options .= pandoc_config[line_num] . ' '
        let line_num = line_num + 1
    endwhile

    return [pandoc_options, pandoc_target_ext]
endfunction

" End {{{1
let &cpo = s:savecpo
unlet s:savecpo
" vim:fdm=marker
" }}}
