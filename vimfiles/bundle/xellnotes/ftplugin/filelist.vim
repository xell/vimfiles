" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

set fenc=utf8

nnoremap <silent> <buffer> <Return> :call <SID>edit_file(0)<CR>
nnoremap <silent> <buffer> <S-CR> :call <SID>edit_file(1)<CR>
" Edit file {{{1
function! s:edit_file(openinnewtab)
	let line = getline('.')
    " exclude :#" and empty lines
    if line =~ '^[:#"]' || line =~ '^[ ]*$'
        return
    endif

    " escape blankspace
    let filename = substitute(line, '\([^\\]\) ', '\1\\ ', 'g')

    " search for the path, i.e. the line started with :
    let i = getpos('.')[1] - 1
    while i >= 1
        if getline(i) =~ '^[:]'
            " ignore if there is / in the end of the path
            let filename = substitute(strpart(getline(i), 1), '\/$', '', 'g') . '/' . filename
            break
        else
            let i -= 1
        endif
    endwhile

    " if there is no path defined
    if i == 0
        call xelltoolkit#echo_msg("There is no path defined!")
        return
    endif

    " if the file does not exist
	if glob(filename) == ''
        call xelltoolkit#echo_msg("There is no such file: " . filename)
        return
	endif

	if a:openinnewtab
		exec 'tabedit ' . filename
	else
		exec 'edit ' . filename
	endif

endfunction
" }}}

