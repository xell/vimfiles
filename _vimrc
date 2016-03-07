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
" let g:startup_profile_csv = '/Users/xell/Code/vim/vim_startup_log.csv'
" runtime macros/startup_profile.vim
" }}}

set nocompatible

" TODO delete this?
let g:myvimfiles = glob('~/.vim')

" Pathogen {{{2
" call :Helptags after install/copy plugins into bundle
execute pathogen#infect()
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
set sessionoptions=buffers,curdir,folds,globals,help,resize,slash,tabpages,winpos,winsize

" Set local current directory
set autochdir

" Backup files setting
set nobackup
set writebackup

" Always set autoindenting on
set autoindent
"set smartindent

" In utf-8 files, use twice the width of ASCII characters
" set ambiwidth=double

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

" Expand tab to spaces
set expandtab

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

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" TODO Dictionary file
exec 'set dictionary=' . g:myvimfiles . '/dictionary.txt'

" }}}

" Special settings for Mac {{{2

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
" set noimd
autocmd GUIEnter * set noimd

" http://www.v2ex.com/t/40375
" }}}

" Use vim internal help when press K
set keywordprg=

set visualbell

" }}}

" }}}

" Xell Global Variables {{{1

" URL {{{2
let g:urlpattern = '\%(\([a-z-]\+\):\/\{2}[^ ">\])]\+\)'
" let g:webbrowser = 'Google Chrome.app'
let g:webbrowser = ''
let g:webserver_host = 'http://localhost:80/~xell'
let g:webserver_dir = glob('~/Sites')
" }}}

" TODO
" Docs should not be here {{{2

" Specify use what function to look for the output html of doc file
let g:browser_open_rules = {'t2t': 'GetOutputHTML', 'md': 'GetOutputHTML', 'mkd': 'GetOutputHTML', 'markdown': 'GetOutputHTML', 'rst': 'GetOutputHTML', 'mdindex': 'GetOutputHTML'}

" Diary rj TODO
nmap <Leader>p :exec 'e /Users/xell/Documents/notes/rj.md'<CR>

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

" No hide mouse
set nomousehide

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
set listchars=tab:▸\ ,eol:¬

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
		highlight StatusLine guifg=White guibg=#047BC1
		"highlight StatusLineNC guifg=LightGreen guibg=White
	elseif buffername =~ '\%(\.tmp\|0\)$' || expand("%:p") =~ '^\/private\/var' || expand("%:e") =~ g:xell_notes_temp_ext
		highlight StatusLine guifg=White guibg=#DA4C4D
		"highlight StatusLineNC guifg=White guibg=LightRed
	else
		highlight StatusLine ctermfg=11 ctermbg=12 cterm=none guifg=#E8E7E6 guibg=#777777 gui=none
		highlight StatusLineNC ctermfg=12 ctermbg=11 cterm=none guifg=#D3CFCD guibg=#444444 gui=none
	endif
endfunction
" }}}

" }}}

colorscheme xell

" }}}

" Mappings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""" 

" General {{{2

" Set map leader  b de gHiIJK   pq  tu wxy 
let mapleader=","
set macmeta

" }}}

" Movements {{{2

map - $

" For navigate in visible lines
" nmap \ gj
" nmap <BS> gk

"Basic motions
if &term =~? 'xterm'
	imap ˙ <Left>
	imap ∆ <Down>
	imap ˚ <Up>
	imap ¬ <Right>
	imap – <PageDown>
	imap ≠ <PageUp>
	imap § <Home>
	imap ¢ <End>
else
	imap <A-h> <Left>
	imap <A-j> <Down>
	imap <A-k> <Up>
	imap <A-l> <Right>
	imap <A--> <PageDown>
	imap <A-=> <PageUp>
	imap <A-6> <Home>
	imap <A-4> <End>
endif

" Page down and up
map <C-J> <PageDown>
map <C-K> <PageUp>

" Fold move
nnoremap <silent> <Up> :call GoUpFold()<CR>
nnoremap <silent> <Down> zj
function! GoUpFold()
	let cur = line('.')
	normal gg
	let jump = line('.')
	while (1)
		normal zj
		if ((line('.') >= cur) && (jump <= cur)) || (line('.') == jump)
			break
		else
			let jump = line('.')
		endif
	endwhile
	call cursor(jump, 1)
endfunction

" }}}

" Tabs {{{2
" Tab close
nmap <Leader>q :tabclose

" Tab previous and next
noremap <C-H> gT
noremap <C-L> gt

