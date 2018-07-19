" Vim syntax file
" Language:    FileList
" Maintainer:  Xell Liu

" Use :syn w/in a buffer to see language element breakdown

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

syn match filelistPath '^:.*$'
syn match filelistFile '^[^:#"].*$'
syn match filelistComment '^[#"].*$'

hi default link filelistPath String
hi default link filelistFile Normal
hi default link filelistComment Comment

let b:current_syntax = "filelist"
