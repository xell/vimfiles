" Vim syntax file
" Filename: noteindex.vim
" Language: noteindex
" Maintainer: Xell Liu
" Last change: 2012-02-01
"
" Use for highlight xell note index file

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn case ignore
syn spell toplevel
syn sync fromstart

syn match noteindexHead '^[^%].*[^)]$'
syn match noteindexFile '([^ )]\+)$'
syn match noteindexOther '^%.*$'
syn match noteindexFav '^\s*\zs\*[^ ][^(]\+\ze\s(' contains=noteindexFavPre
syn match noteindexFavPre '\*' contained conceal

hi link noteindexHead Title
hi link noteindexFile Ignore
hi link noteindexOther Comment
hi link noteindexFav Temp

let b:current_syntax = "noteindex"
