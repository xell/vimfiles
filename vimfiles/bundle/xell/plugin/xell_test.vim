
" let codepage = 'cp' . matchstr(system("chcp"), '\zs\d\+\ze[^[:graph:]]*$')
" ech iconv(system('dir'), codepage, 'utf-8')

command! -nargs=* TestCommand call TestFunction('aaa' . ' <args>')

function! TestFunction(str)
	echo a:str
endfunction
