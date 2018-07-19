" Write room
if !has('gui_running')
	finish
endif

if !exists("g:writeroomstarted")
	let g:writeroomstarted = 0
endif

let s:showstatusline = 0

let s:laststatus_ori = &laststatus
let s:ruler_ori = &ruler
let s:guicursor_ori = &guicursor
let s:scrolloff_ori = &scrolloff
let s:statusline_ori = &statusline
let s:winheight_ori = &winheight
let s:winwidth_ori = &winwidth
let s:guioptions_ori = 'egtm'
"egmrLtT

function! WriteRoomStart(...) "{{{1
	"start writeroom.
	if g:writeroomstarted
		echo "Alread in WriteRoom mode!"
		return
	endif
	let g:writeroomstarted = 1
	if a:0 == 1 && a:1 == 'new'
		" start from a new empty file
		call s:startwriteroom(0)
	else
		" start from current buffer
		call s:startwriteroom(1)
	endif
endfunction
" }}}

function! s:startwriteroom(edit_current) "{{{1
	if a:edit_current
		echo "edit current"
		let fileexec = 'silent b ' . bufnr("%")
	else
		echo "edit empty"
		let fileexec = 'silent e wr_emptylines'
	endif

	" new tab
	tabnew
	" full screen
	if !g:Fullscreen_Enabled
		call FullScreenToggle()
	endif
	" create windows
	set nonumber
	vsplit
	vsplit
	wincmd l
	split
	split
	wincmd j
	" edit file
	exec fileexec
	set number
	"set window=46
	set winheight=37
	"set winminheight=45
	set winwidth=80
	"set winminwidth=80
	"set winfixheight winfixwidth

	let g:aug_vimsb_enable = 0

	" setup highlights
	highlight StatusLine    guifg=fg          guibg=bg          gui=none
	highlight StatusLineNC  guifg=bg          guibg=bg
	highlight VertSplit     guifg=bg          guibg=bg
	highlight NonText       guifg=bg          guibg=bg
	highlight Tabline       guifg=bg          guibg=bg
	highlight TabLineFill   guifg=bg          guibg=bg
	highlight TabLineSel    guifg=bg          guibg=bg
	
	if &background == 'dark'
		highlight Cursor        guifg=#222222     guibg=#888888
		highlight LineNr        guifg=#555555     guibg=bg
		highlight FoldColumn    guifg=#555555     guibg=bg
	else
		highlight Cursor        guifg=#888888     guibg=#222222
		highlight LineNr        guifg=#AAAAAA     guibg=bg
		highlight FoldColumn    guifg=#AAAAAA     guibg=bg
	endif

	" setup
	set noruler
	set guicursor=i:hor10,n:hor10-blinkwait0
	set scrolloff=999
	set laststatus=0
	set showtabline=0
	set go-=e
	set mousehide
	" FIXME
	wincmd =
	
	nmap <silent> <S-F6> :call <SID>writeroom_wordcount()<CR>
	let b:Current_Line_Number = line(".")
	let b:Current_Line_Number_zh = line(".")
	let b:Current_Line_Word_Count = 0
	let b:Current_Line_Word_Count_zh = 0
	call <SID>writeroom_wordcount()
	call <SID>writeroom_wordcount()

endfunction
" }}}

function! WriteRoomEnd() "{{{1
	if !g:writeroomstarted
		echo "No WriteRoom."
		return
	endif

	wincmd o
	tabclose
	call FullScreenToggle()
	exec 'set laststatus=' . s:laststatus_ori
	exec 'set guicursor=' . s:guicursor_ori
	exec 'set scrolloff=' . s:scrolloff_ori
	exec 'set winheight=' . s:winheight_ori
	exec 'set winwidth=' . s:winwidth_ori
	exec 'set guioptions=' . s:guioptions_ori
	exec 'set statusline=' . substitute(s:statusline_ori, '\s', '\\ ', 'g')
	exec 'colorscheme ' . g:colors_name
	if s:ruler_ori
		set ruler
	else
		set noruler
	endif
	set showtabline=1
	set nomousehide
	let g:aug_vimsb_enable = 1
	let g:writeroomstarted = 0
	nmap <silent> <S-F6> :call ShowLiveWordCount()<CR>
	normal gT
	echo "End WriteRoom."
endfunction
" }}}

function! s:writeroom_wordcount() "{{{1
	if s:showstatusline % 2 == 1
		set statusline=
		highlight StatusLine guifg=bg guibg=bg gui=none
		let s:showstatusline += 1
	else
		highlight StatusLine guifg=fg guibg=bg gui=none
		"exec 'set statusline=' . g:mystatusline1 . g:mystatusline_fugitive . '\ zh:%{WordCount_zh()}\ wc:%{WordCount()}' . g:mystatusline2
		exec 'set statusline=%<\ %m\ zh:%{WordCount_zh()}\ wc:%{WordCount()}%=%-14.(%c%V%)\ %P\ '
		if s:showstatusline != 0
			call UpdateWordCount()
		endif
		let s:showstatusline += 1
	endif
endfunction
" }}}
