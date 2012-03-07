""""""""""""""""""""""""""""""""""""""""""""""""""""" 
"
"  \  /
"   \/   |--  |    |
"   /\   |--  |    |
"  /  \  |--  |--  |--
"
" Maintainer: Xell Liu <xell DOT liu AT gmail.com>


" Pre {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""" 

" Use third-part macro to track the startup time {{{2
"let g:startup_profile_csv = 'd:/p/vim-new/vim73/vim_startup_log.csv'
"runtime macros/startup_profile.vim
" }}}

set nocompatible

" System specified g:isw g:ism {{{2
" TODO i don't know how to detect vim terminal in mac
let g:isw = 0
let g:ism = 0
if has("win32") || has("win64")
	let g:isw = 1
else
	let g:ism = 1
endif

if g:isw
	let g:myvimfiles = expand("<sfile>:p:h") . '/vimfiles'
elseif g:ism
	let g:myvimfiles = glob('~/.vim')
endif

" }}}

" Temp {{{2
" XXX need to be deleted after re-constructed
" g:myvimfiles
" $VIM win: d:\p\vim
"      mac: /Applications/MacVim.app/Contents/Resources/vim
" $VRT win: d:\p\vim\vim73
"      mac: /Applications/MacVim.app/Contents/Resources/vim/runtime
" BIN  win: d:\p\vim\vim73\gvim.exe vim.exe
"      mac: /Applications/MacVim.app/Contents/MacOS/MacVim Vim

" let g:myvim_dir = expand("<sfile>:p:h")
" let g:myvimfiles = g:myvim_dir . '/vimfiles'
" let g:myvimfiles_after = g:myvimfiles . '/after'
" exec 'set runtimepath=' . g:myvimfiles . ',$VIMRUNTIME,' . g:myvimfiles_after
" let $MYVIMRC = g:myvim_dir . '/vimrc'
" let $MYGVIMRC = g:myvim_dir . '/gvimrc'
" }}}

" Pathogen {{{2
" call :Helptags after install/copy plugins into bundle
call pathogen#infect()
"call pathogen#helptags()
" }}}

" }}}

" General {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""" 

" Enable file type detection and indent
filetype plugin indent on

" Enable syntax hl
syntax enable

" Language
set langmenu=none
language messages en_US

" Viminfo file
" TODO set viminfo='50,<1000,s500,h,n$vim/vimfiles/_viminfo/viminfo
"exec "set viminfo='50,<1000,c,s500,h,n" . g:MyRuntimePath . '/viminfo'
exec "set viminfo='50,<1000,c,s500,h"

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Move to previous/next line
set whichwrap+=<,>,[,],l,h

" Use for chinese characters
" It treat a chinese character as a word, and does not add blankspace while joining two lines.
" mM chinese
" l don't auto format textwidth
" ro repeat comments
" c auto format textwidth in comment
" q allow formatting of comments with gq
" t autowrap
set formatoptions=mMlrocq

" While a file is changed outside Vim, automaitcally read it w/o warning
set autoread

" Set the number of history of : commands and search.
set history=500

" Set file encode originally by xell
set encoding=utf-8
set fileencodings=utf-8,cp936
" Multi-encoding setting {{{2
" see http://www.newsmth.net/bbscon.php?bid=731&id=20845&ftype=11
"if has("multi_byte")
"  "set bomb 
"  set fileencodings=utf-8,cp936,gb18030,big5,euc-jp,sjis,euc-kr,ucs-2le,latin1 
"  " CJK environment detection and corresponding setting 
"  if v:lang =~ "^zh_CN" 
"    " Use cp936 to support GBK, euc-cn == gb2312 
"    "set encoding=cp936 
"    "set termencoding=cp936 
"    "set fileencoding=cp936 
"    set encoding=utf-8 
"    set termencoding=utf-8 
"    set fileencoding=utf-8 
"  elseif v:lang =~ "^zh_TW" 
"    " cp950, big5 or euc-tw 
"    " Are they equal to each other? 
"    set encoding=big5 
"    set termencoding=big5 
"    set fileencoding=big5 
"  elseif v:lang =~ "^ko" 
"    " Copied from someone's dotfile, untested 
"    set encoding=euc-kr 
"    set termencoding=euc-kr 
"    set fileencoding=euc-kr 
"  elseif v:lang =~ "^ja_JP" 
"    " Copied from someone's dotfile, untested 
"    set encoding=euc-jp 
"    set termencoding=euc-jp 
"    set fileencoding=euc-jp 
"  endif 
"  " Detect UTF-8 locale, and replace CJK setting if needed 
"  if v:lang =~ "utf8$" || v:lang =~ "UTF-8$" 
"    set encoding=utf-8 
"    set termencoding=utf-8 
"    set fileencoding=utf-8 
"  endif 
"else 
"  echoerr "Sorry, this version of (g)vim was not compiled with multi_byte" 
"endif 
"}}}

" Options in sessions
" set sessionoptions=buffers,folds,globals,localoptions,options,resize,slash,tabpages,winpos,winsize
set sessionoptions=buffers,curdir,folds,resize,slash,tabpages,winpos,winsize

" Set local current directory
set autochdir

" Backup files setting
set nobackup
set writebackup

" Always set autoindenting on
set autoindent
"set smartindent

" In utf-8 files, use twice the width of ASCII characters
set ambiwidth=double

" Set tab page max
set tabpagemax=100

" Search in smartcase
set ignorecase smartcase
set incsearch

" Don't wrap while searching
set nowrapscan

" Set general fold method to triple { like
set foldmethod=marker

" Set ignore files when completion
set wildignore=*.o,*.ojb,*.pyc,*.DS_Store,*.db,*.dll,*.exe,*.a

" Deal with large file
"autocmd BufWinEnter * if line2byte(line("$") + 1) > 200000 | syntax clear | echomsg "Large File" | endif

" Breakindent patch
if exists("+breakindent")
	set breakindent