" Switch tabs and windows by numbers
function! s:mapleadernumber()
	for i in range(1, 9)
		exec 'nmap <Leader>' . i . ' :' . i . 'wincmd w<CR>'
		exec 'nmap <M-' . i . '> ' . i . 'gt'
	endfor
endfunction
call <SID>mapleadernumber()
if &term =~? 'xterm'
	" ¡™£¢∞
	nmap ¡ :1wincmd w<CR>
	nmap ™ :2wincmd w<CR>
	nmap £ :3wincmd w<CR>
	nmap ¢ :4wincmd w<CR>
	nmap ∞ :5wincmd w<CR>
endif
noremap ]f <C-W>gf
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
if &term =~? 'xterm'
	"∆˚˙¬ jkhl
	"ÔÓÒ JKHL
	map ∆ <C-W>j
	map ˚ <C-W>k
	map ˙ <C-W>h
	map ¬ <C-W>l
	map Ô <C-W>J
	map  <C-W>K
	map Ó <C-W>H
	map Ò <C-W>L
else
	map <M-j> <C-W>j
	map <M-k> <C-W>k
	map <M-h> <C-W>h
	map <M-l> <C-W>l
	map <M-J> <C-W>J
	map <M-K> <C-W>K
	map <M-H> <C-W>H
	map <M-L> <C-W>L
endif

" For changing the size of split windows
if &term =~? 'xterm'
	" “‘≤≥≠ [],.=
	nmap “ <C-W>-
	nmap ‘ <C-W>+
	" ”’ {}
	nmap ” <C-W>-
	nmap ’ <C-W>+
	nmap ≤ <C-W><
	nmap ≥ <C-W>>
	nmap ≠ <C-W>=
else
	nmap <M-[> <C-W>-
	nmap <M-]> <C-W>+
	nmap <M-,> <C-W><
	nmap <M-.> <C-W>>
	nmap <M-=> <C-W>=
endif

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
vnoremap <D-c> "+y

" nvo
noremap  <D-v> "+gP
cnoremap <D-v> <C-R>+
inoremap <D-v> <C-R><C-O>+

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

" }}}

" Modify texts {{{2

" For insert enter when normal
nmap <S-Enter> i<Enter><Esc>
" For delete the Tab
imap <S-Tab> <BS>

" Move line
nmap <C-Up> ddkP
nmap <C-Down> ddp

" Auto close pairs IMAP {{{3
" The latency of IMAP from latex-suite is too long to use.
let g:Imap_FreezeImap = 1
" Remap the jumpforward to other, originally <C-j>
imap <D-C-J> <Plug>IMAP_JumpForward
nmap <D-C-Y> <Plug>IMAP_JumpForward
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
inoremap <D-j> <C-O>:call <SID>imap_jump()<CR>

call xelltoolkit#imap('()', '(<++>)<++>', 0)
call xelltoolkit#imap('[]', '[<++>]<++>', 0)
call xelltoolkit#imap('{}', '{<++>}<++>', 0)
call xelltoolkit#imap('<>', '<<++>><++>', 0)
call xelltoolkit#imap('""', '"<++>"<++>', 0)
call xelltoolkit#imap("''", "'<++>'<++>", 0)
" call xelltoolkit#imap('%%', '%<++>%<++>', 0)

" for reference in windows TODO
" augroup MyIMAPs
" 	autocmd!
" 	autocmd VimEnter * call IMAP('()', '(<++>)<++>', '')
" 	autocmd VimEnter * call IMAP('[]', '[<++>]<++>', '')
" 	autocmd VimEnter * call IMAP('{}', '{<++>}<++>', '')
" 	autocmd VimEnter * call IMAP('<>', '<<++>><++>', '')
" 	autocmd VimEnter * call IMAP('""', '"<++>"<++>', '')
" 	autocmd VimEnter * call IMAP("''", "'<++>'<++>", '')
" 	autocmd VimEnter * call IMAP('%%', '%<++>%<++>', '')
" augroup END
" }}}

" }}}

" Dispaly {{{2
nmap <Leader><Leader>n :call <SID>changenumberdisplay()<CR>
function! s:changenumberdisplay()
	if &relativenumber
		set norelativenumber
	else
		set relativenumber
	endif
endfunction

nnoremap <Space> @=((foldclosed(line('.')) < 0)?'zc':'zo')<CR>

map ,hc :call SetColorColumn()<CR>
function! SetColorColumn()
    let col_num = virtcol(".")
    let cc_list = split(&cc, ',')
    if count(cc_list, string(col_num)) <= 0
        execute "set cc+=".col_num
    else
        execute "set cc-=".col_num
    endif
