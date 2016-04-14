" Vim syntax file
" Filename: xproject.vim
" Language: XProject
" Maintainer: Xell Liu

if version < 600
 syntax clear
elseif exists("b:current_syntax")
 finish
endif

syn case ignore
syn sync fromstart
syn spell toplevel

" syn match xprojectComment /^.*$/ contains=xprojectContext
" hi def link xprojectComment Constant

syn match xprojectProject /^.\+:\(\s\+@[^ \t(]\+\(([^)]*)\)\?\)*$/ contains=xprojectContext
syn match xprojectListSymbol /^\s*-\s/
syn match xprojectContext /\s\zs@[^ \t(]\+\(([^)]*)\)\?/ contains=xprojectTime
syn match xprojectTime /(\zs[-0123456789]\{2,}/ contained
syn match xprojectDone /^.*\s@done\(\(\s\|([^)]*)\).*\)\?$/
syn match xprojectUrgent /\s\zs@\(urgent\|important\)\(([^)]*)\)\?/
syn match xprojectCancelled /^.*\s@cancelled\(\(\s\|([^)]*)\).*\)\?$/
syn match xprojectOverdue /^.*\s@overdue\(\(\s\|([^)]*)\).*\)\?$/
syn match xprojectSoon /^.*\s@soon\(\(\s\|([^)]*)\).*\)\?$/

hi def link xprojectProject Keyword
hi def link xprojectListSymbol Keyword
hi def link xprojectContext Identifier
hi def link xprojectTime Underlined
hi def link xprojectDone Comment
hi def link xprojectUrgent Error
hi def link xprojectCancelled NonText
hi def link xprojectOverdue Error
hi def link xprojectSoon Temp


let b:current_syntax = "pandoc"
