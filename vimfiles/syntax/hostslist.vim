
syn case ignore

syn match hostslistComment '^\s*#.*$'
syn match hostslistIgnore  '\s\zs#\ze$'
syn match hostslistName    '^!.*$'
syn match hostslistStop    '^\*$'

hi default link hostslistComment Comment
hi default link hostslistIgnore Special
hi default link hostslistName String
hi default link hostslistStop ErrorMsg
