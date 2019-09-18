""""""""""""""""""""""""""""""""""""""""""""""""""""" 
"
"  \  /
"   \/   |--  |    |
"   /\   |--  |    |
"  /  \  |--  |--  |--
"
" New: V8
" Maintainer: Xell Liu <xell DOT liu AT gmail.com>


" Pre {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""" 

" Use third-part macro to track the startup time {{{2
" let g:startup_profile_csv = '/Users/xell/Code/vim/vim_startup_log.csv'
" runtime macros/startup_profile.vim
" }}}

set nocompatible

" }}}

" Xell Global Variables {{{1

" URL {{{2
let g:urlpattern = '[a-z]\w\+:\/\/[^ "' . "'>\\])]\\+"
let g:webbrowser = ''
let g:webserver_host = 'http://localhost:80/~xell'
let g:webserver_dir = glob('~/Sites')
" }}}

" TODO
" Docs should not be here {{{2

" Specify use what function to look for the output html of doc file
let g:browser_open_rules = {'t2t': 'GetOutputHTML', 'md': 'GetOutputHTML', 'mkd': 'GetOutputHTML', 'markdown': 'GetOutputHTML', 'rst': 'GetOutputHTML', 'mdindex': 'GetOutputHTML'}

" }}}

" }}}

" General Options {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""" 

" General {{{2

" Enable file type detection and indent
filetype plugin indent on

" Viminfo file
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

" Options in sessions
" TODO consider localoptions,options
set sessionoptions=buffers,curdir,folds,globals,help,resize,slash,tabpages,winpos,winsize

" Set local current directory
set autochdir

" Backup files setting
set nobackup
set writebackup

" Set ctrl-a and ctrl-x target
set nrformats+=alpha

" Always set autoindenting on
set autoindent

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

set iskeyword+=-

" Set the swap file directory with flat structure
set directory^=$HOME/.vimtmp//

" Use vim internal help when press K
set keywordprg=

" c.f. https://gist.github.com/xge/2422950
set dictionary=/usr/share/dict/words
set complete+=k
set infercase

set exrc

set updatetime=500

" }}}

" Filetypes {{{2

" autocmd BufRead *.md ToggleFoldMethod

" Deal with large file
"autocmd BufWinEnter * if line2byte(line("$") + 1) > 200000 | syntax clear | echomsg "Large File" | endif

" Mathematica filetype
let filetype_m = "mma"

" SH filetype, see *sh.vim*
let g:is_bash=1
let g:sh_fold_enabled=3

" 解决crontab -e时，提示crontab: temp file must be edited in place
" https://blog.csdn.net/xuyaqun/article/details/44458987
autocmd filetype crontab setlocal nobackup nowritebackup

" }}}

" IME setting {{{2

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
" set ims=1

autocmd GUIEnter * set noimd

" http://www.v2ex.com/t/40375
" }}}

" }}}

" Display and Interface {{{1

" General {{{2

" Enable syntax hl
syntax enable

" Language
set langmenu=none
language messages en_US

" Set file encode
set encoding=utf-8
set fileencodings=utf-8,cp936

" In utf-8 files, use twice the width of ASCII characters
set ambiwidth=double

set breakindent

set visualbell

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

" Use symbols to fill the blank of tab and eol
set listchars=tab:▸\ ,eol:¬

set termguicolors

" Non-GUI tabline
" http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line
function MyTabLine() "{{{
    let s = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
        let buflist = tabpagebuflist(i)
        let winnr = tabpagewinnr(i)
        let s .= '%' . i . 'T'
        let s .= (i == t ? '%1*' : '%2*')
        let s .= '%#Constant#'
        let s .= ' '
        let s .= i . ' '
        let s .= '%#TabLine#'
        let s .= winnr . '/' . tabpagewinnr(i,'$')
        let s .= ' %*'
        let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
        let bufnr = buflist[winnr - 1]
        let file = bufname(bufnr)
        let buftype = getbufvar(bufnr, 'buftype')
        if buftype == 'nofile'
            if file =~ '\/.'
                let file = substitute(file, '.*\/\ze.', '', '')
            endif
        else
            let file = fnamemodify(file, ':p:t')
        endif
        if file == ''
            let file = '[No Name]'
        endif
        let s .= file
        let i = i + 1
    endwhile
    let s .= '%T%#TabLineFill#%='
    let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
    return s
endfunction "}}}
set tabline=%!MyTabLine()

