" Author:   Xell Liu <xell DOT liu AT gmail.com>
" License:  Same terms as Vim itself (see :help license).
" Fast File Search

" Pre {{{1
if exists("g:loaded_xell_ffs") || v:version < 700
  finish
endif
let g:loaded_xell_ffs = 1
" }}}

nmap <Leader><Leader><Leader> :call FFS()<CR>
let g:ffs_forbiden_path = ['/Users/xell', '/Users/xell/Library', '/Users/xell/Codes', '/Applications', '/Library', '/P', '/P/apps']

function! FFS()
	let t:ffs_start_path = expand("%:p:h")
	for forbiden_path in g:ffs_forbiden_path
		if t:ffs_start_path ==? forbiden_path
			call xelltoolkit#echo_msg("You cannot perform recursive, non-restrict search in " . forbiden_path)
			return
		endif
	endfor
	topleft new
	silent! file ffs
	resize 1
	set filetype=ffs
	startinsert
	call feedkeys("\<C-x>\<C-o>\<C-p>", 'n')
endfunction

" End {{{1
" vim:fdm=marker
" }}}