endfunction

" }}}

" Completions {{{2
" Complete tags
inoremap <C-]> <C-x><C-]>
" Complete definition or macros
inoremap <C-D> <C-x><C-D>
" Complete file names
inoremap <C-F> <C-x><C-F>
" Complete dictionary
" inoremap <C-K> <C-x><C-K>
" Complete whole lines
" inoremap <C-L> <C-x><C-L>

" }}}

" Special {{{2

" Edit vimrc
nmap <Leader>rce :exec 'e ' . substitute(system('readlink ' . $MYVIMRC), '\(\s\|\n\)\+$', '', '')<CR>

" Reload vimrc
nmap <Leader>rcl :so $MYVIMRC<CR>

" Edit gvimrc
nmap <Leader>rcge :e $MYGVIMRC<CR>
" Reload gvimrc
nmap <Leader>rcgl :so $MYGVIMRC<CR>

" Jump among windows noremap
if &term =~? 'xterm'
	noremap ø <Tab>
else
	noremap <A-o> <Tab>
endif

" Marked 2 support TODO
noremap <Leader>mp :silent !open -a Marked\ 2.app '%:p'<CR>

" diff two windows
command! -nargs=0 Diffthis call <SID>difftwowindows()
function! s:difftwowindows()
    diffthis
    exec "normal \<C-w>w"
    diffthis
endfunction

" }}}

" }}}

" Abbrevs {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""" 
ca xs mks! ~/Documents/xs1.vim
ca xl so ~/Documents/xs1.vim
cab xhost e /etc/hosts<CR>
cab xbp e ~/.bash_profile
" Must in /etc/sudoers set username ALL=(ALL) NOPASSWD:ALL
cab sudow silent w !sudo tee %

cab xfn echo expand("%:p")
"Insert date and time
iab xdate <C-r>=strftime("%Y-%m-%d %H:%M:%S")<CR>

" XXX temp
cab xe e ftp://xell@ftp.gowall1.veeserve.com:21/public_html/
cab xasb .s/\([^\x00-\xff]\&[^（），、：。“”；]\)\(\a\<bar>[<>_-]\)/\1 \2/g
cab xasa .s/\(\a\<bar>[<>_-]\)\([^\x00-\xff]\&[^（），、：。“”；]\)/\1 \2/g

" }}}

" Scripts {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""" 

" XellNotes {{{2
let g:xell_notes_root = glob('~/Documents/notes/notes')
let g:xell_notes_ex_root = glob('~/Documents/notes/notes_preview')
" TODO it should not be connected with ffs
" i.e. ffs should be more general, not focusing with notes
let g:xell_notes_default_ext = 'md'
let g:xell_notes_temp_ext = 'tempnote'
" }}}

" Blockdiff {{{2
vmap ,d1 :call BlockDiff_GetBlock1()<CR>
vmap ,d2 :call BlockDiff_GetBlock2()<CR>
" }}}
" BufExplorer {{{2
let g:bufExplorerShowUnlisted=1
" }}}
" Colorizer {{{2
nmap <silent> <F6> <Plug>Colorizer
let g:colorizer_startup = 0
" }}}
" CtrlP {{{2
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_reuse_window = 'netrw\|quickfix'
" }}}
" Emmet {{{2
let g:user_emmet_leader_key = '<D-e>'
" If you want to complete tags using |omnifunc| then add this.
let g:use_emmet_complete_tag = 1
" Enable just for html/css
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
" }}}
" Edit Existing {{{2
" Can not use the following because mvim will warning 
" Error detected while processing /Applications/MacVim.app/Contents/Resources/vim/runtime/macros/editexisting.vim:
" line   71:
" E122: Function <SNR>12_EditElsewhere already exists, add ! to replace it
" runtime macros/editexisting.vim
" }}}
" FFS {{{2
nmap <Leader><Leader><Leader> :call FFS()<CR>
let g:ffs_forbiden_path = ['/Users/xell', '/Users/xell/Library', '/Users/xell/Codes', '/Users/xell/Documents', '/Applications', '/Library']
" }}}
" Fugitive {{{2
nmap <Leader>gs :Gstatus<CR>
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
" FuzzyFinder {{{2
let g:fuf_modesDisable = ['aroundmrufile', 'mrucmd', 'dir', 'bookmark', 'taggedfile', 'line', 'quickfix']
let g:fuf_keyPreview = '<C-H>'
let g:fuf_keyOpenTabpage = '<C-Return>'

