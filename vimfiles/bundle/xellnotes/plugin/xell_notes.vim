" Author:   Xell Liu <xell DOT liu AT gmail.com>
" License:  Same terms as Vim itself (see :help license).
"

" Pre {{{1
if exists("g:loaded_xell_notes") || v:version < 700
  finish
endif
let g:loaded_xell_notes = 1

let s:savecpo = &cpo
set cpo&vim

" }}}

" Return the corresponding output html of specified note file {{{1
" See g:browser_open_rules
function! GetOutputHTML(file)
	let file = a:file
	let notes_root = xelltoolkit#fname2pattern(g:xell_notes_root)

	if file =~? notes_root
		let file_head_pattern = xelltoolkit#fname2pattern(xelltoolkit#fname_head(file))
		let html_file = substitute(file, '\c' . file_head_pattern, xelltoolkit#fname2pattern(g:xell_notes_ex_root), '')
		let html_file = xelltoolkit#fname_ext_mod(html_file, 'html')
	else
		let html_file = xelltoolkit#fname_ext_mod(file, 'html')
	endif

	if filereadable(html_file)
		return html_file
	else
		return ''
	endif

endfunction
" }}}

" Open note {{{1
nmap <silent> <Leader>. :call <SID>note_taking()<CR>
function! s:note_taking()
    if &modified
        tabnew
    else
        enew
    endif
    set ft=filelist
    setlocal hidden
    setlocal bufhidden=delete
    setlocal buftype=nofile
    exec 'lcd ' . g:xell_notes_root

    " use t:sort_by_name to toggle sorting by name or by modification tiem
    " instead of 'ls', split(glob(g:xell_notes_root . '/*.*'), '\n')
    if &ft == 'filelist' && exists('t:sort_by_name')
        if t:sort_by_name
            let notes = split(system('ls -t ' . g:xell_notes_root), '\n')
            let t:sort_by_name = 0
        else
            let notes = split(system('ls ' . g:xell_notes_root), '\n')
            let t:sort_by_name = 1
        endif
    else
        let notes = split(system('ls -t ' . g:xell_notes_root), '\n')
        let t:sort_by_name = 0
    endif
    let i = 0
    let j = len(notes)
    while (i < j)
        if notes[i] =~# 'Notes & Settings'
            call remove(notes, i)
            break
        else
            let i += 1
        endif
    endwhile

    call setline(1, ':' . g:xell_notes_root)
    call append(1, '')
    call append(2, notes)

    return
endfunction
"}}}

" nmap <silent> <Leader>p :execute 'e ' . g:xell_notes_root . '/' . 'plan.t2t'<CR>
" }}}

" Delete note {{{1
command! -nargs=0 DeleteNote call DeleteNote()
function! DeleteNote()
    let noteroot = expand("%:p:h")
    let notename = expand("%:t")
    let notefullname = xelltoolkit#fname_escape(expand("%:p"))
    if glob(g:xell_notes_root) =~ xelltoolkit#fname2pattern(noteroot)
        if !system('mv ' . notefullname . ' ~/.Trash/')
            call xelltoolkit#echo_msg(notename . ' was deleted.')
        else
            call xelltoolkit#echo_msg("Something wrong. The note cannot be deleted.")
        endif
    else
        call xelltoolkit#echo_msg("It's not a note.")
    endif
endfunction

" }}}

" Temp Note {{{1

function! TempNote()
	try
		write
	catch /^Vim\%((\a\+)\)\=:E32/	" catch error E32 No file name
		let tempfilename = s:temp_note_filename()
		execute 'write ' . tempfilename
        exec 'autocmd BufDelete <buffer> call DeleteTempNote()'
        exec 'set fenc=utf8'
		call xelltoolkit#echo_msg("Write to a temporary note.")
	endtry
endfunction

function! DeleteTempNote()
    let tempfile = expand("<afile>:p")
    let tempfilename = expand("<afile>:t")
    let res = input("Permanently delete " . tempfilename . " ? (y/n)\n")
    if res =~? '^y' && !system('mv ' . tempfile . ' ~/.Trash/')
        exec 'bwipeout! ' . tempfile
        call xelltoolkit#echo_msg('Permanently delete ' . tempfilename)
    else
        call xelltoolkit#echo_msg('The temp note is still in the notes folder!')
    endif
endfunction

" Generate temp note file name
function s:temp_note_filename()
    return g:xell_notes_root . '/temp_' . strftime("%Y%m%d-%H%M%S") . '.tempnote'
endfunction

" }}}

" Add new note {{{1
command! -nargs=0 AddNote call AddNote()
function! AddNote()
    let filefullname = expand('%:p')
    let fileext = expand('%:e')

    " untitled doc
    if filefullname == ''
        let newfilename = input("Note name:\n")
        while newfilename == ''
            let newfilename = input("Note name:\n")
        endwhile
        let newfileext = input("Note extension: (md)\n")
        if newfileext == ''
            let newfileext = 'md'
        endif
        call writefile(getline(1, '$'), g:xell_notes_root . '/' . newfilename . '.' . newfileext)

        bwipeout!
        exec 'edit ' . xelltoolkit#fname_escape(g:xell_notes_root . '/' . newfilename . '.' . newfileext)
        call xelltoolkit#echo_msg('New note "' . newfilename . '.' . newfileext . '" was created!')

        return
    endif

    " tempnote doc
    if fileext == 'tempnote'
        " disable BufDelete autocmd trigger
        exec 'autocmd! BufDelete <buffer>'
        let newfilename = input("Note name:\n")
        while newfilename == ''
            let newfilename = input("Note name:\n")
        endwhile
        let newfileext = input("Note extension: (md)\n")
        if newfileext == ''
            let newfileext = 'md'
        endif
        call rename(filefullname, g:xell_notes_root . '/' . newfilename . '.' . newfileext)

        bwipeout!
        exec 'edit ' . xelltoolkit#fname_escape(g:xell_notes_root . '/' . newfilename . '.' . newfileext)
        call xelltoolkit#echo_msg('New note "' . newfilename . '.' . newfileext . '" was created!')

        return
    endif

    " existed doc
    if filefullname != '' && fileext != 'tempnote'
        let ischangefilename = input("Change file name? (y/N)")
        if ischangefilename =~ '^y'
            let newfilename = input("Note name:\n")
            while newfilename == ''
                let newfilename = input("Note name:\n")
            endwhile
        else
            let newfilename = expand("%:t:r")
        endif
        let ischangefileext = input("Change ext name? (y/N)")
        if ischangefileext =~ '^y'
            let newfileext = input("Note extension: (md)\n")
            if newfileext == ''
                let newfileext = 'md'
            endif
        else
            let newfileext = fileext
        endif

        let newfile = g:xell_notes_root . '/' . newfilename . '.' . newfileext
        let is_keep_ori = input("Keep original file? (y/N)")
        if is_keep_ori =~ '^y'
            call system('cp ' . xelltoolkit#fname_escape(filefullname) . ' ' . xelltoolkit#fname_escape(newfile))
            bwipeout!
            exec 'edit ' . xelltoolkit#fname_escape(newfile)
            call xelltoolkit#echo_msg('New note "' . newfilename . '.' . newfileext . '" was created!')
            call xelltoolkit#echo_msg('The original file is untouched.')
        else
            call rename(filefullname, newfile)
            bwipeout!
            exec 'edit ' . xelltoolkit#fname_escape(newfile)
            call xelltoolkit#echo_msg('New note "' . newfilename . '.' . newfileext . '" was created!')
            call xelltoolkit#echo_msg('The original file is renamed.')
        endif

        return
    endif

endfunction

" }}}

" Rename note {{{1
command! -nargs=0 RenameNote call RenameNote()
function! RenameNote()
    let filefullname = expand('%:p')
    let fileext = expand('%:e')
    let newfilename = input("Note name:\n")
    while newfilename == ''
        let newfilename = input("Note name:\n")
    endwhile
    let ischangefileext = input("Change ext name? (y/N)")
    if ischangefileext =~ '^y'
        let newfileext = input("Note extension: (md)\n")
        if newfileext == ''
            let newfileext = 'md'
        endif
    else
        let newfileext = fileext
    endif

    let newfile = g:xell_notes_root . '/' . newfilename . '.' . newfileext
    call rename(filefullname, newfile)
    bwipeout!
    exec 'edit ' . xelltoolkit#fname_escape(newfile)
    call xelltoolkit#echo_msg('Note was renamed to "' . newfilename . '.' . newfileext . '" !')
endfunction
" }}}

" Open note in nv {{{1
command! -nargs=0 OpenInNV call OpenInNV()
function! OpenInNV()
    let noteroot = expand("%:p:h")
    let notename = expand("%:t:r")
    let notefullname = xelltoolkit#fname_escape(expand("%:p"))
    if glob(g:xell_notes_root) =~ xelltoolkit#fname2pattern(noteroot)
        " let teststr = "a b c 我们"
        " python -c "import urllib; print urllib.quote('''$value''')"
        " http://stackoverflow.com/questions/296536/urlencode-from-a-bash-script
        " http://www.koch.ro/blog/index.php?/archives/48-URL-encodingdecoding-with-VIM.html
        let uri_escape_title = system('python -c "import urllib; print urllib.quote(' . "'''" . notename . "'''" . ')"')
        let uri_escape_title = substitute(uri_escape_title, '\n', '', 'g')
        call system('open "nv://find/' . uri_escape_title . '"')
    else
        call xelltoolkit#echo_msg("It's not a note.")
    endif
endfunction
" }}}

" notes XXX

" 已完成：
" 
"  * ,/ 展示笔记列表
"  * 新建笔记
"   1. 对于无名文档
"      复制当前内容到 notes 目录中
"      提示输入文件名/后缀名
"   2. 对于 tempnote 文档
"      复制当前内容到 notes 目录中
"      提示输入文件名/后缀名
"      删除 tempnote
"   3. 对于已保存的、不在笔记目录中的文档
"      复制文件到 notes 目录中
"      提示更改文件名
"      询问是否删除原有文件
"  * 搜索笔记全文和/或 tag
"  * 删除笔记（Rm 或 RM），包括临时笔记（bd）
"  * 在 nv 中打开当前笔记
" 
" 删除 xell_tempfile
" 
" 未完成：
" 
" 删除 noteindex 设置，整理对应的 notes converting

" End {{{1
let &cpo = s:savecpo
unlet s:savecpo

" vim:fdm=marker
" }}}
