" local syntax file - set colors on a per-machine basis:
" Vim color file
" Maintainer: Xell Liu
" Last Change: 2012.3
" thanks to:
" chela_light.vim eclipse.vim guepardo.vim oceanlight.vim vylight.vim

highlight clear
set background=light
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "xell_light"

 highlight Normal        guifg=#030405     guibg=#f6f4f4     ctermfg=15 ctermbg=8
 highlight Comment       guifg=#737e91     guibg=bg          ctermfg=0  ctermbg=8
 highlight Constant      guifg=#6b8d87     guibg=bg          ctermfg=4  ctermbg=8
 highlight Identifier    guifg=#446685     guibg=bg          ctermfg=14 ctermbg=8 gui=Bold
 highlight Statement     guifg=#82333b     guibg=bg          ctermfg=11 ctermbg=8
"highlight Statement     guifg=#0086bf     guibg=bg          ctermfg=11 ctermbg=8
 highlight PreProc       guifg=#007050     guibg=bg          ctermfg=10 ctermbg=8
 highlight Type          guifg=#2f470b     guibg=bg          ctermfg=2  ctermbg=8
 highlight Special       guifg=#6e4f97     guibg=bg          ctermfg=1  ctermbg=8
 highlight Underlined    guifg=#547dca     guibg=bg          ctermfg=12 ctermbg=8 gui=Underline cterm=Underline
 highlight Ignore        guifg=#b1b1b1     guibg=bg          ctermfg=0  ctermbg=8
 highlight Error         guifg=#ff0000     guibg=bg          ctermfg=9  ctermbg=8
 highlight Todo          guifg=#000000     guibg=#ff9b37     ctermfg=15 ctermbg=1

 highlight Conceal       guifg=fg          guibg=bg          ctermfg=15 ctermbg=8 gui=Undercurl guisp=fg cterm=Underline
 highlight Cursor        guifg=bg          guibg=#555555  
 highlight DiffAdd       guifg=#000000     guibg=#b7e8ea     ctermfg=8  ctermbg=4
 highlight DiffChange    guifg=#000000     guibg=#eed9ff     ctermfg=8  ctermbg=5
 highlight DiffDelete    guifg=#000000     guibg=#ffbdbf     ctermfg=8  ctermbg=1
 highlight DiffText      guifg=#ffffff     guibg=#b70000     ctermfg=15 ctermbg=9
 highlight Directory     guifg=#276728     guibg=bg          ctermfg=2  ctermbg=8
 highlight IncSearch     guifg=#ff0000     guibg=#000000     ctermfg=9  ctermbg=8
 highlight Folded        guifg=#4c6984     guibg=bg          ctermfg=4  ctermbg=8
 highlight FoldColumn    guifg=#aaaaaa     guibg=bg          ctermfg=15 ctermbg=8
 highlight LineNr        guifg=#999999     guibg=bg          ctermfg=11 ctermbg=8
 highlight MatchParen    guifg=bg          guibg=#6e4f97
 highlight ModeMsg       guifg=#777777     guibg=bg          ctermfg=0  ctermbg=8
 highlight NonText       guifg=#cccccf     guibg=bg          ctermfg=0  ctermbg=8 gui=NONE
 highlight Pmenu         guifg=fg          guibg=#bbbbbe     ctermfg=15 ctermbg=0
 highlight PmenuSel      guifg=#ffffff     guibg=#5f85aa     ctermfg=15 ctermbg=4
 highlight PmenuSbar     guifg=fg          guibg=#888888     ctermfg=15 ctermbg=0
 highlight PmenuThumb    guifg=fg          guibg=#000000     ctermfg=15 ctermbg=8
 highlight Search        guifg=#fa8072     guibg=bg          ctermfg=1  ctermbg=8 gui=Bold,Underline cterm=Bold,Underline
 highlight SpecialKey    guifg=#ffa0a0     guibg=bg          ctermfg=1  ctermbg=8
 highlight StatusLine    guifg=#888888     guibg=#ffffff          ctermfg=7  ctermbg=0
 highlight StatusLineNC  guifg=#ffffff     guibg=#888888     ctermfg=7  ctermbg=8
 highlight Title         guifg=#b14f32     guibg=bg          ctermfg=10 ctermbg=8
 highlight VertSplit     guifg=#d3cfcd     guibg=#444444     ctermfg=7  ctermbg=0
 highlight Visual        guifg=#000000     guibg=#90ee90     ctermfg=8  ctermbg=2

 highlight Temp          guifg=#222222     guibg=#ff9b37     ctermfg=1  ctermbg=8
 
" vim:cc=26,44,62 tw=0 ts=4 sw=4