endif

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim). g`
" vimrcEx
autocmd BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\   exe "normal! g`\"" |
			\ endif

" Special settings {{{2

if g:isw
behave mswin
	" Set 'selection', 'selectmode', 'mousemodel' and 'keymodel' 
	" for MS-Windows
	behave mswin

	" More settings, <c-c> <c-v> <c-s> <c-z> <c-y> <c-a>
	" I'd like to set them by myself selectively
	"so $VIMRUNTIME/mswin.vim
	
	" In case temp is no c:\tmp and/or c:\temp
	set directory=.,$TEMP,$TMP

endif

" After set on, \ will be converted to / automatically in windows
" Ex in win, typing d:\ and hit <Tab>, it will be d:/ automatically
" It effects expand("%:p")
" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
" if g:isw
" 	set shellslash
" endif

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" TODO Dictionary file
if exists("g:myvimfiles")
	exec 'set dictionary=' . g:myvimfiles . '/dictionary.txt'
else
	if g:isw
		exec 'set dictionary=' . $VIM . '\vimfiles\dictionary.txt'
	else
		exec 'set dictionary=' . glob('~/.vim') . '/dictionary.txt'
	endif
endif

" }}}

" Special settings for Mac {{{2
if g:ism
	" IME setting {{{3
	
	" function! s:setim()
	" 	if &imd
	" 		set imd
	" 		set noimd
	" 		echo "Chinese enable."
	" 	else
	" 		set imd
	" 		echo "English only."
	" 	endif
	" endfunction

	" nmap <D-i> :call <SID>setim()<CR>
	" imap <D-i> <Esc>:call <SID>setim()<CR>i
	
	" set imd
	set noimd
	" }}}

	" Use vim internal help when press K
	set keywordprg=

	set visualbell

endif
" }}}

" }}}

" Xell Global Variables {{{1

let g:slash = xelltoolkit#slash()

if g:isw
elseif g:ism
endif

" URL {{{2
let g:urlpattern = '\%(\(https\?\|ftp\):\/\{2}[^ ">\])]\+\)'
if g:isw
	let g:webbrowser = ''
	let g:webserver_host = 'http://127.0.0.1:8800'
	let g:webserver_dir = 'd:\Codes\web'
elseif g:ism
	let g:webbrowser = 'Google Chrome.app'
	let g:webserver_host = 'http://localhost:80/~xell'
	let g:webserver_dir = glob('~/Sites')
endif
" }}}

" Proxy {{{2
if g:isw
	let g:proxy_list = 'd:\Codes\pac\xell.proxylist'
	let g:proxy_pac = 'd:\Codes\pac\proxylist.pac'
elseif g:ism
	let g:proxy_list = '/Users/xell/Codes/pac/xell.proxylist'
	let g:proxy_pac = '/Users/xell/.xellproxy/proxylist.pac'
endif
" }}}

" Docs {{{2
" Specify use what function to look for the output html of doc file
let g:browser_open_rules = {'t2t': 'GetOutputHTML', 'md': 'GetOutputHTML', 'mkd': 'GetOutputHTML', 'markdown': 'GetOutputHTML', 'rst': 'GetOutputHTML', 'noteindex': 'GetOutputHTML'}

" These convert rule functions only consider current buffer
" Definition : function Wrapper(out_type, config)
let g:docs_convert_buffer_rules = {
			\ 'txt2tags': 'Txt2tagsConvertBufferWrapper',
			\ 'pandoc': 'PandocConvertBufferWrapper',
			\ 'rst': 'RstConvertBufferWrapper',
			\ 'noteindex': 'NotesConvertWrapper'}

" Text2tags specification {{{3
if g:isw
	let g:t2t_cmd = 'd:\p\txt2tags\txt2tags.py'
	let g:t2t_cf_path = 'd:\w\_special\_tpl\t2t'
elseif g:ism
	let g:t2t_cmd = '/P/apps/txt2tags/txt2tags'
	let g:t2t_cf_path = glob('~/Documents/_special/_tpl/t2t')
endif

let g:t2t_target_ext = {'html': 'html', 'md': 'md', 'rst': 'rst', 'txt': 'txt', 'html5': 'html', 'rtf': 'rtf', 'tex': 'tex'}
" }}}

" Pandoc specification {{{3
let g:pandoc_syntax_accuracy = 1
let g:pandoc_syntax_full_html_tex = 1
let g:pandoc_syntax_table = 0

let g:pandoc_target_ext = {'plain': 'txt', 'markdown': 'md', 'rst': 'rst', 'html': 'html', 'html5': 'html', 'latex': 'tex', 'mediawiki': 'wiki', 'opendocument': 'fodt', 'odt': 'odt', 'docx': 'docx', 'slidy': 'html', 'dzslides': 'html', 'rtf': 'rtf'}

if g:isw
	let g:pandoc_exec = 'd:\p\pandoc\bin\pandoc.exe'
	let g:pandoc_tpl_root = 'd:\W\_special\_tpl\pandoc'
	let g:pandoc_csl_root = g:pandoc_tpl_root . '\csl'
	let g:pandoc_css_root = g:pandoc_tpl_root . '\css'
	let g:pandoc_htmltpl_root = g:pandoc_tpl_root . '\html'
	let g:pandoc_docx_root = g:pandoc_tpl_root . '\docx'
	let g:pandoc_odt_root = g:pandoc_tpl_root . '\odt'
elseif g:ism
	let g:pandoc_exec = 'pandoc'
	let g:pandoc_tpl_root = '/Users/xell/Documents/_special/_tpl/pandoc'
	let g:pandoc_csl_root = g:pandoc_tpl_root . '/csl'
	let g:pandoc_css_root = g:pandoc_tpl_root . '/css'
	let g:pandoc_htmltpl_root = g:pandoc_tpl_root . '/html'
	let g:pandoc_docx_root = g:pandoc_tpl_root . '/docx'
	let g:pandoc_odt_root = g:pandoc_tpl_root . '/odt'
