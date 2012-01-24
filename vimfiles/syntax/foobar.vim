" Vim syntax file
" Language:	Foobar2000 Script
" Maintainer:	Xell Liu
" Version:	1.1
" Last Change: 12-01-23 14:44:33 
"

if exists("b:current_syntax")
  finish
endif

syntax case ignore

syn match foobarFunction   "\$[^(]\+"
syn match foobarVariable   "%[^%]\+%"
syn match foobarNumber     "\d"
syn match foobarComma      ","
syn match foobarString     "'[^']\+'"
syn match foobarComment    "//.*$"

hi def link foobarFunction Statement
hi def link foobarVariable Identifier
hi def link foobarNumber   Number
hi def link foobarComma    Special
hi def link foobarString   PreProc
hi def link foobarComment  Comment

let b:current_syntax = "foobar"
