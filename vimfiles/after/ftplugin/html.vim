"setlocal showmatch

" Tabstop setting {{{1
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal expandtab
" }}}

" Folding setting {{{1
" Use syntax fold, see ../syntax/html.vim
setlocal foldmethod=syntax
setlocal foldcolumn=4
setlocal foldlevel=1
" }}}

" Completion setting {{{1
" Omni completion
imap <buffer> <c-o> <c-x><c-o>
setlocal omnifunc=HtmlOmniWrapper
" completion html omnicomplete wrapper {{{2
" c.f. http://objectmix.com/editors/208298-html-omni-completion-returns-tags-uppercase-only.html
func! HtmlOmniWrapper(findstart, base )
let comp = htmlcomplete#CompleteTags(a:findstart,a:base)

if !a:findstart && !empty(comp)
	if type(comp[0]) == type({})
		call map(comp,'v:val.word !~# "^!\\|^\\l"?tolower(v:val.word):v:val.word')
	else
		call map(comp,'v:val !~# "^!\\|^\\l"?tolower(v:val):v:val')
	endif
endif
return comp
endfun
" }}}
" }}}

" HTML tags manipulations {{{1
" Delete the outside pair of tags
nmap <buffer> dot "xyitvat"xp

" Convert all tags and attributes to lower case
" c.f. http://vim.wikia.com/wiki/Changing_all_HTML_tags_to_lowercase
" For lower case tags
cab <buffer> lct %s/<\/\?\zs\(\w\+\)\ze[ >]/\L\1/g
" For lower case attributes
cab <buffer> lca %s/\(<[^>]*\)\@<=\<\(\w*\)\ze=['"]/\L\2/g
" }}}

" TOC specified to html
nmap <buffer> <Leader>; :TToC ^\s*<\%(param\<bar>link\<bar>isindex\<bar>input\<bar>hr\<bar>frame\<bar>col\<bar>br\<bar>basefont\<bar>base\<bar>area\<bar>img\<bar>meta\<bar>tr\<bar>td\<bar>p\<bar>dt\<bar>dd\<bar>li\)\@!\(\w\+\)\%(\_s[^>]*[^>/]\)*><CR>

let b:search_pattern = g:urlpattern . '\|' . '^\s*<\%(param\|link\|isindex\|input\|hr\|frame\|col\|br\|basefont\|base\|area\|img\|meta\|tr\|td\|p\|dt\|dd\|li\)\@!\(\w\+\)\%(\_s[^>]*[^>/]\)*>'
nmap <buffer> <Tab> :call xelltoolkit#goto_next_word(b:search_pattern)<CR>
nmap <buffer> <S-Tab> :call xelltoolkit#goto_pre_word(b:search_pattern)<CR>

let b:lorem = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor\r incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis\r nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\r Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu\r fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in\r culpa qui officia deserunt mollit anim id est laborum.\r"

" Deprecated due to zen-coding
" iab <buffer> htmlmeta <meta http-equiv="content-type" content="text/html; charset=UTF-8">
" iab <buffer> htmlmeta/ <meta http-equiv="content-type" content="text/html; charset=UTF-8" />

