nnoremap <buffer> j gj
nnoremap <buffer> k gk
inoremap <buffer> <D-b> ****<++><Left><Left><Left><Left><Left><Left>
vnoremap <buffer> <D-b> "zc**<C-R>Z**<Esc>
nmap <Leader>{ A{{{<Esc>
nmap <Leader>} A}}}<Esc>

setlocal conceallevel=2
setlocal concealcursor=n

setlocal foldmethod=expr
setlocal foldexpr=MarkdownLevel1()
function! MarkdownLevel1() " {{{
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return ">6"
    endif

    return "="
endfunction "}}}
setlocal foldcolumn=5
setlocal foldtext=Mkdfoldtext()
function! Mkdfoldtext() "{{{

    "get first non-blank line {{{3
    let fs = v:foldstart
    while getline(fs) =~ '^\s*$' 
		let fs = nextnonblank(fs + 1)
    endwhile
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        "let line = getline(fs)
        let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
    endif
	" }}}
	
	if line =~ '<div[^>]\+class="rst-rubric">'
		let line = '= ' . matchstr(line, '>\zs.*\ze$')
	endif

	if line =~ '^\s*<!--\s.\+{\{3}\s-->'
		let line = matchstr(line, '<!--\s\zs.\+\ze\s{\{3}\s-->')
		let line = repeat('-', v:foldlevel) . ' ' . line . ' ' . repeat('{', 3)
	endif


    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    " let foldLevelStr = repeat("+--", v:foldlevel - a:n)
	let foldLevelStr = ''


	" n lines
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " " . foldSize . " lines "
	
	" [m%]
    let lineCount = line("$")
    let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "

	" ....
    let expansionString = repeat(".", w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))

    return foldLevelStr . line . expansionString . foldSizeStr . foldPercentage
endfunction
"}}}