" Usage : ,fe n:
nmap <Leader>fe :FufFile<CR>
let g:fuf_abbrevMap = {
            \ "^v:" : ['$VIM/**/',],
            \ "^n:" : [g:xell_notes_root . '/'],
            \ }

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
" Gitv {{{2
nnoremap <Leader>gV :Gitv --all<CR>
nnoremap <Leader>gv :Gitv! --all<CR>
vmap <leader>gv :Gitv! --all<cr>
" }}}
" Gundo {{{2
"let g:gundo_disable=1
nnoremap <F5> :GundoToggle<CR>
" }}}
" Hostslist {{{2
let g:hosts_list = '/Users/xell/Code/pac/xell.hostslist'
" }}}
" LanguageTool {{{2
let g:languagetool_jar = '/usr/local/Cellar/languagetool/2.7/libexec/languagetool-commandline.jar'
nmap <F7> :LanguageToolCheck<CR>
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
let g:tex_fold_enabled = 0

" Display the spell highlight beyond the syntax highlights
autocmd BufReadPost,FileReadPost *.tex syntax spell toplevel
" autocmd BufReadPost,FileReadPost,BufWinEnter *.tex normal ,rf

" g:Imap_UsePlaceHolders=0
" g:Tex_IgnoredWarnings
" g:Tex_IgnoreLevel

let g:Tex_SmartKeyBS=0
let g:Tex_SmartKeyQuote=0
let g:Tex_SmartKeyDot=1

let g:Tex_CatchVisMapErrors = 1

" Set customized folding, see folding.vim
let g:Tex_FoldedSections = 'part,chapter,chapterp,section,%%fakesection,'
						\. 'subsection,subsubsection,'
						\. 'paragraph'
let g:Tex_UsePython=1
let g:Tex_DefaultTargetFormat = 'pdf'
"let g:Tex_CompileRule_dvi = 'latex --src-specials -interaction=nonstopmode $*'
let g:Tex_CompileRule_pdf = 'xelatex --synctex=1 -src-specials -interaction=nonstopmode $*'
"let g:Tex_CompileRule_pdf = 'latexmk --synctex=-1 -src-specials -interaction=nonstopmode $*'
" let g:Tex_CompileRule_pdf = 'latexmk -pdf $*'
" Set viewrule
let g:Tex_ViewRule_pdf = 'Skim'
" Suppress fake latexmk warnings
let g:Tex_IgnoredWarnings =
        \"Underfull\n".
        \"Overfull\n".
        \"specifier changed to\n".
        \"You have requested\n".
        \"Missing number, treated as zero.\n".
        \"There were undefined references\n".
        \"Citation %.%# undefined\n".
        \"Hyper reference `bhfn\n".
        \"Label(s) may have changed"
let g:Tex_IgnoreLevel = 9

if &term =~? 'xterm'
	imap … <Plug>Tex_LeftRight
	nmap … <Plug>Tex_LeftRight
else
	imap <A-;> <Plug>Tex_LeftRight
	nmap <A-;> <Plug>Tex_LeftRight
endif
" Change the default <F7>->FastCommandInsert to <C-F7>
nmap <C-F7> <Plug>Tex_FastCommandInsert

" }}}
" local_vimrc {{{2
let g:local_vimrc = ".exrc"
" }}}
" Matchit {{{2
" TODO define some new block
runtime macros/matchit.vim
" }}}
" MarksBrowser {{{2
"let g:marksCloseWhenSelected = 0
let g:marksShowTypes = "abcdefghijklmnopqrstuvwxyz" . "ABCDEFGHIJKLMNOPQRSTUVWXYZ" . "0123456789.'`^<>\""
nmap <Leader>mb :MarksBrowser<cr><cr>
" Default
"let s:all_marks = "abcdefghijklmnopqrstuvwxyz.'`^<>\""
" }}}
" Neocomplete {{{2
if $SUDO_USER == ''
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Use camel case completion.
let g:neocomplete#enable_camel_case = 1
" Use underbar completion.
"? let g:neocomplete_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" xell
let g:neocomplete#disable_auto_complete = 1
let g:neocomplete#auto_completion_start_length = 6

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
" inoremap <expr><C-g>     neocomplete#undo_completion()
" inoremap <expr><C-l>     neocomplete#complete_common_string()

" For smart TAB completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
       \ <SID>check_back_space() ? "\<TAB>" :
       \ neocomplete#start_manual_complete()
 function! s:check_back_space() "{{{
   let col = col('.') - 1
   return !col || getline('.')[col - 1]  =~ '\s'
 endfunction "}}}