" }}}

" Foldtext  {{{2
" http://www.gregsexton.org/2011/03/improving-the-text-displayed-in-a-fold/
set foldtext=CustomFoldText(0)
function! CustomFoldText(n) 
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
endfunction
"}}}

" Statusline customization {{{2
set laststatus=2
let g:mystatusline1 = '\ %{winnr()}\ %<%f\ %h%y%m%r\ [%{&ff}]\ [%{&fenc}]'
let g:mystatusline2 = '%=%-14.(%l,%c%V%)\ %L\ %P\ '

exec 'set statusline=' . g:mystatusline1 . g:mystatusline2

" Highlight statusbar according to the type of buffer {{{3
let g:aug_vimsb_enable = 1
augroup vimSB
	autocmd!
	autocmd BufNew,BufEnter,BufRead,BufWrite,TabEnter,TabLeave,WinEnter,WinLeave * if g:aug_vimsb_enable | call <SID>XellBufferStatuslineHighlight() | endif
	au QuickfixCmdPost make call xelltoolkit#qf_make_conv()
augroup END

function! s:XellBufferStatuslineHighlight()
	let buffername = bufname("%")
	if empty(buffername)
        highlight! link StatusLine Question
	elseif buffername =~ '\%(\.tmp\|0\)$' || expand("%:p") =~ '^\/private\/var' || expand("%:e") =~ g:xell_notes_temp_ext
        highlight! link StatusLine WarningMsg
	else
        highlight! link StatusLine StatusLine
        highlight! link StatusLineNC StatusLineNC
	endif
endfunction
" }}}

" }}}

colorscheme xell_dark

" }}}

" Mappings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""" 

" General {{{2

" Set map leader  b de gHiIJK   pq  tu wxy 
let mapleader=","
set macmeta
nnoremap Q q:
" }}}

" Movements {{{2

nmap - $
vmap - $h

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
	inoremap <C-h> <Left>
	inoremap <C-l> <Right>
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
        " Work with BetterTouchTool corresponding setting
		exec 'nmap <S-F' . i . '> ' . i . 'gt'
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
nmap <Leader>v <C-W>v<C-W>l

" Switch two windows back and forth
noremap <Backspace> <C-W>p
noremap ` <C-W>w

" For switch to split windows
" GUI keys are set up by BetterTouchTool due to the conflict of :terminal
if &term =~? 'xterm'
	" equal to map <M-j> <C-W>j ...
	map ∆ <C-W>j
	map ˚ <C-W>k
	map ˙ <C-W>h
	map ¬ <C-W>l
	map Ô <C-W>J
	map  <C-W>K
	map Ó <C-W>H
	map Ò <C-W>L
endif

" Jump among windows clockwise
if &term =~? 'xterm'
	noremap ø <C-W>w
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
nmap <Leader>l viw"zy:lv /<C-R>z/ %<CR>:lw<CR>/\c<C-R>z<CR>
vmap <Leader>l "zy:lv /<C-R>z/ %<CR>:lw<CR>/\c<C-R>z<CR>
" TODO use ag
nmap <Leader>L viw"zy:call xelltoolkit#grep_in_lcd_r('','',"<C-R>z")<CR>:cw<CR>/\c<C-R>z<CR>
vmap <Leader>L "zy:call xelltoolkit#grep_in_lcd_r('','',"<C-R>z")<CR>:cw<CR>/\c<C-R>z<CR>

" Look up the visual selection in Google
vmap <D-k> "zy:silent !open "https://www.google.com/?q=<C-R>z"<CR>
" Look up the word under the cursor in Dictionary.app
nmap <silent> <D-k> :silent !open "dict://<cword>"<CR>

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

" Auto close pairs IMAP
" The latency of IMAP from latex-suite is too long to use.
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
call xelltoolkit#imap('%%', '%<++>%<++>', 0)

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

" Dispaly {{{2
nmap <Leader>nn :call <SID>changenumberdisplay()<CR>
function! s:changenumberdisplay()
	if &relativenumber
		set norelativenumber
	else
		set relativenumber
	endif
endfunction

nnoremap <Space> @=((foldclosed(line('.')) < 0)?'zc':'zo')<CR>

map <Leader>hc :call SetColorColumn()<CR>
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
" Complete dictionary
imap <D-d> <C-x><C-K>
" Complete file names
imap <D-f> <C-x><C-F>
" Complete whole lines
imap <D-l> <C-x><C-L>

" }}}

" Special {{{2

" Edit vimrc
nmap <Leader>rce :exec 'e ' . substitute(system('readlink ' . $MYVIMRC), '\(\s\|\n\)\+$', '', '')<CR>

" Reload vimrc
nmap <Leader>rcl :so $MYVIMRC<CR>

" Edit gvimrc
nmap <Leader>rcge :exec 'e ' . substitute(system('readlink ' . $MYGVIMRC), '\(\s\|\n\)\+$', '', '')<CR>
" Reload gvimrc
nmap <Leader>rcgl :so $MYGVIMRC<CR>

" }}}

" }}}

" Commands and Others {{{1

" Wipe out designated named registers
function! WipeDesignatedNamedRegisters()
    registers abcdefghijklmnopqrstuvwxyz
    let to_be_wiped_out = input("Please enter the named registers to be wiped out\n")
    echo to_be_wiped_out
    for c in split(to_be_wiped_out, '\zs')
        silent! call setreg(c, '')
    endfor
    echo "Done!\n"
    registers abcdefghijklmnopqrstuvwxyz
endfunction

" diff two windows
command! -nargs=0 Diffthis call <SID>difftwowindows()
function! s:difftwowindows()
    diffthis
    exec "normal \<C-w>w"
    diffthis
endfunction

" Spell cjk
command! -nargs=0 Spell call <SID>spell_check()
function! s:spell_check()
    if &spell
        setlocal nospell
    else
        setlocal spell spelllang=en_us,cjk
        " https://stackoverflow.com/questions/18196399/exclude-capitalized-words-from-vim-spell-check
        syn match myExCapitalWords +\<\w*[A-Z]\K*\>\|'s+ contains=@NoSpell
    endif
endfunction

augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                \ |   exe "normal! g`\""
                \ | endif

