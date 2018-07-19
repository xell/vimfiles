
" Search next help tag
" Pattern |word| and |another word| or 'some word'
let b:search_pattern = g:urlpattern . '\|' . '|[^|[:tab:]]\{-}|\|' . "'[^'[:tab:]]\\{-}'"
nmap <buffer> <Tab> :call xelltoolkit#goto_next_word(b:search_pattern)<CR>
nmap <buffer> <S-Tab> :call xelltoolkit#goto_pre_word(b:search_pattern)<CR>