endif
let g:pandoc_bib = 'biblio.bib'
let g:pandoc_csl = g:pandoc_csl_root . g:slash . 'Chinese-GB7714-2005-Numeric-1.0.csl'

" }}}

" Rst Docutils specification {{{3
let g:rst_target_ext = {'html': 'html', 'odt': 'odt'}

if g:isw
	let g:rst2odt_exec = 'd:\p\docutils\tools\rst2odt.py'
	let g:rst2html_exec = 'd:\p\docutils\tools\rst2html.py'
	let g:rst_tpl_root = 'd:\W\_special\_tpl\docutils'
	let g:rst_html_root = g:rst_tpl_root . '\html'
	let g:rst_html_tpl_root = g:rst_html_root . '\tpl'
	let g:rst_html_style_root = g:rst_html_root . '\style'
	let g:rst_odt_style_root = g:rst_tpl_root . '\odt'
elseif g:ism
	let g:rst2odt_exec = 'rst2odt.py'
	let g:rst2html_exec = 'rst2html.py'
	let g:rst_tpl_root = '/Users/xell/Documents/_special/_tpl/docutils'
	let g:rst_html_root = g:rst_tpl_root . '/html'
	let g:rst_html_tpl_root = g:rst_html_root . '/tpl'
	let g:rst_html_style_root = g:rst_html_root . '/style'
	let g:rst_odt_style_root = g:rst_tpl_root . '/odt'
endif
" }}}

" }}}

" Notes {{{2
if g:isw
	let g:xell_notes_root = 'D:\W\notes\xnotes'
	let g:xell_notes_ex_root = 'D:\W\notes\xnotes_export'
elseif g:ism
	let g:xell_notes_root = glob('~/Documents/notes/xnotes')
	let g:xell_notes_ex_root = glob('~/Documents/notes/xnotes_export')
endif

let g:xell_notes_index = 'index.noteindex'
let g:xell_notes_temp = 'temp.md'

" }}}

" Other {{{2
if g:isw
	" Setting codepage used for iconv etc.
	" Ex cp936 for Simply Chinese Windows OS
	"let g:codepage = 'cp' . matchstr(system("chcp"), '\zs\d\+\ze[^[:graph:]]*$')
	let g:codepage = 'cp936'

	let g:ahk_exec = 'd:\P\autohotkey\AutoHotkey.exe'
	let g:ahk_help = 'd:\P\autohotkey\AutoHotkey.chm'
endif
" }}}


" }}}

" UI and Display {{{1

" Invoke enhanced completion mode in command line
set wildmenu

" Highlight the search iterms
set hlsearch

" Show more |more-prompt|
set more

" Don't give Uganda messages in startup screen
set shortmess+=I

" Threshold for reporting number of lines changed
set report=0

" Display as much as possible instead of @
set display=lastline

" Characters to fill the statuslines and vertical separators.
set fillchars=vert:\ ,stl:\ ,stlnc:\ ,fold:-

" Tab width
set tabstop=4
set shiftwidth=4

" Not equal windows splitting
set noequalalways

" Show the cursor position all the time
set ruler

" Display incomplete commands
set showcmd

" Show line number
set number

" Set cursor always in the middle
set scrolloff=8

" Set mouse in normal window
set mouse=a

