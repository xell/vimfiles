" local syntax file - set colors on a per-machine basis:
" Vim color file
" Maintainer: Xell Liu
" Last Change: 2012.3

highlight clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "xell"

 highlight Normal        guifg=#f5f5f5     guibg=#262626     ctermfg=15 ctermbg=8
 highlight Comment       guifg=#808080     guibg=bg          ctermfg=0  ctermbg=8
 highlight Constant      guifg=#5f85aa     guibg=bg          ctermfg=4  ctermbg=8
 highlight Identifier    guifg=#00c0c0     guibg=bg          ctermfg=14 ctermbg=8
 highlight Statement     guifg=#f0e68c     guibg=bg          ctermfg=11 ctermbg=8 gui=NONE
 highlight PreProc       guifg=#00ff00     guibg=bg          ctermfg=10 ctermbg=8
 highlight Type          guifg=#60ff60     guibg=bg          ctermfg=2  ctermbg=8 gui=NONE
 highlight Special       guifg=#ffa0a0     guibg=bg          ctermfg=1  ctermbg=8
 highlight Underlined    guifg=#80a0ff     guibg=bg          ctermfg=12 ctermbg=8 gui=Underline cterm=Underline
 highlight Ignore        guifg=#494949     guibg=bg          ctermfg=0  ctermbg=8
 highlight Error         guifg=#ff0000     guibg=bg          ctermfg=9  ctermbg=8
 highlight Todo          guifg=#000000     guibg=#ff9b37     ctermfg=15 ctermbg=1

 highlight Conceal       guifg=fg          guibg=bg          ctermfg=15 ctermbg=8 gui=Undercurl guisp=fg cterm=Underline
 highlight Cursor        guifg=bg          guibg=LightGray
 highlight CursorLine                      guibg=#333338
 highlight DiffAdd       guifg=#000000     guibg=#7cdede     ctermfg=8  ctermbg=4
 highlight DiffChange    guifg=#000000     guibg=#e493ff     ctermfg=8  ctermbg=5
 highlight DiffDelete    guifg=#000000     guibg=#ff9b9b     ctermfg=8  ctermbg=1
 highlight DiffText      guifg=#ffffff     guibg=#b70000     ctermfg=15 ctermbg=9
 highlight Directory     guifg=#60ff60     guibg=bg          ctermfg=2  ctermbg=8
 highlight IncSearch     guifg=#ff0000     guibg=#000000     ctermfg=9  ctermbg=8
 highlight Folded        guifg=#95cbfe     guibg=bg          ctermfg=4  ctermbg=8
 highlight FoldColumn    guifg=#ffffff     guibg=bg          ctermfg=15 ctermbg=8
 highlight LineNr        guifg=#ffff00     guibg=bg          ctermfg=11 ctermbg=8
 highlight ModeMsg       guifg=#777777     guibg=bg          ctermfg=0  ctermbg=8
 highlight NonText       guifg=#39546f     guibg=bg          ctermfg=0  ctermbg=8
 highlight Pmenu         guifg=fg          guibg=#555555     ctermfg=15 ctermbg=0
 highlight PmenuSel      guifg=#ffffff     guibg=#5f85aa     ctermfg=15 ctermbg=4
 highlight PmenuSbar     guifg=fg          guibg=#888888     ctermfg=15 ctermbg=0
 highlight PmenuThumb    guifg=fg          guibg=#000000     ctermfg=15 ctermbg=8
 highlight Search        guifg=#000000     guibg=#1AA311     ctermfg=1  ctermbg=8 gui=NONE cterm=Bold
 highlight SignColumn                      guibg=bg
 highlight SpecialKey    guifg=#ffa0a0     guibg=bg          ctermfg=1  ctermbg=8
 highlight StatusLine    guifg=#e8e7e6     guibg=#777777     ctermfg=7  ctermbg=0
 highlight StatusLineNC  guifg=#d3cfcd     guibg=#444444     ctermfg=7  ctermbg=8
 highlight Title         guifg=#9acd32     guibg=bg          ctermfg=10 ctermbg=8
 highlight VertSplit     guifg=#d3cfcd     guibg=#444444     ctermfg=7  ctermbg=0
 highlight Visual        guifg=#000000     guibg=#90ee90     ctermfg=8  ctermbg=2

 highlight DiffAdd       guifg=#ff0000     guibg=#fce6e6
 highlight DiffDelete    guifg=#d5ffff     guibg=#d5ffff
 highlight DiffChange    guifg=#ff0000     guibg=#fce6e6

 highlight Temp          guifg=#ff9b37     guibg=bg          ctermfg=1  ctermbg=8

" vim:cc=26,44,62 tw=0 ts=4 sw=4
