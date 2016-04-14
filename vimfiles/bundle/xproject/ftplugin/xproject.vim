" XProject filetype plugin
" Language:	XProject
" Maintainer:	Xell Liu

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

setlocal wrapscan

setlocal expandtab
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2

setlocal formatoptions+=ro
setlocal comments=:-

setlocal foldmethod=expr
setlocal foldexpr=XProjectFold()
setlocal foldlevel=99

function! XProjectFold()
    if getline(v:lnum) =~ '^\s\+[^ ]'
        return '>2'
    endif
endfunction

" highlight xprojectFilter guibg=#3D0E14
highlight xprojectFilter guibg=#7F0F23
command! -buffer -nargs=+ Filter call <SID>filter_highlight(<f-args>)
function! s:filter_highlight(term, ...) "{{{
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
function! OverdueAndSoon() "{{{
    let lnum = 1
    let lend = line('$')
    let today_date = str2nr(strftime('%Y%m%d'))
    while lnum <= lend
        let lcontent = getline(lnum)
        if lcontent =~? '@\(done\|cancelled\|soon\|overdue\)'
            let lnum += 1
            continue
        endif
        let [start_date, due_date] = s:extract_xproject_dates(getline(lnum))
        if due_date != 0 && due_date < today_date
            call setline(lnum, lcontent . ' @overdue')
        endif
        " due 415 today 414
        if due_date != 0 && due_date >= today_date && due_date <= today_date + 1
            call setline(lnum, lcontent . ' @soon')
        endif
        let lnum += 1
    endwhile
endfunction "}}}
call OverdueAndSoon()
nmap <buffer> ,po :call OverdueAndSoon()<CR>

" Scan the content, highlight/mark today tasks
" highlight xprojectFilterToday guibg=#006602
highlight xprojectFilterToday gui=underline
function! FilterToday() "{{{
    let highlight_lnum = []

    let lnum = 1
    let lend = line('$')
    let today_date = str2nr(strftime('%Y%m%d'))
    sign unplace *
	sign define piet text=>> texthl=Search
    while lnum <= lend
        let lcontent = getline(lnum)
        if lcontent =~? '@\(done\|cancelled\|overdue\)'
            let lnum += 1
            continue
        endif
        let [start_date, due_date] = s:extract_xproject_dates(getline(lnum))
        if start_date != 0 && start_date <= today_date
                    \ && due_date != 0 && due_date >= today_date
            call add(highlight_lnum, lnum)
            exe ":sign place 2 line=" . lnum . " name=piet file=" . expand("%:p")
        endif
        let lnum += 1
    endwhile

    let highlight_pattern = '\%'
    let highlight_pattern .= join(highlight_lnum, 'l.*\|\%')
    let highlight_pattern .= 'l.*'
    let @/ = highlight_pattern
    exec '2match xprojectFilterToday /' . highlight_pattern . '/'
endfunction "}}}
call FilterToday()
nmap <buffer> ,pt :call FilterToday()<CR>


