" au BufEnter * if &ft ==# 'xml' | commands | endif

call TestSw()

function! TestSw()
    let buflist = []
    for i in range(tabpagenr('$'))
       call extend(buflist, tabpagebuflist(i + 1))
    endfor
    echo buflist
endfunction
