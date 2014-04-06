" plugin to handle the TaskPaper to-do list format
" Language:	Taskpaper (http://hogbaysoftware.com/projects/taskpaper)
" Maintainer:	David O'Callaghan <david.ocallaghan@cs.tcd.ie>
" URL:		https://github.com/davidoc/taskpaper.vim
" Last Change:  2012-02-20

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo&vim

" Define a default date format
if !exists('g:task_paper_date_format')
    let g:task_paper_date_format = "%Y-%m-%d"
endif

" Define a default archive project name
if !exists('g:task_paper_archive_project')
    let g:task_paper_archive_project = "Archive"
endif

" Define a default new project name
if !exists('g:task_paper_new_project')
    let g:task_paper_new_project = "New"
endif

" Define a default unfinished project name
if !exists('g:task_paper_unfinished_project')
    let g:task_paper_unfinished_project = "Unfinished"
endif

" When moving a task, should the cursor follow or stay in the same place
" (default: follow)
if !exists('g:task_paper_follow_move')
    let g:task_paper_follow_move = 1 
endif

" Hide @done tasks when searching tags
if !exists('g:task_paper_search_hide_done')
    let g:task_paper_search_hide_done = 0 
endif

" Add '@' to keyword character set so that we can complete contexts as keywords
setlocal iskeyword+=@-@

" Tab character has special meaning on TaskPaper
setlocal noexpandtab

" Change 'comments' and 'formatoptions' to continue to write a task item
setlocal comments=b:-
setlocal fo-=c fo+=rol

" Set 'autoindent' to maintain indent level
setlocal autoindent

setlocal listchars+=tab:\ \ " Show tabs as spaces for cleanliness

" Set up mappings
if !exists("no_plugin_maps") && !exists("no_taskpaper_maps")
    nnoremap <silent> <buffer> <Plug>TaskPaperFoldProjects
    \       :<C-u>call taskpaper#fold_projects()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperFoldNotes
    \       :<C-u>call taskpaper#search('\v^(\s*\|\t+-\s+.*\|.+:)$')<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperFocusProject
    \       :<C-u>call taskpaper#focus_project()<CR>

    nnoremap <silent> <buffer> <Plug>TaskPaperSearchKeyword
    \       :<C-u>call taskpaper#search()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperSearchTag
    \       :<C-u>call taskpaper#search_tag()<CR>

    nnoremap <silent> <buffer> <Plug>TaskPaperGoToProject
    \       :<C-u>call taskpaper#go_to_project()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperNextProject
    \       :<C-u>call taskpaper#next_project()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperPreviousProject
    \       :<C-u>call taskpaper#previous_project()<CR>

    nnoremap <silent> <buffer> <Plug>TaskPaperArchiveDone
    \       :<C-u>call taskpaper#archive_done()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperShowToday
    \       :<C-u>call taskpaper#search_tag('today')<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperShowCancelled
    \       :<C-u>call taskpaper#search_tag('cancelled')<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperToggleCancelled
    \       :call taskpaper#toggle_tag('cancelled', taskpaper#date())<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperMarkDone
    \       :call taskpaper#delete_tag('today')<CR>
    \       :call taskpaper#add_tag('done', taskpaper#date())<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperToggleDone
    \       :call taskpaper#toggle_tag('done', taskpaper#date())<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperToggleToday
    \       :call taskpaper#toggle_tag('today', '')<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperInsertUnderProject
    \       :call taskpaper#insert_under_project()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperAppendToProject
    \       :call taskpaper#append_to_project()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperReEnterTask
    \       :call taskpaper#delete_tag('today')<CR>
    \       :call taskpaper#re_enter_task()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperReEnterUnfinished
    \       :call taskpaper#delete_tag('today')<CR>
    \       :call taskpaper#re_enter_task_unfinished()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperMoveToEnd
    \       :call taskpaper#move_to_end()<CR>
    nnoremap <silent> <buffer> <Plug>TaskPaperNewTask
    \       :call taskpaper#new_task()<CR>

    nnoremap <silent> <buffer> <Plug>TaskPaperNewline
    \       o<C-r>=taskpaper#newline()<CR>
    inoremap <silent> <buffer> <Plug>TaskPaperNewline
    \       <CR><C-r>=taskpaper#newline()<CR>

    nmap <buffer> <Leader>tp <Plug>TaskPaperFoldProjects
    nmap <buffer> <Leader>t. <Plug>TaskPaperFoldNotes
    nmap <buffer> <Leader>tP <Plug>TaskPaperFocusProject

    nmap <buffer> <Leader>t/ <Plug>TaskPaperSearchKeyword
    nmap <buffer> <Leader>ts <Plug>TaskPaperSearchTag

    nmap <buffer> <Leader>tg <Plug>TaskPaperGoToProject
    nmap <buffer> <Leader>tj <Plug>TaskPaperNextProject
    nmap <buffer> <Leader>tk <Plug>TaskPaperPreviousProject

    nmap <buffer> <Leader>tD <Plug>TaskPaperArchiveDone
    nmap <buffer> <Leader>tT <Plug>TaskPaperShowToday
    nmap <buffer> <Leader>tX <Plug>TaskPaperShowCancelled
    nmap <buffer> <Leader>td <Plug>TaskPaperMarkDone
    nmap <buffer> <Leader>tt <Plug>TaskPaperToggleToday
    nmap <buffer> <Leader>tx <Plug>TaskPaperToggleCancelled
    nmap <buffer> <Leader>ti <Plug>TaskPaperInsertUnderProject
    nmap <buffer> <Leader>ta <Plug>TaskPaperAppendToProject
    nmap <buffer> <Leader>tu <Plug>TaskPaperReEnterUnfinished
    nmap <buffer> <Leader>tr <Plug>TaskPaperReEnterTask
    nmap <buffer> <Leader>tn <Plug>TaskPaperNewTask

    if mapcheck("o", "n") == ''
        nmap <buffer> o <Plug>TaskPaperNewline
    endif
    if mapcheck("\<CR>", "i") == ''
        imap <buffer> <CR> <Plug>TaskPaperNewline
    endif
endif

let &cpo = s:save_cpo
