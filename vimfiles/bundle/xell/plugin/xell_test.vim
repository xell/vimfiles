
function! Testcj()
	let isfound = search('<++>', 'cW')
	if isfound
		if col('.') == col('$') - 4
			normal 4x
			startinsert!
		else
			normal 4x
			startinsert
		endif
	endif
endfunction

" inoremap <C-j> <Esc>:call Testcj()<CR>

function! Testimap(lhs, rhs, buffer)
	let lhs = a:lhs
	let rhs = a:rhs
	
	let num_of_left = strlen(rhs) - match(rhs, '<++>', 0) - 5
	let rhs = substitute(a:rhs, '<++>', '', '')
	
	exec 'inoremap ' . lhs . ' ' . rhs . '<C-O>' . num_of_left . 'h'
	

endfunction

" call Testimap('[]', 'dakajdkf[<++>]<++>', 0)

" [] dkjfdk
" dakajdkf[dkjdfk]
"
"