augroup END

" Xell Other
" TODO https://github.com/tpope/vim-eunuch
"delete the current file
com! Rm call xelltoolkit#delete_file()
"delete the file and quit the buffer (quits vim if this was the last file)
com! RM call xelltoolkit#delete_file() <Bar> bd!

com! URL call xelltoolkit#get_copy(xelltoolkit#get_file_url())

" Define command WhatSyntax for looking up syntax
command! -nargs=0 -bar WhatSyntax echomsg synIDattr(synID(line("."),col("."),0),"name") synIDattr(synIDtrans(synID(line("."),col("."),0)),"name") synIDattr(synID(line("."),col("."),1),"name") synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")

" Capitalization of the current line
" Capitalize all words in titles of publications and documents, except a, an, the, at, by, for, in, of, on, to, up, and, as, but, or, and nor.
" https://taptoe.wordpress.com/2013/02/06/vim-capitalize-every-first-character-of-every-word-in-a-sentence/
command! -nargs=0 Capitalize s/\v^\a|\:\s\a|<%(a>|an>|and>|as>|at>|but>|by>|for>|in>|nor>|of>|on>|or>|the>|to>|up>)@!\a/\U&/g


" Bonly {{{2
" https://github.com/schickling/vim-bufonly
command! -nargs=? -complete=buffer -bang Bonly
    \ :call BufOnly('<args>', '<bang>')
function! BufOnly(buffer, bang)
	if a:buffer == ''
		" No buffer provided, use the current buffer.
		let buffer = bufnr('%')
	elseif (a:buffer + 0) > 0
		" A buffer number was provided.
		let buffer = bufnr(a:buffer + 0)
	else
		" A buffer name was provided.
		let buffer = bufnr(a:buffer)
	endif

	if buffer == -1
		echohl ErrorMsg
		echomsg "No matching buffer for" a:buffer
		echohl None
		return
	endif

	let last_buffer = bufnr('$')

	let delete_count = 0
	let n = 1
	while n <= last_buffer
		if n != buffer && buflisted(n)
			if a:bang == '' && getbufvar(n, '&modified')
				echohl ErrorMsg
				echomsg 'No write since last change for buffer'
							\ n '(add ! to override)'
				echohl None
			else
				silent exe 'bdel' . a:bang . ' ' . n
				if ! buflisted(n)
					let delete_count = delete_count+1
				endif
			endif
		endif
		let n = n+1
	endwhile

	if delete_count == 1
		echomsg delete_count "buffer deleted"
	elseif delete_count > 1
		echomsg delete_count "buffers deleted"
	endif

