
setlocal nowrap

nmap <buffer> <Tab> :call <SID>goto_next_word()<CR>
nmap <buffer> <S-Tab> :call <SID>goto_pre_word()<CR>
nmap <buffer> <Leader>Y :call <SID>checkout()<CR>
nmap <buffer> <Leader>y :call <SID>copyhash()<CR>

let s:hash = '\<[0-9a-f]\{6,40}\>'

function! s:search_link(direction)
	let match_line = search(s:hash, 's' . a:direction)
	if match_line == 0
		echomsg "There is no link to find!"
	endif
endfunction

function! s:goto_next_word()
	call s:search_link('')
endfunction

function! s:goto_pre_word()
	call s:search_link('b')
endfunction

function! s:checkout()
	let hash = expand('<cword>')
	if exists(":GitCheckout") == 2
		execute 'GitCheckout ' . hash
	else
		execute '!git checkout ' . hash
	endif
endfunction

function! s:copyhash()
	let @+ = expand('<cword>')
	echo "Copied " . @+
endfunction
