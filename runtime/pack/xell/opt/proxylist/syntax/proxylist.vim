" Vim syntax file
" Language:	proxylist
" Maintainer:	Xell Liu
" Last Change:	20120123 

if exists("b:current_syntax")
  finish
endif

syn case ignore
syn match plComment /^#.*$/
syn match plOperation /^@.*$/
syn match plProxyEnd /^\$.*$/
syn match plProxyReturn /^!.*$/
syn match plProxyString />\s*\zs[^ ]\+\ze\s*|/
syn match plProxyName /^<[^>]\+>/
syn match plProxy /\zs|.*\ze$/

hi def link plComment     Comment
hi def link plOperation   Special
hi def link plProxyEnd   Special
hi def link plProxyReturn   Type

hi def link plProxyName  Function
hi def link plProxyString  String
hi def link plProxy  Type

let b:current_syntax = "proxylist"
