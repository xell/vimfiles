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
" }}}

" Temp {{{2
" XXX need to be deleted after re-constructed
if g:isw
	let g:myvim_dir = 'V:'
else
	let g:myvim_dir = '/Users/xell/Z/testvimfiles'
endif
let g:myvimfiles = g:myvim_dir . '/vimfiles'
let g:myvimfiles_after = g:myvimfiles . '/after'
" $VIM win: d:\p\vim
"      mac: /Applications/MacVim.app/Contents/Resources/vim
" $VRT win: d:\p\vim\vim73
"      mac: /Applications/MacVim.app/Contents/Resources/vim/runtime
" BIN  win: d:\p\vim\vim73\gvim.exe vim.exe
"      mac: /Applications/MacVim.app/Contents/MacOS/MacVim Vim
exec 'set runtimepath=' . g:myvimfiles . ',$VIMRUNTIME,' . g:myvimfiles_after
let $MYVIMRC = g:myvim_dir . '/vimrc'
let $MYGVIMRC = g:myvim_dir . '/gvimrc'
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
" ex: in win, typing d:\ and hit <Tab>, it will be d:/ automatically
" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
if g:isw
	set shellslash
endif

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" TODO Dictionary file
if exists("g:myvimfiles")
	exec 'set dictionary=' . g:myvimfiles . '/dictionary.txt'
else
	if g:isw
		exec 'set dictionary=' . substitute($VIM, '\', '/', 'g') . '/vimfiles/dictionary.txt'
	else
		exec 'set dictionary=' . glob('~/.vim') . '/dictionary.txt'
	endif
endif

" }}}

" Special settings for Mac {{{2
if g:ism
	" IME setting {{{3
	
	" function! s:setim()
	" if &imd
	" 	set imd
	" 	set noimd
	" 	echo "Chinese enable."
	" else
	" 	set imd
	" 	echo "English only."
	" endif
	" endfunction

	" nmap <D-i> :call <SID>setim()<CR>
	" imap <D-i> <Esc>:call <SID>setim()<CR>i
	
	set imd
	set noimd
	" }}}

	" Use vim internal help when press K
	set keywordprg=

	set visualbell

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

" Insert mode credits {{{2
" Mappings to facilitate the creation of text
"
" Author: Suresh Govindachar
" Date: November 5, 2001
" To enable viewing messages from commands issued using the mappings presented here
"set cmdheight=2
" }}}

" Movements {{{2

map - $

" For navigate in visible lines
nmap \ gj
nmap <BS> gk

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

" Switch windows in order
noremap <C-Tab> <C-W>w

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
	vnoremap <C-C> "+y
	noremap <C-Q>		<C-V>
	map <C-V>		"+gP
	cmap <C-V>		<C-R>+
	" from http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
	" Pasting blockwise and linewise selections is not possible in Insert and
	" Visual mode without the +virtualedit feature.  They are pasted as if they
	" were characterwise instead.
	" Uses the paste.vim autoload script.
	"exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
	exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
	exe 'inoremap <script> <C-V> <C-g>u'.paste#paste_cmd['i']
	vnoremap <C-X> "+x
else
	" Redefine <D-v> in macmap.vim FIXME fail...
	"execute 'inoremap <script> <special> <D-v>' paste#paste_cmd['i']
	execute 'inoremap <script> <special> <D-v> <C-g>u'.paste#paste_cmd['i']
endif
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

" }}}

" Modify texts {{{2

" For insert enter when normal
nmap <S-Enter> i<Enter><Esc>
" For delete the Tab
imap <S-Tab> <BS>

" Move line
nmap <C-Up> ddkP
nmap <C-Down> ddp
" }}}

" Dispaly {{{2
nmap ` :call <SID>changenumberdisplay()<CR>
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
	ca xs mks! d:/w/xs1.vim
	ca xl so d:/w/xs1.vim
	cab xrj e d:\W\notes\rj.t2t
	cab xhost e c:/windows/system32/drivers/etc/hosts<CR>
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

" Others {{{1

" Mathematica filetype
let filetype_m = "mma"

" SH filetype, see *sh.vim*
let g:is_bash=1
let g:sh_fold_enabled=3

" tex: Display the spell highlight beyond the syntax highlights
" vimrcEx
autocmd BufReadPost,FileReadPost *.tex syntax spell toplevel

" Define command WhatSyntax for looking up syntax
command! -nargs=0 -bar WhatSyntax echomsg synIDattr(synID(line("."),col("."),0),"name") synIDattr(synIDtrans(synID(line("."),col("."),0)),"name") synIDattr(synID(line("."),col("."),1),"name") synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
" }}}

" Modelines {{{1
" vim:fmr={{{,}}}:fdm=marker:foldcolumn=3:lbr:fileencoding=gbk:ff=unix