" Recommended key-mappings.
" <CR>: close popup and save indent.
" old cache: inoremap <expr><CR>  neocomplete#close_popup() . "\<CR>"
" <TAB>: completion.
" Get the char right before the cursor and determine if use completion
" old cache: inoremap <expr><TAB>  strpart(getline('.'), col('.') - 2, 1) =~? '\S' ? pumvisible() ? "\<C-n>" : "\<C-X>\<C-U>" : "\<Tab>"
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown,pandoc setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.php =
\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.c =
\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.cpp =
\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl =
\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

else
	let g:loaded_neocomplete = 1
endif

" }}}
" NERDTree {{{2
let NERDTreeShowBookmarks = 1
nmap <Leader>t :NERDTreeToggle<CR>
nmap <Leader>b :NERDTreeFromBookmark 
" }}}
" OpenURI {{{2
" Open or yank web url
nmap <Leader>Y :call Open()<CR>
nmap <expr> <Leader>y xelltoolkit#get_copy(xelltoolkit#get_word_at_cursor(g:urlpattern))
command! -bang -nargs=? OpenInBrowser call OpenInBrowser(<bang>1, '<args>')
command! -nargs=0 OpenInDefaultPrg call xelltoolkit#run('', expand("%:p"))
command! -nargs=1 Es call xelltoolkit#edit_samename_file('<args>')
" }}}
" Pandoc markdown filetype {{{2
let g:pandoc_syntax_accuracy = 1
let g:pandoc_syntax_full_html_tex = 1
let g:pandoc_syntax_table = 0
let g:pandoc_fold_level = 2
" }}}
" Proxylist {{{2
let g:proxy_list = '/Users/xell/Code/pac/xell.proxylist'
let g:proxy_pac = '/Users/xell/Sites/proxylist.pac'
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
" SessionManager {{{2
let g:session_path = glob('~/.vimsession')
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
" Table-Mode {{{2
" ReST-compatible tables
let g:table_mode_corner_corner="+"
let g:table_mode_header_fillchar="="
let g:table_mode_delimiter = '|'
" }}}
" Taglist {{{2
let g:Tlist_Show_One_File=1
let Tlist_Sort_Type = "name"
highlight link MyTagListFileName Identifier
highlight link MyTagListTagName Type

" For toggle the Tlist windows
nmap <F10> :TlistToggle<CR>
imap <F10> <ESC><F10>i
" }}}
" tComment {{{2
" While gcc respects indent blank, I defined gcl to put comment character
" right in the first column.
nnoremap gcl :let g:tcommentOptions = {'col': 1}<CR>:normal gcc<CR>:let g:tcommentOptions = {}<CR>
let g:tcommentOptions = {}
let g:tcommentBlockXML = "<!--%s-->\n"
let g:tcomment_types = {'pandoc': "<!-- %s -->", 'pandoc_inline': "<!-- %s -->", 'pandoc_block': "<!-- %s -->\n  ", 'proxylist': '#%s', 'conf': '#%s', 'hostslist': '#%s', 'mdindex': '# %s'}
" }}}
" Thesaurus {{{2
" mac or unix must use '/usr/share/myspell/dicts/th_en_US_v2.idx'
" or assign g:thesaurus_file
imap <c-t> <Esc>bl:Thesaurus<CR>
" }}}
" VOoM {{{2
let g:voom_tree_placement="right"
let g:voom_tree_width=30
"let g:voom_user_command = "so $VIM/vimfiles/voom_addons/mediawiki.vim"
let g:voom_tab_key = '<C-Tab>'
let g:voom_return_key = '<C-Return>'

nmap <silent> <Leader>; :call BuildVOoMTOC()<CR>
" BuildVOoMTOC  {{{3
function! BuildVOoMTOC()
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
" WinFullScreen {{{2
nnoremap <C-Enter> :WinFullScreen<CR>
" }}}
" WordCount {{{2
nmap <silent> <S-F6> :call ShowLiveWordCount()<CR>
" }}}

" Xell Other {{{2
"delete the current file
com! Rm call xelltoolkit#delete_file()
"delete the file and quit the buffer (quits vim if this was the last file)
com! RM call xelltoolkit#delete_file() <Bar> bd!
com! URL call xelltoolkit#get_copy(xelltoolkit#get_file_url())
" }}}
" }}}

" Others {{{1

" Test

" autocmd BufRead *.md ToggleFoldMethod
cab mmm match Temp /\~\~../
cab xxc bd book.log <bar> ccl

set exrc

" Mathematica filetype
let filetype_m = "mma"

" SH filetype, see *sh.vim*
let g:is_bash=1
let g:sh_fold_enabled=3

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
