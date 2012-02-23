" local syntax file - set colors on a per-machine basis:
" Vim color file
" Maintainer: Xell Liu
" Last Change: 2011.2

highlight clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "xell"

"highlight Normal        guifg=#ffffff     guibg=#000000
"highlight Normal        guifg=White       guibg=grey10
 highlight Normal        guifg=White       guibg=#262626     ctermfg=White ctermbg=Black
"highlight clear Normal
 highlight Comment       guifg=#808080     guibg=bg          ctermfg=Darkgray ctermbg=bg



 highlight Title         guifg=#9acd32
 highlight Constant      guifg=#5f85aa                       gui=none
 highlight Identifier    guifg=#00c0c0               
"highlight Statement     guifg=#c0c000                       gui=bold
 highlight Statement     guifg=#f0e68c
 highlight PreProc       guifg=#00ff00
 highlight Type          guifg=#60ff60
 highlight Special       guifg=#ffa0a0
 highlight Error         guibg=#ff0000
 highlight Todo          guifg=#000000     guibg=#ff9b37
 highlight Ignore        guifg=#494949
"#D03800 #73CA00
 highlight Temp          guifg=#ff9b37     guibg=bg
 highlight Directory     guifg=#60ff60
"highlight StatusLine    guifg=#ffff00     guibg=#5f85aa     gui=none
 highlight StatusLine    guifg=#E8E7E6     guibg=#777777     gui=none ctermfg=11 ctermbg=12 cterm=none 
 highlight StatusLineNC  guifg=#D3CFCD     guibg=#444444     gui=none ctermfg=12 ctermbg=11 cterm=none 
"highlight Search        guibg=#c0c000
 highlight Visual        guifg=Black       guibg=LightGray
"highlight Search        guifg=Black       guibg=LightBlue
"highlight Search        guifg=#000000     guibg=#e17c00
 highlight Search        guifg=#fa8072     guibg=bg          gui=bold,underline
"highlight IncSearch     guifg=grey10      guibg=red
 highlight IncSearch     guifg=red         guibg=Black   
 highlight link Folded   Statement
 highlight Folded        guifg=#5FA6C8     guibg=bg          gui=NONE
 highlight FoldColumn    guifg=white       guibg=bg          gui=bold
"highlight FoldColumn    guifg=tan         guibg=grey30 
 highlight Pmenu                           guibg=grey30
 highlight PmenuSel      guifg=White       guibg=#5f85aa
 highlight PmenuSbar                       guibg=DarkGray 
 highlight PmenuThumb                      guibg=Black
 highlight VertSplit     guifg=#444444     guibg=#E8E7E6
 highlight Cursor        guifg=bg          guibg=fg
 highlight NonText       guifg=Blue        guibg=bg          gui=bold ctermfg=9 term=bold
 highlight LineNr        guifg=Yellow      guibg=bg          ctermfg=14 term=underline
 highlight NonText       guifg=#888888     guibg=bg          gui=none

" For showmarks plugin
"highlight ShowMarksHLl  guifg=Black       guibg=#FFDB72 
"highlight ShowMarksHLu  guifg=Black       guibg=#FFB3FF 

" vim:cc=26,44,62 tw=0 ts=4 sw=4
