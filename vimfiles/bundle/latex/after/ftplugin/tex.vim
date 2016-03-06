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

" rm -f *.{aux,bbl,blg,brf,lof,lot,out,toc,synctex.gz,pdf,dvi}
" find . -type f -name "*.aux" -exec rm -f '{}' \;
function! s:clean(strong)
    let is_run = input("Are you sure [y/N]: ")
    if is_run !~? 'y'
        return
    endif
    exec 'lcd ' . xelltoolkit#fname_escape(expand('%:p:h')) . '/'
    if a:strong
        let file_list = '{aux,bbl,blg,brf,fdb_latexmk,fls,lof,lot,out,toc,synctex.gz,pdf,dvi}'
    else
        let file_list = '{aux,bbl,blg,brf,fdb_latexmk,fls,lof,lot,out,toc,synctex.gz}'
    endif
    call xelltoolkit#system('rm -f *.' . file_list)
    call xelltoolkit#system('find . -type f -name "*.aux" -exec rm -f '. "'{}'" . ' \;')
    call xelltoolkit#system('find . -type f -name "*.log" -exec rm -f '. "'{}'" . ' \;')
endfunction

" http://tex.stackexchange.com/questions/150770/how-to-make-vim-short-key-for-xelatex-and-pdflatex-both
nmap <buffer> <Leader>lm :<C-U>call <SID>complieWithLatexMK(0)<CR>
nmap <buffer> <Leader>lM :<C-U>call <SID>complieWithLatexMK(1)<CR>

function! s:complieWithLatexMK(force)
    let oldRule = g:Tex_CompileRule_pdf
    if a:force
        " Force latexmk to continue document processing despite errors.
        let g:Tex_CompileRule_pdf = 'latexmk -f -pdf $*'
    else
        let g:Tex_CompileRule_pdf = 'latexmk -pdf $*'
    endif
    call Tex_RunLaTeX()
    let g:Tex_CompileRule_pdf = oldRule
endfunction

" let b:undo_ftplugin = 'setlocal noshellslash<'
