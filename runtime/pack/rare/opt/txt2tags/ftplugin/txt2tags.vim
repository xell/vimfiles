if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

" UNDO list {{{
" Reset the following options to undo this plugin.
let b:undo_ftplugin = "setlocal ".
      \ "suffixesadd< isfname< comments< ".
      \ "autowriteall< ".
      \ "formatoptions< foldtext< ".
      \ "foldmethod< foldexpr< commentstring< "
" UNDO }}}

" Settings {{{1
setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab
setlocal isfname-=]
setlocal isfname-=#
setlocal include=\\zs\\k\\+\\.t2t\\ze
"setlocal include='\[[^\s]\+\s.*t2t'
"setlocal include='\\zs[^\\s]\\+\\.t2t\\ze\\]'

setlocal conceallevel=2
setlocal concealcursor=n

setlocal autoindent
" The default comments incude a fb:- which conflict with ' - '
setlocal comments=n:%,:-,:+
setlocal formatoptions+=roc

" setlocal showbreak=\ \ \ 

" }}}

" Mappings {{{1

nmap <buffer> gf <C-W>f
nmap <buffer> j gj
nmap <buffer> k gk

" Use left or right arrow key to shift the level of title
nmap <buffer> <Left> :.s/\(=\+\)=/\1/ge<CR>:.s/\(+\+\)+/\1/ge<CR>
nmap <buffer> <Right> :.s/\(=\+\)/\1=/ge<CR>:.s/\(+\+\)/\1+/ge<CR>

nmap <buffer> [[ zk
nmap <buffer> ]] zj

" Use for indent the list bullets
imap <buffer> <c-w><c-w> <Esc>>>A 
imap <buffer> <c-w><c-q> <Esc><<A 

iab <buffer> xtdate %%date(%Y-%m-%d %X)

" Make selected bold: **xxx**
vmap <buffer> <M-8> "zc**<C-R>Z**<Esc>
" Make selected italic: //xx//
vmap <buffer> <M-/> "zc//<C-R>Z//<Esc>
" Make selected strike: --xx--
vmap <buffer> <M--> "zc--<C-R>Z--<Esc>
" Make selected under: __xx__
vmap <buffer> <M-_> "zc__<C-R>Z__<Esc>
" Make selected coded: ``xx``
" `d<BS> part is used to avoid auto ``<++>
vmap <buffer> <M-c> "zc`d<BS>`<C-R>Z`d<BS>`<Esc>

call xelltoolkit#imap('****', '**<++>**<++>', 1)
call xelltoolkit#imap('////', '//<++>//<++>', 1)
call xelltoolkit#imap('````', '``<++>``<++>', 1)
call xelltoolkit#imap("''''", "''<++>''<++>", 1)
imap <A-c> ((!))
call xelltoolkit#imap('((!))', '((!<++>))<++>', 1)
imap <A-d> ((_))
call xelltoolkit#imap('((_))', '((_<++>))<++>', 1)

let b:search_pattern = g:urlpattern . '\|\%([a-zA-Z_]\+\.t2t[#]\?\)'
nmap <buffer> <Tab> :call xelltoolkit#goto_next_word(b:search_pattern)<CR>
nmap <buffer> <S-Tab> :call xelltoolkit#goto_pre_word(b:search_pattern)<CR>

" }}}

" Fold setting {{{1
setlocal foldtext=CustomFoldText(1)
setlocal foldcolumn=4
"setlocal fillchars=fold:\ ,stlnc:-,vert:\|,diff:-

" Following are deprecated. see vimrc CustomFoldText()
function! MyFoldText() "{{{2
  let line = getline(v:foldstart)
  """ the original, used for reference
  " let sub = substitute(line, '/\*\|\*/\|<<<\d\=', '', 'g')

  """ the following will output == Title Text
  " let sub = substitute(line, '=\+[^=]\+\zs=\+\ze', '', 'g')

  """ the following will output combination of \1 \2 and \3
  " let sub = substitute(line, '\(=\+\)\([^=]\+\)\(=\+\)', '\1\2', 'g')

  """ the following will output ×× Title Text ==
  " let sub = substitute(line, '=\+[^=]\+\zs=\+\ze','Ф','g')
  " let sub = substitute(sub, '=','×','g')
  " let sub = substitute(sub, 'Ф','','g')

  """ the following will output ×= Title Text ==
  "let sub = substitute(line, '^[=+]', '×','g')
  
  let sub = line
  if strpart(sub, 1, 1) != '='
	let sub .= '---------------------------------'
	let sub .= '---------------------------------'
	let sub .= '---------------------------------'
	let sub .= '---------------------------------'
	let sub .= '---------------------------------'
	let sub .= '---------------------------------'
  endif
"  " return v:folddashes . sub
"  let inittext = repeat('◎',v:foldlevel - 1)
"  " return "   " . inittext . " " . sub
  return sub
endfunction "}}}
function! MyFoldText2() "{{{2

    "get first non-blank line
    let fs = v:foldstart
    while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
    endwhile
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let line = getline(fs)
    endif

    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " " . foldSize . " lines "
    let foldLevelStr = repeat("+--", v:foldlevel - 1)
    let lineCount = line("$")
    let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
    "let expansionString = repeat(".", w - strlen(foldSizeStr) - strlen(line) - strlen(foldLevelStr) - strlen(foldPercentage))
    let expansionString = repeat(".", w - strwidth(foldSizeStr) - strwidth(line) - strwidth(foldLevelStr) - strwidth(foldPercentage))
    "return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
    return foldLevelStr . line . expansionString . foldSizeStr . foldPercentage
endfunction
function! s:length(str)
      return len(substitute(a:str, ".", "x", "g"))
endfunction
" }}}

" Define folding based on wiki headings; start with all folds open.
" See http://vim.wikia.com/wiki/VimTip1565
setlocal foldlevel=20
setlocal foldmethod=expr
" setlocal foldexpr=HeadingLevel(v:lnum)
" if !exists("*HeadingLevel") "{{{2
"   function HeadingLevel(lnum)
"     " n is the number of consecutive '=' at start of line
"     let n = strlen(substitute(getline(a:lnum), '[^=+].*', '', ''))
" 	n = (n >= 2) ? n - 1 : 0
"     return (n == 0) ? '=' : '>' . n
"   endfunction
" endif
" Foldexpr {{{2
setlocal foldexpr=Txt2tagsLevel()
function! Txt2tagsLevel() "{{{3
    if getline(v:lnum) =~ '^= .*=\(\[[^\]]\+\]\)\?$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^== .*==\(\[[^\]]\+\]\)\?$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^=== .*===\(\[[^\]]\+\]\)\?$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^==== .*====\(\[[^\]]\+\]\)\?$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^===== .*=====\(\[[^\]]\+\]\)\?$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^====== .*======\(\[[^\]]\+\]\)\?$'
        return ">6"
    endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^=\s'
		return "0"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^==\s'
		return "1"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^===\s'
		return "2"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^====\s'
		return "3"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^=====\s'
		return "4"
	endif
    return "="
endfunction "}}}
" }}}
" }}}

