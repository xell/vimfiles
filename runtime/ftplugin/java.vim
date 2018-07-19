
setlocal foldmethod=syntax
setlocal makeprg=javac\ %
" setlocal errorformat=%A%f:%l\ %m,%-Z%p^,%-C%.%#
setlocal errorformat=%A%f:%l:\ %m,%+Z%p^,%+C%.%#,%-G%.%#
" setlocal errorformat=%A%f:%l:%m,%-Z%p^,%-C%.%#

" setl errorformat=%Z%f:%l:\ %m,%A%p^,%-G%*[^sl]%.%#
" setl makeprg=javac\ %\ 2>&1\ \\\|\ vjf-vimjavacfilter
 
" java compile
map <buffer> <F8> :call CompileJava()<CR>
func! CompileJava()
	:w
	:make
endfunc
 
" run class
map <buffer> <F9> :call RunClass()<CR>
func! RunClass()
	:!java -cp "%:p:h" "%:t:r"
endfunc