" Foldtext  {{{2
" http://www.gregsexton.org/2011/03/improving-the-text-displayed-in-a-fold/
set foldtext=CustomFoldText(0)
fu! CustomFoldText(n) 

    "get first non-blank line
    let fs = v:foldstart
    while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
    endwhile
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        "let line = getline(fs)
        let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
    endif

    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " " . foldSize . " lines "
    let foldLevelStr = repeat("+--", v:foldlevel - a:n)
    let lineCount = line("$")
    let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
    let expansionString = repeat(".", w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
    "return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
    return foldLevelStr . line . expansionString . foldSizeStr . foldPercentage
endf
"}}}

" Use symbols to fill the blank of tab and eol
if g:ism
	set listchars=tab:▸\ ,eol:¬
endif

" Statusline customization {{{2
set laststatus=2
let g:mystatusline1 = '\ %{winnr()}\ %<%f\ %h%y%m%r\ [%{&ff}]\ [%{&fenc}]'
let g:mystatusline2 = '%=%-14.(%l,%c%V%)\ %L\ %P\ '

exec 'set statusline=' . g:mystatusline1 . g:mystatusline2

" Highlight statusbar according to the type of buffer {{{3
" TODO make colors compatible with other colorscheme
let g:aug_vimsb_enable = 1
augroup vimSB
	autocmd!
	autocmd BufNew,BufEnter,BufRead,BufWrite,TabEnter,TabLeave,WinEnter,WinLeave * if g:aug_vimsb_enable | call <SID>XellBufferStatuslineHighlight() | endif
	au QuickfixCmdPost make call xelltoolkit#qf_make_conv()
augroup END

function! s:XellBufferStatuslineHighlight()
	let buffername = bufname("%")
	if empty(buffername)
		highlight StatusLine guifg=White guibg=Green
		"highlight StatusLineNC guifg=LightGreen guibg=White
	elseif buffername =~ '\%(\.tmp\|0\)$'
		highlight StatusLine guifg=White guibg=Red
		"highlight StatusLineNC guifg=White guibg=LightRed
	else
		highlight StatusLine ctermfg=11 ctermbg=12 cterm=none guifg=#E8E7E6 guibg=#777777 gui=none
		highlight StatusLineNC ctermfg=12 ctermbg=11 cterm=none guifg=#D3CFCD guibg=#444444 gui=none
	endif
endfunction
" }}}

" }}}

" }}}

" Mappings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""" 

" General {{{2

" Set map leader  b de gHiIJK   pq  tu wxy 
let mapleader=","

" To allow overriding the Alt key
if g:isw
	set winaltkeys=no
elseif g:ism && has("mac")
	set macmeta
endif

" }}}

" Movements {{{2

map - $

" For navigate in visible lines
" nmap \ gj
" nmap <BS> gk

"Basic motions
imap <A-h> <Left>
imap <A-j> <Down>
imap <A-k> <Up>
imap <A-l> <Right>
imap <A--> <PageDown>
imap <A-=> <PageUp>
imap <A-6> <Home>
imap <A-4> <End>

" Page down and up
map <C-J> <PageDown>
map <C-K> <PageUp>

" }}}

" Tabs {{{2
" For tab creating
nmap <C-t> :tabnew<CR>

" Tab close
nmap <Leader>q :tabclose

" Tab previous and next
noremap <C-H> gT
noremap <C-L> gt

" Switch tabs and windows by numbers
function! s:mapleadernumber()
	for i in range(1, 9)
		exec 'nmap <Leader>' . i . ' ' . i . 'gt'
		exec 'nmap <M-' . i . '> :' . i . 'wincmd w<CR>'
	endfor
endfunction
call <SID>mapleadernumber()
" }}}

" Windows {{{2

" Close windows
nmap <Leader>c <C-W>c
nmap <Leader>o <C-W>o

" Open windows
nmap <Leader>wh :topleft vertical split<CR>
nmap <Leader>wj :botright split<CR>
nmap <Leader>wk :topleft split<CR>
nmap <Leader>wl :botright vertical split<CR>

" Split windows
nmap <Leader>s <C-W>s<C-W>j
nmap <Leader>v <C-W>v

" Switch two windows back and forth
noremap <Backspace> <C-W>p
noremap ` <C-W>w

" For switch to split windows
map <M-j> <C-W>j
map <M-k> <C-W>k
map <M-h> <C-W>h
map <M-l> <C-W>l
map <M-J> <C-W>J
map <M-K> <C-W>K
map <M-H> <C-W>H
map <M-L> <C-W>L

" For changing the size of split windows
nmap <M-[> <C-W>-
nmap <M-]> <C-W>+
nmap <M-,> <C-W><
nmap <M-.> <C-W>>
nmap <M-=> <C-W>=

" }}}

" GUI Windows {{{2
" see gvimrc
" Move (Win)   Alt+→←↑↓
" Change size  Ctrl+Alt+→←↑↓
" Toggle size  F1 F2
" }}}

" Visual block, yank, paste {{{2

" Leave cursor in the end of visual block
vnoremap y ygv<Esc>
nnoremap P gP

" Copy and paste according to OS conventions
if g:isw
	" Copy, use <c-q> to operate original <c-c>
	vnoremap <C-c> "+y
	noremap <C-q>		<C-V>
	map <C-v>		"+gP
	cmap <C-v>		<C-R>+
	" from http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
	" Pasting blockwise and linewise selections is not possible in Insert and
	" Visual mode without the +virtualedit feature.  They are pasted as if they
	" were characterwise instead.
	" Uses the paste.vim autoload script.
	"exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
	exe 'vnoremap <script> <C-v>' paste#paste_cmd['v']
	exe 'inoremap <script> <C-v> <C-g>u'.paste#paste_cmd['i']
	vnoremap <C-x> "+x
else
	" Redefine <D-v> in macmap.vim FIXME fail...
	"execute 'inoremap <script> <special> <D-v>' paste#paste_cmd['i']
	execute 'inoremap <script> <special> <D-v> <C-g>u'.paste#paste_cmd['i']

	vnoremap <D-c> "+y
	noremap  <D-v> "+gP
	cnoremap <D-v> <C-R>+
	inoremap <D-v> <C-R>+
	inoremap <D-V> <C-R>+
endif

" Open or yank web url
nmap <expr> <Leader>Y OpenInBrowser(1, xelltoolkit#get_word_at_cursor(g:urlpattern))
nmap <expr> <Leader>y xelltoolkit#get_copy(xelltoolkit#get_word_at_cursor(g:urlpattern))
" }}}

" Search {{{2
" For search highlight
nmap <Leader>ns :let @/=""<CR>
nmap <Leader>nh :nohlsearch<CR>

" For quickfix
"nmap <Leader>a :cp<CR>
nmap <Leader>a :call <SID>searchupward()<CR>
"nmap <Leader>z :cn<CR>
nmap <Leader>z :call <SID>searchdownward()<CR>
" Search cp cn etc. {{{3
" E533 no more items
function! s:searchupward()
	try
		cprevious
	catch /^Vim\%((\a\+)\)\=:E42/	" catch error E42 No Erros
		try
			lprevious
		catch /^Vim\%((\a\+)\)\=:E776/	" catch error E776 No Location List
			echo "No Quickfix or Location list."
		catch /^Vim\%((\a\+)\)\=:E553/	" catch error E553 No Location List
			echo "No more items"
		endtry
	endtry
endfunction

function! s:searchdownward()
	try
		cnext
	catch /^Vim\%((\a\+)\)\=:E42/	" catch error E42 No Erros
		try
			lnext
		catch /^Vim\%((\a\+)\)\=:E776/	" catch error E776 No Location List
			echo "No Quickfix or Location list."
		catch /^Vim\%((\a\+)\)\=:E553/	" catch error E553 No Location List
			echo "No more items"
		endtry
	endtry
endfunction

" }}}

" Find the word under the cursor and jump to location list
"nmap <Leader>l :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>
vmap <Leader>l "zy:lv /<C-R>z/ %<CR>:lw<CR>
" Display the search items in location list 
"nmap <Leader>l :call <SID>showsearchiteminlocationlist()<CR>
"function! s:showsearchiteminlocationlist()
"	execute 'lv /' . @/ . '/ % | lw'
"endfunction

" Move to url
nmap <Tab> :call xelltoolkit#goto_next_word(g:urlpattern)<CR>
nmap <S-Tab> :call xelltoolkit#goto_pre_word(g:urlpattern)<CR>

" Find General {{{3
nmap <C-F> :call <SID>find_general()<CR>

" Default -i; include only this filetype; no exclude
function! s:find_general()
	let pattern = input('What to find: ')
	if pattern == ''
		call xelltoolkit#echo_msg('Empty inquery!')
		return
	endif

	let option = input('Ignore case? (Y/n)')


	if expand('%:p:h') =~? xelltoolkit#fname2pattern(g:xell_notes_root)
		let include = 'note'
	else
		let include = input('This filetype? (Y/n)')
		if include == ''
			let include = expand('%:e')
		else
			let include = ''
		endif
	endif

	call xelltoolkit#grep_in_lcd_r(option, include, pattern)
endfunction
" }}}

" }}}

" Modify texts {{{2

inoremap jj <Esc>

" For insert enter when normal
nmap <S-Enter> i<Enter><Esc>
" For delete the Tab
imap <S-Tab> <BS>

" Move line
nmap <C-Up> ddkP
nmap <C-Down> ddp

" }}}

" Dispaly {{{2
nmap <Leader><Leader>n :call <SID>changenumberdisplay()<CR>
function! s:changenumberdisplay()
	if &number
		set relativenumber
	else
		set number
	endif
endfunction

nnoremap <Space> @=((foldclosed(line('.')) < 0)?'zc':'zo')<CR>

" }}}

" Completions {{{2
" Complete tags
inoremap <C-]> <C-x><C-]>
" Complete definition or macros
inoremap <C-D> <C-x><C-D>
" Complete file names
inoremap <C-F> <C-x><C-F>
" Complete dictionary
inoremap <C-K> <C-x><C-K>
" Complete whole lines
" inoremap <C-L> <C-x><C-L>

" }}}

" Special {{{2

" Edit vimrc
nmap <Leader>rce :e $MYVIMRC<CR>
" Reload vimrc
nmap <Leader>rcl :so $MYVIMRC<CR>

" Edit gvimrc
nmap <Leader>rcge :e $MYGVIMRC<CR>
" Reload gvimrc
nmap <Leader>rcgl :so $MYGVIMRC<CR>

" In windows, Alt+Space to act on icon menu
if g:isw
	noremap <M-Space> :simalt ~<CR>
	inoremap <M-Space> <C-O>:simalt ~<CR>
	cnoremap <M-Space> <C-C>:simalt ~<CR>
endif

" Jump among windows noremap
noremap <A-o> <Tab>
" }}}

" }}}

" Abbrevs {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""" 
if g:isw
	ca xs mks! d:\w\xs1.vim
	ca xl so d:\w\xs1.vim
	cab xrj e d:\W\notes\rj.t2t
	cab xhost e c:\windows\system32\drivers\etc\hosts<CR>
elseif g:ism
	ca xs mks! ~/Documents/xs1.vim
	ca xl so ~/Documents/xs1.vim
	cab xrj e ~/Documents/notes/rj.t2t
	cab xhost e /etc/hosts<CR>
	cab xbp e ~/.bash_profile
	" Must in /etc/sudoers set username ALL=(ALL) NOPASSWD:ALL
	cab xw w !sudo tee % > /dev/null
endif

cab xfn echo expand("%:p")
"Insert date and time
iab xdate <C-r>=strftime("%y-%m-%d %H:%M:%S")<CR>

" XXX temp
cab xe e ftp://xell@ftp.gowall1.veeserve.com:21/public_html/
cab xasb .s/\([^\x00-\xff]\&[^（），、：。“”；]\)\(\a\<bar>[<>_-]\)/\1 \2/g
cab xasa .s/\(\a\<bar>[<>_-]\)\([^\x00-\xff]\&[^（），、：。“”；]\)/\1 \2/g

" }}}

" Plugins {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""" 

" Blockdiff {{{2
vmap ,d1 :call BlockDiff_GetBlock1()<CR>
vmap ,d2 :call BlockDiff_GetBlock2()<CR>
" }}}
" Colorizer {{{2
nmap <silent> <F6> <Plug>Colorizer
" }}}
" Gundo {{{2
"let g:gundo_disable=1
nnoremap <F5> :GundoToggle<CR>
" }}}
" Increment {{{2
command! -nargs=0 IncHelp echo "<,>Inc [s]tart_0 [i]ncre_1 [r]epeat_1 [w]idth_4 [f]ill [h]ex [o]ct [p]at_@ [c]onfirm"

" }}}
" LanguageTool {{{2
if g:isw
	let g:languagetool_jar = 'd:\P\languagetool\LanguageTool.jar'
elseif g:ism
	let g:languagetool_jar = '/usr/local/Cellar/languagetool/1.3.1/libexec/LanguageTool.jar'
endif
nmap <F7> :LanguageToolCheck<CR>
" }}}
" Thesaurus {{{2
" TODO change the location of mthesaur.txt
if g:isw
	let g:thesaurus_file='d:\p\thesaurus\th_en_US_v2'
	set thesaurus=d:\P\thesaurus\mthesaur.txt
elseif g:ism
	" mac or unix must use '/usr/share/myspell/dicts/th_en_US_v2.idx'
	set thesaurus=~/Library/Thesaurus/mthesaur.txt
endif
imap <c-t> <Esc>bl:Thesaurus<CR>
" }}}
" tComment {{{2
" While gcc respects indent blank, I defined gcl to put comment character
" right in the first column.
nnoremap gcl :let g:tcommentOptions = {'col': 1}<CR>:normal gcc<CR>:let g:tcommentOptions = {}<CR>
let g:tcommentOptions = {}
let g:tcommentBlockXML = "<!--%s-->\n"
" Defind new pandoc type TODO block comment
let g:tcomment_types = {'pandoc': "<!-- %s -->", 'pandoc_inline': "<!-- %s -->", 'pandoc_block': "<!-- %s -->\n  ", 'proxylist': '#%s', 'noteindex': '*%s', 'conf': '#%s'}
"call tcomment#DefineType('pandoc', "<!-- %s -->")
"call tcomment#DefineType('pandoc_inline', "<!-- %s -->")
"call tcomment#DefineType('pandoc_block', "<!-- %s -->\n  ")
" }}}
" Translate EnToCn {{{2
"nmap <Leader>e :Trans<CR>
" }}}
" Matchit {{{2
" TODO difine some new block
" }}}
" WinFullScreen {{{2
nnoremap <C-Enter> :WinFullScreen<CR>
" }}}
" ZenCoding {{{2
let g:user_zen_leader_key = '<c-e>'
"let g:user_zen_expandabbr_key = '<c-h>'

" If you want to complete tags using |omnifunc| then add this.
let g:use_zen_complete_tag = 1
" }}}
" BufExplorer {{{2
let g:bufExplorerShowUnlisted=1
" }}}
" EasyMotion {{{2
let g:EasyMotion_do_mapping = 0

"nnoremap <silent> <Leader>j :call EasyMotionJK(0,0)<CR>
"nnoremap <silent> <Leader>k :call EasyMotionJK(0,1)<CR>
" let g:EasyMotion_mapping_f = ',f'
" let g:EasyMotion_mapping_F = ''
" let g:EasyMotion_mapping_t = ''
" let g:EasyMotion_mapping_T = ''
" let g:EasyMotion_mapping_w = ',w'
" let g:EasyMotion_mapping_W = ''
" let g:EasyMotion_mapping_b = ''
" let g:EasyMotion_mapping_B = ''
" let g:EasyMotion_mapping_e = ''
" let g:EasyMotion_mapping_E = ''
" let g:EasyMotion_mapping_ge = ''
" let g:EasyMotion_mapping_gE = ''
" let g:EasyMotion_mapping_j = ',j'
" let g:EasyMotion_mapping_k = ',k'

nnoremap <silent> <Leader>D :call EasyMotion#F(0,0)<CR>
nnoremap <silent> <Leader>d :call EasyMotion#WB(0,0)<CR>
" }}}
" Quich Filter {{{2
let g:filteringDefaultAutoFollow = 1

" After / search, use this to show the search result window
" just like quickfix list, but with sync scroll
nnoremap ,l :call FilteringNew().addToParameter('alt', @/).run()<CR>
" After / search, use this to enter a keword filtering the search
" i.e. do a second search in the first search result
nnoremap ,F :call FilteringNew().parseQuery(input('>'), '<Bar>').run()<CR>
" Re-open previous "look" windows selectively
nnoremap ,g :call FilteringGetForSource().return()<CR>

" Old settings, name are more intuitive to understand
" nmap <Leader>F :call Gather(input("Filter on term: "), 0)<CR>
" nmap <Leader>l :call Gather(@/, 0)<CR>:echo<CR>
" nmap <Leader>g :call GotoOpenSearchBuffer()<CR>
" }}}
" MarksBrowser {{{2
"let g:marksCloseWhenSelected = 0
let g:marksShowTypes = "abcdefghijklmnopqrstuvwxyz" . "ABCDEFGHIJKLMNOPQRSTUVWXYZ" . "0123456789.'`^<>\""
nmap <Leader>mb :MarksBrowser<cr><cr>
" Default
"let s:all_marks = "abcdefghijklmnopqrstuvwxyz.'`^<>\""
" }}}
" Showmarks {{{2
" Enable ShowMarks
let showmarks_enable = 1
" Show which marks
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
" Ignore help, quickfix, non-modifiable buffers
let showmarks_ignore_type = "hqm"
" Hilight lower & upper marks
"let showmarks_hlline_lower = 1
"let showmarks_hlline_upper = 1
"augroup MyShowMarks
"	autocmd!
"	autocmd BufRead,FileReadPost * normal ,mo
"augroup END
" }}}
" Voom {{{2
let g:voom_tree_placement="right"
let g:voom_tree_width=30
"let g:voom_return_key = '<C-Return>'
"let g:voom_tab_key = ''
"let g:voom_user_command = "so $VIM/vimfiles/voom_addons/mediawiki.vim"
let g:voom_tab_key = '<C-Tab>'
let g:voom_return_key = '<C-Return>'

nmap <silent> <Leader>; :call BuildTOC()<CR>
" BuildTOC  {{{3
function! BuildTOC()
	if !exists('t:toc_enable')
		" Open TOC
		let t:toc_enable = 'enable'
		let t:col_ori = &columns
		" Change window size
		if t:col_ori <= 100
			let col = g:voom_tree_width + t:col_ori
			exec 'set columns=' . col
		endif
		if &ft == 'txt2tags'
			exec 'Voom txt2tags'
			return
		elseif &ft == 'autohotkey'
			exec 'Voom ahk'
			return
		elseif &ft == 'python'
			exec 'Voom python'
			return
		elseif &ft == 'rst'
			exec 'Voom rest'
			return
		elseif &ft == 'markdown' || &ft == 'pandoc'
			exec 'Voom markdown'
			return
		elseif &ft == 'mediawiki'
			exec 'Voom wiki'
			return
		" Style {\{3}\d [\{3}\d
		elseif search('\({\{3}\d\)\|\([\{3}\d\)','nw')
			exec 'Voom'
			return
		" Style {\{3}$
		else
			exec 'TToC ^.*{\{3}$'
			return
		endif
	else
		" Close TOC
		unlet t:toc_enable
		let winnum = bufwinnr('*_VOOM*')
		if winnum != -1
			exec winnum . 'wincmd w'
			exec 'wincmd c'
		endif
		exec 'set columns=' . t:col_ori
		unlet t:col_ori
		return
endfunction
" }}}

" }}}
" TToC {{{2
" Use function as a navigation tree toc, for example
" nmap <Leader>tt :TToC \<fu\%[nction!]\s\zs.*\ze$<CR>
" }}}
" Taglist {{{2
let g:Tlist_Show_One_File=1
let Tlist_Sort_Type = "name"
if g:isw
	let Tlist_Ctags_Cmd = 'd:\p\ctags\ctags.exe'
endif
highlight link MyTagListFileName Identifier
highlight link MyTagListTagName Type

" For toggle the Tlist windows
nmap <F10> :TlistToggle<CR>
imap <F10> <ESC><F10>i
" }}}
" ConqueTerm {{{2
let g:ConqueTerm_FastMode = 0
let g:ConqueTerm_Color = 1
let g:ConqueTerm_Syntax = ''
"let g:ConqueTerm_ReadUnfocused = 1
if g:isw
	let g:ConqueTerm_PyExe = 'd:\P\python26\python.exe'
	let g:ConqueTerm_CodePage = 0
	" 0709 conque has some problem in dealing with color on multi-byte
	" cf. http://code.google.com/p/conque/issues/detail?id=56&can=1&q=conceal
	" or 'conceal'
	let g:ConqueTerm_ColorMode = ''
endif
" }}}
" NERDTree {{{2
let NERDTreeShowBookmarks = 1
nmap <Leader>t :NERDTreeToggle<CR>
nmap <Leader>b :NERDTreeFromBookmark 
" }}}
" FuzzyFinder {{{2
let g:fuf_modesDisable = ['aroundmrufile', 'mrucmd', 'dir', 'bookmark', 'taggedfile', 'line', 'quickfix']
let g:fuf_keyPreview = '<C-H>'
let g:fuf_keyOpenTabpage = '<C-Return>'

" Usage : ,fe n:
nmap <Leader>fe :FufFile<CR>
if g:isw
	let g:fuf_abbrevMap = {
				\ "^v:" : ['$VIM\**\',],
				\ "^n:" : [g:xell_notes_root . g:slash],
				\ "^c:" : ['d:\Codes\ahk\'],
				\ }
elseif g:ism
	let g:fuf_abbrevMap = {
				\ "^v:" : ['$VIM/**/',],
				\ "^n:" : [g:xell_notes_root . g:slash],
				\ }
endif

nmap <Leader>ff :FufMruFile<CR>
" All file in current directory recursively
nmap <Leader>fd :FufCoverageFile<CR>
nmap <Leader>ft :FufTag<CR>
nmap <Leader>fh :FufHelp<CR><C-E>
nmap <Leader>fb :FufBuffer<CR>

nmap <Leader>fc :call fuf#givencmd#launch('', 0, '>', <SID>getAllCommands())<CR>
function! s:getAllCommands()
  redir => commands
  silent command
  redir END
  return map((split(commands, "\n")[3:]),
	  \      '":" . matchstr(v:val, ''^....\zs\S*'')')
endfunction

" All user vimfiles
nmap <Leader>fg :call <SID>fuf_test()<CR>
function! s:fuf_test()
	exec "call fuf#givenfile#launch('', 0, '>', split(glob('" . g:myvimfiles . "/**/*'), \"\\n\"))"
endfunction

" }}}
" Fugitive {{{2
let g:fugitive_summary_format = '(%ci) %s'
if &loadplugins
	let g:mystatusline_fugitive = '\ %{Fugitive_statusline_mod()}'
	exec 'set statusline=' . g:mystatusline1 . g:mystatusline_fugitive . g:mystatusline2
endif
function! Fugitive_statusline_mod()
	if exists("*fugitive#statusline")
		return substitute(fugitive#statusline(), '\[Git\|\]', '', 'g')
	else
		return 'GIT'
	endif
endfunction

" }}}
" Gitv {{{2
nnoremap <Leader>gv :Gitv!<CR>
nnoremap <Leader>gV :Gitv<CR>
" }}}
" Git-Vim {{{2
let g:git_no_map_default = 1
nnoremap <Leader>ga :Gadd<CR>
nnoremap <Leader>gd :Gdiff
nnoremap <Leader>gD :call GitDiff('--cached')<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gS :Git status -s -b<CR>
nnoremap <Leader>gl :GitLog
nnoremap <Leader>gL :Glog<CR>:cw<CR>:match Special /[+-]\d\{4})\s\zs.*\ze$/<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gC :Gcommit -a<CR>
nnoremap <Leader>gp :GitPullRebase<CR>
nnoremap <Leader>ge :Gedit<CR>
if g:isw
	nnoremap <Leader>gk :silent !start gitk.cmd<CR>
	nnoremap <Leader>gK :silent !start gitk.cmd --all<CR>
else
	nnoremap <Leader>gk :silent !gitx<CR>
	nnoremap <Leader>gK :silent !gitx --all<CR>
endif
" }}}
" LaTeX {{{2
" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
" See filetype.txt *ft-tex-plugin*
let g:tex_flavor='latex'
" See syntax.txt *g:tex_conceal*
let g:tex_conceal="ag"
" See syntax.txt *tex-nospell*
let g:tex_comment_nospell = 1
" See syntax.txt *tex-folding*, vim built-in vim fold support
" It's based on fdm=syntax and is very inaccurate
" When using latex-suite, it's deprecated de facto
let g:tex_fold_enabled = 1

" Display the spell highlight beyond the syntax highlights
autocmd BufReadPost,FileReadPost *.tex syntax spell toplevel

" Set customized folding, see folding.vim
let g:Tex_FoldedSections = 'part,chapter,chapterp,section,%%fakesection,'
						\. 'subsection,subsubsection,'
						\. 'paragraph'
let g:Tex_UsePython=1
let g:Tex_DefaultTargetFormat = 'pdf'
"let g:Tex_CompileRule_dvi = 'latex --src-specials -interaction=nonstopmode $*'
let g:Tex_CompileRule_pdf = 'xelatex --synctex=1 -src-specials -interaction=nonstopmode $*'
" Set viewrule
if g:isw
	let g:Tex_ViewRule_pdf = 'sumatrapdf.exe -esc-to-exit -reuse-instance -inverse-search "' . $VIMRUNTIME . '\gvim.exe -c \":RemoteOpen +\%l \%f\""'
elseif g:ism
	let g:Tex_ViewRule_pdf = 'Skim'
endif

imap <A-;> <Plug>Tex_LeftRight
nmap <A-;> <Plug>Tex_LeftRight
" Change the default <F7>->FastCommandInsert to <C-F7>
nmap <C-F7> <Plug>Tex_FastCommandInsert

" }}}
" IMAP {{{2
if g:ism
	let g:Imap_FreezeImap = 1
	" Remap the jumpforward, originally <C-j>
	imap <D-C-J> <Plug>IMAP_JumpForward
	nmap <D-C-Y> <Plug>IMAP_JumpForward
elseif g:isw
	" Remap the jumpforward, originally <C-j>
	imap <C-J> <Plug>IMAP_JumpForward
	nmap <C-Y> <Plug>IMAP_JumpForward
endif

if g:ism
	function! s:imap_jump()
		let isfound = search('<++>', 'cW')
		if isfound
			if col('.') == col('$') - 4
				normal 4x
				startinsert!
			else
				normal 4x
				startinsert
			endif
		endif
	endfunction
	

	inoremap <C-j> <C-O>:call <SID>imap_jump()<CR>

	call xelltoolkit#imap('()', '(<++>)<++>', 0)
	call xelltoolkit#imap('[]', '[<++>]<++>', 0)
	call xelltoolkit#imap('{}', '{<++>}<++>', 0)
	call xelltoolkit#imap('<>', '<<++>><++>', 0)
	call xelltoolkit#imap('""', '"<++>"<++>', 0)
	call xelltoolkit#imap("''", "'<++>'<++>", 0)
	" call xelltoolkit#imap('%%', '%<++>%<++>', 0)

elseif &loadplugins && g:isw
	augroup MyIMAPs
		autocmd!
		autocmd VimEnter * call IMAP('()', '(<++>)<++>', '')
		autocmd VimEnter * call IMAP('[]', '[<++>]<++>', '')
		autocmd VimEnter * call IMAP('{}', '{<++>}<++>', '')
		autocmd VimEnter * call IMAP('<>', '<<++>><++>', '')
		autocmd VimEnter * call IMAP('""', '"<++>"<++>', '')
		autocmd VimEnter * call IMAP("''", "'<++>'<++>", '')
		autocmd VimEnter * call IMAP('%%', '%<++>%<++>', '')
	augroup END
endif

" }}}
" Neocomplcache {{{2
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" xell
let g:neocomplcache_disable_auto_complete = 1
let g:neocomplcache_auto_completion_start_length = 6

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
	\ 'default' : '',
	\ 'vimshell' : $HOME.'/.vimshell_hist',
	\ 'scheme' : $HOME.'/.gosh_completions'
		\ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
	let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
" imap <C-k>     <Plug>(neocomplcache_snippets_expand)
" smap <C-k>     <Plug>(neocomplcache_snippets_expand)
" inoremap <expr><C-g>     neocomplcache#undo_completion()
" inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#close_popup() . "\<CR>"
" <TAB>: completion.
" Get the char right before the cursor and determine if use completion
inoremap <expr><TAB>  strpart(getline('.'), col('.') - 2, 1) =~? '\S' ? pumvisible() ? "\<C-n>" : "\<C-X>\<C-U>" : "\<Tab>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" For cursor moving in insert mode(Not recommended)
" inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
" inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
" inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
" inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"

" AutoComplPop like behavior. i.e. auto select first item
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

" For snippet_complete marker.
" if has('conceal')
"   set conceallevel=2 concealcursor=i
" endif

" }}}
" CSS-after {{{2
let g:cssColorVimDoNotMessMyUpdatetime = 4000
" }}}
" Xell URI {{{2
command! -bang -nargs=? OpenInBrowser call OpenInBrowser(<bang>1, '<args>')
command! -nargs=0 OpenInDefaultPrg call xelltoolkit#run('', expand("%:p"))
command! -nargs=1 Es call xelltoolkit#edit_samename_file('<args>')
" }}}
" Xell WordCount {{{2
nmap <silent> <S-F6> :call ShowLiveWordCount()<CR>
" }}}
" Xell TempFile {{{2
nmap <C-s> :call XellWriteFiles()<CR>
imap <C-s> <Esc><C-s>a
" Delete all tmp files
autocmd VimLeavePre * if has("XellDeleteTempFiles") | call XellDeleteTempFiles() | endif
" }}}
" }}}

" Others {{{1

" Mathematica filetype
let filetype_m = "mma"

" SH filetype, see *sh.vim*
let g:is_bash=1
let g:sh_fold_enabled=3

" TODO
" g:processing_doc_path

" Define command WhatSyntax for looking up syntax
command! -nargs=0 -bar WhatSyntax echomsg synIDattr(synID(line("."),col("."),0),"name") synIDattr(synIDtrans(synID(line("."),col("."),0)),"name") synIDattr(synID(line("."),col("."),1),"name") synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")

" NFO view {{{2
" 能够漂亮地显示.NFO文件
" function! s:setFileEncodings(encodings)
"     let b:myfileencodingsbak=&fileencodings
"     let &fileencodings=a:encodings
" endfunction
" function! s:restoreFileEncodings()
"     let &fileencodings=b:myfileencodingsbak
"     unlet b:myfileencodingsbak
" endfunction
" 
" au BufReadPre *.nfo call <SID>setFileEncodings('cp437')|set ambiwidth=single
" au BufReadPost *.nfo call <SID>restoreFileEncodings()|set ambiwidth=double

" }}}

" }}}

" Modelines {{{1
" vim:fmr={{{,}}}:fdm=marker:foldcolumn=3:lbr:fileencoding=utf-8:ff=unix
