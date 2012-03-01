" Vim syntax file
" Filename: noteindex.vim
" Language: noteindex
" Maintainer: Xell Liu
" Last change: 2012-02-01
"
" Use for highlight xell note index file


syn case ignore
syn spell toplevel
syn sync fromstart

syn match noteindexHead '^[^%].*[^)]$'
syn match noteindexFile '([^ )]\+)$'
syn match noteindexOther '^%.*$'

hi link noteindexHead Title
hi link noteindexFile Ignore
hi link noteindexOther Comment

