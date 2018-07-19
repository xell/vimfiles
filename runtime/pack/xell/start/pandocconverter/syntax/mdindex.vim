" Mdindex syntax file
" Filename: mdindex.vim
" Language: Mdindex
" Maintainer: Xell Liu

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syntax case ignore

syn match comment '^#.*$'
syn match titleBlock '^%.*$'
syn match includes '^<<\[[^]]\+\]$' contains=includesLeft,includesRight
syn match includesLeft '<<\['
syn match includesRight '\]$'
syn match profile '^@[^@]\+'

hi default link comment Comment
hi default link titleBlock Constant
hi default link includes Type
hi default link includesLeft Comment
hi default link includesRight Comment
hi default link profile Type

let b:current_syntax = "mdindex"
