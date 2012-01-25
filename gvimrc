""""""""""""""""""""""""""""""""""""""""""""""""""""" 
"
"  \  /
"   \/   |--  |    |
"   /\   |--  |    |
"  /  \  |--  |--  |--
"
" Maintainer: Xell Liu <xell DOT liu AT gmail.com>
" Note: For use font with Chinese name in Windows,
"       this file must be cp936 encoding.


" Popup confirmation window
set confirm

" Don't hide mouse, or the cursor will flash in the title
"set nomousehide

" Transparency only for MacVim GUI
if g:ism && &term == 'builtin_gui'
	set transparency=4
endif

" Set colorscheme {{{1
"let g:zenburn_high_Contrast = 1
"let g:zenburn_color_also_Ignore = 1
"colorscheme zenburn
colorscheme xellwr-light
" }}}

" Guioptions {{{1
" e gui tabs
" g grey the inactive menu items 
" t include tearoff menu items
" a auto yank visuals into regester *
" T toolbar
if g:isw
	set guioptions=egt
elseif g:ism
	set guioptions=egtm
endif
"}}}

" Screen size settings {{{1
" Initial sizes {{{2
" those size responding to font h:9
if g:ism
	set lines=40
	set columns=101
else
	set lines=45
	set columns=100
endif

" those size responding to font h:12 (win)
"set lines=25
"set columns=80
" }}}

" Move the windows {{{2
if g:isw
	function! MoveWindows(incre, direction)
		let x = getwinposx()
		let y = getwinposy()
		if a:direction =~ "up"
			let y = y - a:incre
		endif
		if a:direction =~ "down"
			let y = y + a:incre
		endif
		if a:direction =~ "left"
			let x = x - a:incre
		endif
		if a:direction =~ "right"
			let x = x + a:incre
		endif
		execute "winpos" . x . " " . y
	endfunction
	let g:incrementw = 15
	nmap <silent> <M-Left> :call MoveWindows(g:incrementw,"left")<CR>
	nmap <silent> <M-Right> :call MoveWindows(g:incrementw,"right")<CR>
	nmap <silent> <M-Up> :call MoveWindows(g:incrementw,"up")<CR>
	nmap <silent> <M-Down> :call MoveWindows(g:incrementw,"down")<CR>
	imap <silent> <M-Left> <Esc>:call MoveWindows(g:incrementw,"left")<CR>
	imap <silent> <M-Right> <Esc>:call MoveWindows(g:incrementw,"right")<CR>
	imap <silent> <M-Up> <Esc>:call MoveWindows(g:incrementw,"up")<CR>
	imap <silent> <M-Down> <Esc>:call MoveWindows(g:incrementw,"down")<CR>
endif
" }}}

" Change the window size incrementally {{{2
let g:increments = 3
function! ChangeWindowSizeV(incre, direction)
	let y = &lines
	let x = &columns
	if a:direction =~ "down"
		let y += a:incre
		execute 'set lines=' . y
	elseif a:direction =~ "up"
		let y -= a:incre
		execute 'set lines=' . y
	elseif a:direction =~ "left"
		let x -= a:incre
		execute 'set columns=' . x
	elseif a:direction =~ "right"
		let x += a:incre
		execute 'set columns=' . x
	endif
	"execute 'set lines=' . x
endfunction
nmap <C-A-Down> :call ChangeWindowSizeV(g:increments, "down")<CR>
nmap <C-A-Up> :call ChangeWindowSizeV(g:increments, "up")<CR>
nmap <C-A-Left> :call ChangeWindowSizeV(g:increments, "left")<CR>
nmap <C-A-Right> :call ChangeWindowSizeV(g:increments, "right")<CR>
" }}}

" Toggle between two sets of window sizes F1 F2 {{{2
" toggle between two window size, see F1
nmap <silent> <F1> :call <SID>sizeAndPositionOfWindowSmall()<CR>
nmap <silent> <F2> :call <SID>sizeAndPositionOfWindow()<CR>
if !exists("s:sizeandpositionofwindow")
	let s:sizeandpositionofwindowsmall = 0
endif
function! s:sizeAndPositionOfWindowSmall()
	if !s:sizeandpositionofwindowsmall
		set lines=9
		set columns=101
		"winpos 50 60
		let s:sizeandpositionofwindowsmall = !s:sizeandpositionofwindowsmall
	else
		if g:ism
			set lines=40
		else
			set lines=45
		endif
		set columns=101
		"winpos 66 103
		let s:sizeandpositionofwindowsmall = !s:sizeandpositionofwindowsmall
	endif
endfunction

" toggle between two window size, see F2
if !exists("s:sizeandpositionofwindow")
	let s:sizeandpositionofwindow = 0
endif
function! s:sizeAndPositionOfWindow()
	if s:sizeandpositionofwindow
		if g:ism
			set lines=40
		else
			set lines=45
		endif
		set columns=101
		"winpos 50 60
		let s:sizeandpositionofwindow = !s:sizeandpositionofwindow
	else
		if g:ism
			set lines=40
			set columns=169
		else
			set lines=45
			set columns=220
		endif 
		"winpos 66 103
		let s:sizeandpositionofwindow = !s:sizeandpositionofwindow
	endif
endfunction
" }}}
" }}}

" Set the guitablabel {{{1
set guitablabel=%{GuiTabLabel()}
" see :h tabpage
function! GuiTabLabel()
  let label = ''
  let bufnrlist = tabpagebuflist(v:lnum)

  let label .= tabpagenr().'_'

  " Add '+' if one of the buffers in the tab page is modified
  for bufnr in bufnrlist
	if getbufvar(bufnr, "&modified")
	  let label .= '+'
	  break
	endif
  endfor

  " Append the number of windows in the tab page if more than one
  "" let wincount = tabpagewinnr(v:lnum, '$')
  "" if wincount > 1
  ""   let label .= wincount
  "" endif
  "" if label != ''
  ""   let label .= ' '
  "" endif

  " Append the buffer name
  return label . bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
endfunction
" }}}

" Font setup {{{1
"---------------------------------------
if g:isw
" set the space between lines
	set linespace=4
	set guifont=Megatops_ProCoder_1.0:h9
	" useless {{{2
	"---------------------------------------
	"set guifont=Courier_new:h12:w6

	"---------------------------------------
	"set guifont=Yahei_Mono:h10


	"---------------------------------------
	"set guifont=Megatops_Procoder_1.0:h12
	"set guifontwide=新宋体:h12:cGB2312

	"---------------------------------------
	"set guifont=Megatops_Procoder_1.0:h12
	"set guifontwide=新宋体:h12:cGB2312

	"---------------------------------------
	"set guifont=Yahei_Mono:h10

	"---------------------------------------
	"set guifont=MS_Gothic:h11
	"set guifontwide=Megatops_ProCoder_1.0:h9
	"}}}
elseif g:ism
	" TODO
	set linespace=4
	set guifont=Consolas:h14
	set guifontwide=Microsoft\ YaHei:h14
	" useless {{{2
	"set guifont=Megatops_ProCoder_1.0:h12
	"set guifontwide=Megatops_ProCoder_1.0:h12 
	"set guifont=Andale_Mono:h12
	"set guifont=Courier\ New:h14
	"set guifont=DejaVu_LGC_Sans_Mono:h13
	"set guifont=Monaco:h13
	"}}}
endif

" for encoding see http://www.gracecode.com/archives/2989/
" if has("gui_win32")
"     exec 'set guifont='.iconv('Courier_New', &enc, 'gbk').':h11:cANSI'
"     exec 'set guifontwide='.iconv('微软雅黑', &enc, 'gbk').':h11'
" endif

" }}}

" Xell Fullscreen and Writeroom {{{1
" TODO refine the code
let g:Fullscreen_Enabled = 0
let g:writeroomstarted = 0

if g:isw
	let g:shell_fullscreen_items = 'mTe'
endif
nmap <silent> <F11> <Esc>:if !g:writeroomstarted \| call FullScreenToggle() \| else \| echo "WriteRoom mode. Please end it." \| endif<CR>
command! -nargs=0 WRS call WriteRoomStart()
command! -nargs=0 WRSNew call WriteRoomStart('new')
command! -nargs=0 WRE call WriteRoomEnd()
" }}}

" Modelines {{{1
" vim:fmr={{{,}}}:fdm=marker:foldcolumn=3:lbr:fileencoding=utf-8:ff=unix
