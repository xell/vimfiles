
setlocal nowrap

let b:hash_pattern = '\<[0-9a-f]\{6,40}\>'
nmap <buffer> <Tab> :call xelltoolkit#goto_next_word(b:hash_pattern)<CR>
nmap <buffer> <S-Tab> :call xelltoolkit#goto_pre_word(b:hash_pattern)<CR>

nmap <buffer> <expr> <Leader>Y <SID>checkout(xelltoolkit#get_word_at_cursor(b:hash_pattern))
nmap <buffer> <expr> <Leader>y xelltoolkit#get_copy(xelltoolkit#get_word_at_cursor(b:hash_pattern))


function! s:checkout(hash)
	if exists(":GitCheckout") == 2
		execute 'GitCheckout ' . a:hash
	else
		execute '!git checkout ' . a:hash
	endif
endfunction

