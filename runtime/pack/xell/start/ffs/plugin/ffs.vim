" Author:   Xell Liu <xell DOT liu AT gmail.com>
" License:  Same terms as Vim itself (see :help license).
" Fast File Search

" Pre {{{1
if exists("g:loaded_xell_ffs") || v:version < 700
  finish
endif
let g:loaded_xell_ffs = 1
" }}}

function! FFS()
    exec 'cd' expand('%:p:h')
	let t:ffs_start_path = expand("%:p:h")
    let t:cur_winnr = winnr()
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
