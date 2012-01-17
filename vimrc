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



" Others {{{1

" Mathematica filetype
let filetype_m = "mma"

" }}}

" Modelines {{{1
" vim:fmr={{{,}}}:fdm=marker:foldcolumn=3:lbr:fileencoding=gbk:ff=unix
