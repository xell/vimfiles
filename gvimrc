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
" those size responding to font h:9
" TODO
set lines=40
set columns=101
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

" Modelines {{{1
" vim:fmr={{{,}}}:fdm=marker:foldcolumn=3:lbr:fileencoding=gbk:ff=unix
