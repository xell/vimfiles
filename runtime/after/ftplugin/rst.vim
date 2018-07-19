
" Mappings {{{1
nnoremap <buffer> j gj
nnoremap <buffer> k gk

call xelltoolkit#imap('**', '*<++>*<++>', 1)
call xelltoolkit#imap('````', '``<++>``<++>', 1)
" }}}

" Folding {{{1
setlocal foldexpr=RSTLevel()
setlocal foldmethod=expr
setlocal foldlevel=99
function! RSTLevel() " {{{2
	if getline(v:lnum) =~ '^[^-= ].\+$' && getline(v:lnum+1) =~ '^=\+$'
		return ">1"
	endif
	if getline(v:lnum) =~ '^[^-= ].\+$' && getline(v:lnum+1) =~ '^-\+$'
		return ">2"
	endif
	if getline(v:lnum) =~ '^[^-= ].\+$' && getline(v:lnum+1) =~ '^\~\+$'
		return ">3"
	endif
	if getline(v:lnum) =~ '^[^-= ].\+$' && getline(v:lnum+1) =~ '^\^\+$'
		return ">4"
	endif

    return "="
endfunction "}}}
" }}}

" Conversion Wrapper {{{1
function! RstConvertBufferWrapper(out_type, config)

	if a:out_type == ''
		let out_type = 'html'
	else
		let out_type = a:out_type
	endif

	if a:config == ''
		let config = 'html'
	else
		let config = a:config
	endif

	" Only convert current buffer
	call RstConverter('', out_type, config, '')

endfunction
" }}}
