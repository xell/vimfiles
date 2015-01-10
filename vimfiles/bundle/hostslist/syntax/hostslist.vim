" Vim syntax file
" Language:    HostsList
" Maintainer:  Xell Liu

" Use :syn w/in a buffer to see language element breakdown

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

syn match hostslistComment '^\s*#.*$'
syn match hostslistIgnore  '\s\zs#\ze$'
syn match hostslistName    '^!.*$'
syn match hostslistStop    '^\*$'

hi default link hostslistComment Comment
hi default link hostslistIgnore Special
hi default link hostslistName String
hi default link hostslistStop ErrorMsg

let b:current_syntax = "hostslist"
