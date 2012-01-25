
" let codepage = 'cp' . matchstr(system("chcp"), '\zs\d\+\ze[^[:graph:]]*$')
" ech iconv(system('dir'), codepage, 'utf-8')

let s:a = 0

if s:a
	command! TestCommand call TestFunction()

	function! TestFunction()
		echo "test"
	endfunction
endif
