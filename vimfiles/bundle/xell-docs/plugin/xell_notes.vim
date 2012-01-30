" Author:   Xell Liu <xell DOT liu AT gmail.com>
" License:  Same terms as Vim itself (see :help license).
"

" Pre {{{1
if exists("g:loaded_xell_notes") || v:version < 700
  finish
endif
let g:loaded_xell_notes = 1

let s:savecpo = &cpo
set cpo&vim

" }}}

" Return the corresponding output html of specified note file {{{1
" See g:browser_open_rules
function! GetOutputHTML(file)
	let file = a:file
	let notes_root = xelltoolkit#fname2pattern(g:xell_notes_root)

	if file =~? notes_root
		let file_head_pattern = xelltoolkit#fname2pattern(xelltoolkit#fname_head(file))
		let html_file = substitute(file, file_head_pattern, g:xell_notes_ex_root, '')
		let html_file = xelltoolkit#fname_ext_mod(html_file, 'html')
	else
		let html_file = xelltoolkit#fname_ext_mod(file, 'html')
	endif

	if filereadable(html_file)
		return html_file
	else
		return ''
	endif

endfunction
" }}}

" Note taking {{{1
nmap <silent> <Leader>. :call <SID>note_taking()<CR>
function! s:note_taking() "{{{2
	let index_file = g:xell_notes_root . xelltoolkit#slash() . g:xell_notes_index . '.' . g:xell_notes_ext
	if filereadable(glob(index_file))
		execute 'e ' . index_file
	else
		call xelltoolkit#echo_msg("Index file doesn't exist. Please re-check.")
		return
	endif
endfunction "}}}

nmap <silent> <Leader>/ :call <SID>note_taking_temp()<CR>
function! s:note_taking_temp() "{{{2
	let temp_file = g:xell_notes_root . xelltoolkit#slash() . g:xell_notes_temp . '.' . g:xell_notes_ext
	if filereadable(glob(temp_file))
		execute 'e ' . temp_file
		normal G
	else
		call xelltoolkit#echo_msg("Temp file doesn't exist. Please re-check.")
		return
	endif
endfunction "}}}

nmap <silent> <Leader>p :execute 'e ' . g:xell_notes_root . xelltoolkit#slash() . 'plan.t2t'<CR>
" }}}

" TODO
" Index file {{{1
" In index file, use <CR> or <S-CR> to open files.
augroup xellNotesIndex
	autocmd!
	" Original setting
	" autocmd BufReadPost,FileReadPost index.t2t
	" 			\ nnoremap <buffer> <CR> :call <SID>goto_t2t_file(0)<CR> |
	" 			\ nnoremap <buffer> <S-CR> :call <SID>goto_t2t_file(1)<CR>
	exec 'autocmd BufReadPost,FileReadPost ' . g:xell_notes_index . '.' . g:xell_notes_ext . ' nnoremap <buffer> <CR> :call <SID>goto_t2t_file(0)<CR> | nnoremap <buffer> <S-CR> :call <SID>goto_t2t_file(1)<CR>'
augroup END

function! s:goto_t2t_file(openinnewwindow)
	let line_nr = line(".")
	call cursor(line_nr, 1)
	let match = search('\w\+\.t2t', '', line_nr)
	if match != 0
		if a:openinnewwindow == 1
			normal gf
		else
			execute 'e <cfile>'
		endif
	else
		normal j
	endif
endfunction
" }}}

" End {{{1
let &cpo = s:savecpo
unlet s:savecpo

" vim:fdm=marker
" }}}