endfunction
" }}}
" }}}

" Abbrevs {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""" 
ca xs mks! ~/Documents/xs1.vim
ca xl so ~/Documents/xs1.vim

" Must in /etc/sudoers set username ALL=(ALL) NOPASSWD:ALL
cab sudow silent w !sudo tee %
cmap w!! w !sudo tee % >/dev/null

cab xfn echo expand("%:p")
"Insert date and time
iab xdate <C-r>=strftime("%Y-%m-%d %H:%M:%S")<CR>

" }}}

" Scripts {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""" 

" XellNotes {{{2
let g:xell_notes_root = glob('~/Documents/notes/notes/notes')
let g:xell_notes_ex_root = glob('~/Documents/notes/notes_preview')
" TODO it should not be connected with ffs
" i.e. ffs should be more general, not focusing with notes
let g:xell_notes_default_ext = 'md'
let g:xell_notes_temp_ext = 'tempnote'
nmap <Leader>rj :exec 'e /Users/xell/Documents/notes/rj.md'<CR>
" nmap <Leader>pr :exec 'e /Users/xell/Documents/notes/projects/main.xproject'<CR>
" }}}

" Blockdiff {{{2
vmap ,d1 :call BlockDiff_GetBlock1()<CR>
vmap ,d2 :call BlockDiff_GetBlock2()<CR>
" }}}
" BufExplorer {{{2
let g:bufExplorerShowUnlisted=1
" }}}
" Colorizer {{{2
nmap <silent> <S-D-F6> <Plug>Colorizer
let g:colorizer_startup = 0
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
packadd! editexisting
" }}}
" FFS {{{2
" TODO
" nmap <Leader><Leader><Leader> :call FFS()<CR>
let g:ffs_forbiden_path = ['/Users/xell', '/Users/xell/Library', '/Users/xell/Codes', '/Users/xell/Documents', '/Applications', '/Library']
" }}}
" Fugitive {{{2
nmap <Leader>gs :Gstatus<CR>
nmap <Leader>gd :Gvdiff<CR>
nmap <Leader>gD :Gdiff<CR>
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
" nmap <Leader>fe :FufFile<CR>
let g:fuf_abbrevMap = {
            \ "^v:" : ['$VIM/**/',],
            \ "^n:" : [g:xell_notes_root . '/'],
            \ }

" nmap <Leader>ff :FufMruFile<CR>
" All file in current directory recursively
" nmap <Leader>fd :FufCoverageFile<CR>
" nmap <Leader>ft :FufTag<CR>
" nmap <Leader>fh :FufHelp<CR><C-E>
" nmap <Leader>fb :FufBuffer<CR>

" nmap <Leader>fc :call fuf#givencmd#launch('', 0, '>', <SID>getAllCommands())<CR>
function! s:getAllCommands()
  redir => commands
  silent command
  redir END
  return map((split(commands, "\n")[3:]),
	  \      '":" . matchstr(v:val, ''^....\zs\S*'')')
endfunction

" All user vimfiles
" nmap <Leader>fg :call <SID>fuf_vimfiles()<CR>
function! s:fuf_vimfiles()
	exec "call fuf#givenfile#launch('', 0, '>', split(glob('" . split(&rtp, ',')[0] . "/**/*'), \"\\n\"))"
endfunction

" nmap <Leader>fn :call <SID>fuf_notes()<CR>
function! s:fuf_notes()
	exec "call fuf#givenfile#launch('', 0, '>', split(glob('" . g:xell_notes_root . "/**/*'), \"\\n\"))"
endfunction

" }}}
" fzf {{{2
" https://github.com/junegunn/fzf#as-vim-plugin
" https://github.com/junegunn/fzf/blob/master/README-VIM.md
set rtp+=/usr/local/opt/fzf
let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'up': '~20%' }
nmap <Leader>fe :Files<CR>
nmap <Leader>ft :Tags<CR>
nmap <Leader>fh :Helptags<CR>
nmap <Leader>fb :Buffers<CR>
nmap <Leader>fc :Commands<CR>
nmap <Leader>fl :BLines<CR>
nmap <Leader>fL :Lines<CR>
nmap <Leader>fm :Marks<CR>
nmap <Leader>fw :Windows<CR>
nmap <Leader>fv :Files ~/.vim<CR>
nmap <Leader>fn :Files <C-R>=g:xell_notes_root<CR><CR>

