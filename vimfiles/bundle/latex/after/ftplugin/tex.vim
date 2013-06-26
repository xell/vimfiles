" setlocal shellslash

" According to
" http://vim-latex.sourceforge.net/documentation/latex-suite/recommended-settings.html
" This is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
setlocal shiftwidth=2

" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
setlocal iskeyword+=:

"c.f. :h tex-conceal
setlocal conceallevel=2
setlocal concealcursor=n

setlocal foldcolumn=4

nmap <buffer> j gj
nmap <buffer> k gk
nmap <buffer> <Leader>lb :!bibtex %:t:r<CR>

vmap <buffer> <a-t> "zs\temp{<C-R>z}<Esc>

nmap <buffer> <Leader>lc :call <SID>clean(0)<CR>
nmap <buffer> <Leader>lC :call <SID>clean(1)<CR>

function! s:clean(all)
	if a:all
		let exts = ["aux", "bbl", "blg", "brf", "lof", "lot", "out", "toc", "gz", "pdf", "dvi"]
	else
		let exts = ["aux", "bbl", "blg", "brf", "lof", "lot", "out", "toc", "synctex"."gz"]
	endif
	let allfiles = glob(expand('%:p:h') . '/**/*.*', 0, 1)
	let files_to_delete = []
	for file in allfiles
		for ext in exts
			if xelltoolkit#fname_ext(file) ==? ext
				call add(files_to_delete, file)
				break
			endif
		endfor
	endfor
	let confirm = input("Are you sure? y/N  ")
	if confirm =~? '^y'
		for file in files_to_delete
			if delete(file)
				call xelltoolkit#echo_msg(file . " cannot be delete!")
			endif
		endfor
	else
		echo files_to_delete
	endif
endfunction

" let b:undo_ftplugin = 'setlocal noshellslash<'
