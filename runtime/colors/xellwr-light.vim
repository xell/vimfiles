" local syntax file - set colors on a per-machine basis:
" Vim color file
" Inspired by http://www.codinghorror.com/blog/2006/09/is-your-ide-hot-or-not.html
" Maintainer: Xell Liu
" Last Change: 2011.2

highlight clear
set background=light
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "xellwr-light"

 highlight Normal        guifg=#000000     guibg=#EBE9E8
 highlight Comment       guifg=#7c7c7c
 highlight Constant      guifg=#5f85aa                       gui=none
 highlight Identifier    guifg=#8a4e31
 highlight Statement     guifg=#241965
 highlight PreProc       guifg=#008000                       gui=none
"highlight PreProc       guifg=#139b13
 highlight Type          guifg=#cf870e
"highlight Type          guifg=#dd8e00
 highlight Special       guifg=#ff8080
 highlight Error         guifg=#000000     guibg=#ff0000
 highlight Todo          guifg=#000000     guibg=#ff9b37
 highlight Ignore        guifg=#555555
"#D03800 #73CA00
 highlight Temp          guifg=#ff9b37     guibg=bg
 highlight Visual        guifg=#000000     guibg=#ceff84
 highlight VertSplit     guifg=#E8E7E6     guibg=#777777


"au! vimSB
 highlight StatusLine    guifg=#888888     guibg=#FFFFFF     gui=none
 highlight StatusLineNC  guifg=#FFFFFF     guibg=#888888
 highlight NonText       guifg=#888888     guibg=bg          gui=none
"highlight VertSplit     guifg=bg          guibg=bg
"highlight Cursor        guifg=#222222     guibg=#888888
"highlight NonText       guifg=bg          guibg=bg
"highlight LineNr        guifg=#dddddd     guibg=bg

" vim:cc=26,44,62 tw=0 ts=4 sw=4
