" XProject filetype plugin
" Language:	XProject
" Maintainer:	Xell Liu

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

setlocal wrapscan

setlocal expandtab
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2

setlocal formatoptions+=ro
setlocal comments=:-

nmap <buffer> <Leader>pp :let @/="" <bar> match<CR>

" folder {{{
setlocal foldmethod=expr
setlocal foldexpr=XProjectFold()
setlocal foldlevel=99

function! XProjectFold()
    if getline(v:lnum) =~ '^\s\+[^ ]'
        return '>2'
    endif
endfunction
" }}}

let g:xproject_soon = 1
let g:xproject_hint = 5

" highlight xprojectFilter guibg=#3D0E14
highlight xprojectFilter guibg=#7F0F23
command! -buffer -nargs=? Filter call <SID>filter_highlight(<f-args>)
function! s:filter_highlight(...) "{{{
    if a:0 == 1
        call s:filter_highlight_old(a:1)
        return
    endif

    let content = readfile(expand('%'))

    " collect all @contexts
    " contexts_dict = {'@a': [1, 2, 3], '@b': [3, 5]}
    let contexts_dict = {}
    for lnum in range(len(content))
        let lnum_contexts = []
        call substitute(content[lnum], '@[^( ]\+',
                    \ '\=add(lnum_contexts, submatch(0))', 'g')
        if lnum_contexts != []
            for con in lnum_contexts
                if con !~? '@\(start\|due\)'
                    let contexts_dict[con] = add(get(contexts_dict, con, []), lnum)
                endif
            endfor
        endif
    endfor

    " sort by the length of contexts_dict[key]
    let contexts_list = []
    let contexts_dict_copy = deepcopy(contexts_dict)
    for i in range(len(keys(contexts_dict_copy)))
        let max = 0
        let max_key = ''
        for [key, value] in items(contexts_dict_copy)
            if len(value) > max
                let max = len(value)
                let max_key = key
            endif
        endfor
        call add(contexts_list, max_key)
        call remove(contexts_dict_copy, max_key)
    endfor
    unlet contexts_dict_copy

    " construct the prompt
    let prompt = "Please select:\n"
    let lnum = 0
    if g:xproject_hint < (len(contexts_list) - 2)
        let hint_num = g:xproject_hint
    else
        let hint_num = len(contexts_list) - 2
    endif

    while lnum < hint_num
        let prompt .= (lnum + 1) . " : " . contexts_list[lnum] . "\n"
        let lnum += 1
    endwhile
    let prompt .= "Others: "
    while lnum < len(contexts_list) - 1
        let prompt .= contexts_list[lnum] . ", "
        let lnum += 1
    endwhile
    let prompt .= contexts_list[lnum] . "\n? "

    " get the final search term
    let answer = input(prompt)
    if answer == ''
        let term = contexts_list[0]
    elseif answer >= 1 && answer <=5
        let term = contexts_list[answer - 1]
    else
        let term = answer
    endif

    call s:filter_highlight_old(term)

endfunction "}}}

" command! -buffer -nargs=+ Filter call <SID>filter_highlight(<f-args>)
function! s:filter_highlight_old(term, ...) "{{{
    let content = readfile(expand('%'))
    let lnum = 0
    let highlight_lnum = []
    while (lnum < len(content))
        if content[lnum] =~? a:term
            call add(highlight_lnum, lnum + 1)
        endif
        let lnum += 1
    endwhile
    let highlight_pattern = '\%'
    let highlight_pattern .= join(highlight_lnum, 'l.*\|\%')
    let highlight_pattern .= 'l.*'
    let @/ = highlight_pattern
    if a:0 == 0
        exec 'match xprojectFilter /' . highlight_pattern . '/'
    elseif a:0 == 1
        exec 'match ' . a:1 . ' /' . highlight_pattern . '/'
    endif
"  * vim 过滤显示可以使用 `:match` 和 `:2match`，过滤整行使用 `\%20l.*\|\%24l.*\|\%72l.*`。
endfunction "}}}

