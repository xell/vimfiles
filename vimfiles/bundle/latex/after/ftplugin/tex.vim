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

" let b:undo_ftplugin = 'setlocal noshellslash<'
