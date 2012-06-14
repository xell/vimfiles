
" if exists("b:did_ftplugin")
"   finish
" endif

iab <buffer> xpa (A)
iab <buffer> xpb (B)
iab <buffer> xtd <C-r>=strftime("%Y-%m-%d")<CR>
iab <buffer> xtm <C-r>=strftime("%Y-%m-%d", localtime() + 60*60*24)<CR>

" let b:did_ftplugin = 1