" https://github.com/junegunn/fzf.vim/issues/54
" https://github.com/junegunn/fzf.vim/issues/228
" https://github.com/junegunn/fzf.vim/commit/8ea2e872d7ac7492b86bcca16ccd5d5021663efb
command! -bang -nargs=* AG call fzf#vim#ag(<q-args>, '-S', {'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all'}, <bang>0)
nmap <Leader><Leader><Leader> :AG<CR>

nmap <Leader>ff :FZFMru<CR>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
" TODO supertab
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using autoload functions
" inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '20'})

" }}}
" Gitv {{{2
nnoremap <Leader>gV :Gitv --all<CR>
nnoremap <Leader>gv :Gitv! --all<CR>
vmap <leader>gv :Gitv! --all<cr>
" }}}
" Grammarous LanguageTool {{{2
let g:grammarous#use_vim_spelllang = 1
let g:grammarous#languagetool_cmd = 'languagetool'
let g:grammarous#show_first_error = 1
" https://github.com/rhysd/vim-grammarous/issues/78
command! -nargs=0 -bar GrammarousReopen call grammarous#create_update_info_window_of(b:grammarous_result)
nmap <M-D-l> :GrammarousCheck<CR>
" }}}
" Hostslist {{{2
let g:hosts_list = '/Users/xell/Code/pac/xell.hostslist'
" }}}
" Julia {{{2
let g:latex_to_unicode_tab = 0
let g:latex_to_unicode_auto = 1
let g:default_julia_version = "devel"

let g:tagbar_type_julia = {
    \ 'ctagstype' : 'julia',
    \ 'kinds'     : [
        \ 't:struct', 'f:function', 'm:macro', 'c:const']
    \ }
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

" Remap the jumpforward to other, originally <C-j>
let g:Imap_FreezeImap = 1
imap <D-C-j> <Plug>IMAP_JumpForward
nmap <D-C-y> <Plug>IMAP_JumpForward

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" }}}
" Matchit {{{2
" TODO define some new block
packadd matchit
" }}}
" Neocomplete {{{2
" TODO
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
" inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
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
nmap <Leader>O :OpenInBrowser<CR>
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
" Tagbar {{{2
let g:tagbar_iconchars = ['▸', '▾']
let g:tagbar_sort = 0
let g:tagbar_autofocus = 1
let g:tagbar_map_togglefold = '<Space>'

nmap <F10> :TagbarToggle<CR>
highlight link TagbarType Ignore
" }}}
" tComment {{{2
" While gcc respects indent blank, I defined gcl to put comment character
" right in the first column.
nnoremap gcl :let g:tcommentOptions = {'col': 1}<CR>:normal gcc<CR>:let g:tcommentOptions = {}<CR>
let g:tcomment#options = {}
let g:tcomment#block_fmt_xml = "<!--%s-->\n"
let g:tcomment_types = {'julia': "#= %s =#", 'julia_inline': "# %s", 'pandoc': "<!-- %s -->", 'pandoc_inline': "<!-- %s -->", 'pandoc_block': "<!-- %s -->\n  ", 'proxylist': '#%s', 'conf': '#%s', 'hostslist': '#%s', 'mdindex': '# %s'}
nmap <D-/> gcc
vmap <D-/> gc
" }}}
" WinFullScreen {{{2
nnoremap <C-Enter> :WinFullScreen<CR>
" }}}
" WordCount {{{2
nmap <silent> <F3> :call ShowLiveWordCount()<CR>
" }}}

" }}}

" Test {{{1

cab mmm match Temp /\~\~../

" TODO temp
" add space between
cab xasb .s/\([^\x00-\xff]\&[^（），、：。“”；]\)\(\a\<bar>[<>_-]\)/\1 \2/g
cab xasa .s/\(\a\<bar>[<>_-]\)\([^\x00-\xff]\&[^（），、：。“”；]\)/\1 \2/g

" au BufEnter * if &ft ==# 'xml' | commands | endif

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

" TMUX {{{2
" https://superuser.com/a/713335
" if exists('$TMUX')
"     let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"     let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
" else
"     let &t_SI = "\<Esc>]50;CursorShape=0\x7"
"     let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" endif
" }}}

" }}}

" Modelines {{{1
" vim:fmr={{{,}}}:fdm=marker:foldcolumn=3:lbr:fileencoding=utf-8:ff=unix
