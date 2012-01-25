
" let codepage = 'cp' . matchstr(system("chcp"), '\zs\d\+\ze[^[:graph:]]*$')
" ech iconv(system('dir'), codepage, 'utf-8')

" function! GetChar()
" 	let line = getline('.')
" 	let col = col('.') - 1
" 	return strpart(getline('.'), col('.') - 2, 1) =~? '\S'
" endfunction

" imap <buffer> <expr> <Tab> GetChar()

" dkjfkd dkfjjjjjjjda111aaaassf 01       dk afk
