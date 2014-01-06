" Vim syntax file
" Language:    FastFileSearch
" Maintainer:  Xell Liu

" Use :syn w/in a buffer to see language element breakdown

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

syn match firstSpaces '^[ ]\+'
hi default link firstSpaces Visual

let b:current_syntax = "ffs"