function! s:extract_xproject_dates(item) "{{{
    let start_str = matchlist(a:item, '@start(\([-0123456789]\+\))', 0)
    if start_str != []
        let start_date = substitute(start_str[1], '-', '', 'g')
        if len(start_date) == 4
            let start_date = strftime('%Y') . start_date
        elseif len(start_date) == 6
            let start_date = '20' . start_date
        endif
        let start_date = str2nr(start_date)
    else
        let start_date = 0
    endif
    let due_str = matchlist(a:item, '@due(\([-0123456789]\+\))', 0)
    if due_str != []
        let due_date = substitute(due_str[1], '-', '', 'g')
        if len(due_date) == 4
            let due_date = strftime('%Y') . due_date
        elseif len(due_date) == 6
            let due_date = '20' . due_date
        endif
        let due_date = str2nr(due_date)
    else
        let due_date = 0
    endif
    return [start_date, due_date]
endfunction
" }}}

" Scan the content, add @overdue and @soon
let b:lnum_overdueandsoon = []
sign define overdue text=>> texthl=Error
sign define soon text=>> texthl=Question
function! OverdueAndSoon() "{{{
    let lnum = 1
    let lend = line('$')
    let today_date = str2nr(strftime('%Y%m%d'))
    for lnum_oad in b:lnum_overdueandsoon
        exec ':sign unplace ' . lnum_oad
    endfor
    let b:lnum_overdueandsoon = []
    while lnum <= lend
        " remove all (hand-added) @overdue or @soon
        call setline(lnum,
                    \ substitute(getline(lnum), '\s@\(overdue\|soon\)', '', 'g'))
        let lcontent = getline(lnum)

        " skip all @done and @cancelled
        if lcontent =~? '@\(done\|cancelled\)'
            let lnum += 1
            continue
        endif
        " add @overdue or @soon by computing the due date
        let [start_date, due_date] = s:extract_xproject_dates(getline(lnum))
        if due_date != 0 && due_date < today_date
            call setline(lnum, lcontent . ' @overdue')
            call add(b:lnum_overdueandsoon, lnum)
            exe ":sign place " . lnum . " line=" . lnum . " name=overdue file=" . expand("%:p")
        endif
        if due_date != 0 && due_date >= today_date && due_date <= today_date + g:xproject_soon
            call setline(lnum, lcontent . ' @soon')
            call add(b:lnum_overdueandsoon, lnum)
            exe ":sign place " . lnum . " line=" . lnum . " name=soon file=" . expand("%:p")
        endif
        let lnum += 1
    endwhile
endfunction "}}}
call OverdueAndSoon()

" Scan the content, highlight/mark today tasks
let b:lnum_today = []
sign define today text=>> texthl=Question
function! FilterToday() "{{{

    let lnum = 1
    let lend = line('$')
    let today_date = str2nr(strftime('%Y%m%d'))
    for lnum_t in b:lnum_today
        exec ':sign unplace ' . lnum_t
    endfor
    let b:lnum_today = []
    while lnum <= lend
        let lcontent = getline(lnum)
        if lcontent =~? '@\(done\|cancelled\|overdue\)'
            let lnum += 1
            continue
        endif
        let [start_date, due_date] = s:extract_xproject_dates(getline(lnum))
        if start_date != 0 && start_date <= today_date
                    \ && due_date != 0 && due_date >= today_date
            call add(b:lnum_today, lnum)
            exe ":sign place " . lnum . " line=" . lnum . " name=today file=" . expand("%:p")
        endif
        let lnum += 1
    endwhile

    let highlight_pattern = '\%'
    let highlight_pattern .= join(b:lnum_today, 'l.*\|\%')
    let highlight_pattern .= 'l.*'
    let @/ = highlight_pattern
    exec '2match Question /' . highlight_pattern . '/'
endfunction "}}}
call FilterToday()

function! MarkMainItems()
    call OverdueAndSoon()
    call FilterToday()
endfunction
nmap <buffer> <Leader>pm :call MarkMainItems()<CR>

" matchadd({group}, {pattern}[, {priority}[, {id}[, {dict}]]])
call matchadd("Temp", '\s\zs@\(urgent\|important\)', 999)

" Don't load another plugin for this buffer
let b:did_ftplugin = 1
