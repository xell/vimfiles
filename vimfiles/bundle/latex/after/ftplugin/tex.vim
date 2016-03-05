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

nmap <buffer> ,lc :call <SID>clean(0)<CR>
nmap <buffer> ,lC :call <SID>clean(1)<CR>

" rm -f *.{aux,bbl,blg,brf,lof,lot,out,toc,synctex.gz,pdf,dvi}
" find . -type f -name "*.aux" -exec rm -f '{}' \;
function! s:clean(strong)
    let is_run = input("Are you sure [y/N]: ")
    if is_run !~? 'y'
        return
    endif
    exec 'lcd ' . xelltoolkit#fname_escape(expand('%:p:h')) . '/'
    if a:strong
        let file_list = '{aux,bbl,blg,brf,lof,lot,out,toc,synctex.gz,pdf,dvi}'
    else
        let file_list = '{aux,bbl,blg,brf,lof,lot,out,toc,synctex.gz}'
    endif
    call xelltoolkit#system('rm -f *.' . file_list)
    call xelltoolkit#system('find . -type f -name "*.aux" -exec rm -f '. "'{}'" . ' \;')
    call xelltoolkit#system('find . -type f -name "*.log" -exec rm -f '. "'{}'" . ' \;')
endfunction

" let b:undo_ftplugin = 'setlocal noshellslash<'
