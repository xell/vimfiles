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
syn match xprojectSoon /^.*\s@soon\(\(\s\|([^)]*)\).*\)\?$/ contains=xprojectSoonHead
syn match xprojectSoonHead /^\s/ contained
syn match xprojectOverdue /^.*\s@overdue\(\(\s\|([^)]*)\).*\)\?$/
syn match xprojectDone /^.*\s@done\(\(\s\|([^)]*)\).*\)\?$/
syn match xprojectCancelled /^.*\s@cancelled\(\(\s\|([^)]*)\).*\)\?$/
" syn match xprojectUrgent /\s\zs@\(urgent\|important\)\(([^)]*)\)\?/ containedin=ALL

hi def link xprojectProject Keyword
hi def link xprojectListSymbol Keyword
" hi def link xprojectContext Identifier
hi xprojectContext gui=bold
" hi def link xprojectTime Constant
hi xprojectTime gui=NONE
hi def link xprojectDone Ignore
" hi def link xprojectUrgent Temp
hi def link xprojectCancelled Ignore
hi def link xprojectOverdue Error
" hi def link xprojectSoon Temp
hi def link xprojectSoon Question
hi xprojectSoonHead guibg=green


let b:current_syntax = "pandoc"
