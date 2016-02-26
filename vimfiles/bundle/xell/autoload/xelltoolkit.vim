
" TODO relocate the cursor
function! xelltoolkit#get_word_at_cursor(pattern) "{{{1
	let col = col('.') - 1
	let ori_line = line('.')
	let line = getline('.')
	let ebeg = -1
	let cont = match(line, a:pattern, 0)
	while (ebeg >= 0 || (0 <= cont) && (cont <= col))
		let contn = matchend(line, a:pattern, cont)
		if (cont <= col) && (col < contn)
			let ebeg = match(line, a:pattern, cont)
			let elen = contn - ebeg
			break
		else
			let cont = match(line, a:pattern, contn)
		endif
	endwh
	" let test = input(ori_line . ' ' . col)
	if ebeg >= 0
		return strpart(line, ebeg, elen)
	else
		return ''
	endif
endf "}}}1

function! xelltoolkit#get_file_url() "{{{1
" Apostrophes ( ’ ) %27 Colon ( : ) %3A Exclamation Mark ( ! ) %21 Spaces: (  ) %20
    return 'mvim://open?url=file://' . substitute(expand("%:p"), ' ', '%20', 'g') . '&line=' . line('.')
endfunction "}}}

function! xelltoolkit#get_copy(str) "{{{1
	if a:str != ''
		let @+ = a:str
		echomsg 'Copied ' . a:str
	else
		call xelltoolkit#echo_msg('Empty string. Nothing copied.')
	endif
endfunction
" }}}

function! xelltoolkit#search_word(pattern, direction) " {{{1
	let match_line = search(a:pattern, 's' . a:direction)
	if match_line == 0
		call xelltoolkit#echo_msg('There is no pattern to find!')
	endif
endfunction
" }}}

function! xelltoolkit#goto_next_word(pattern) " {{{1
	call xelltoolkit#search_word(a:pattern, '')
endfunction
" }}}

function! xelltoolkit#goto_pre_word(pattern) " {{{1
	call xelltoolkit#search_word(a:pattern, 'b')
endfunction
" }}}

" default: verbose, show message whatever
" d: dry-run, only display the statement
" s: silent run unless v:shell_error
" c: copy the output
function! xelltoolkit#system(cmd, ...) " {{{1
    let cmd = a:cmd
    if a:0 == 0
        echo system(cmd)
    elseif a:0 == 1 && a:1 == 'd'
        echo cmd
    elseif a:0 == 1 && a:1 == 's'
        let msg = system(cmd)
        if v:shell_error
            call xelltoolkit#echo_msg('Wrong: ' . msg . 'utf-8')
        endif
    elseif a:0 == 1 && a:1 == 'c'
        let @+ = system(cmd)
    else
        call xelltoolkit#echo_msg('Flag must be d, s or c!')
    endif
endfunction
" }}}

" default: verbose, show message whatever
" d: dry-run, only display the statement
" s: silent run unless v:shell_error
" c: copy the output
function! xelltoolkit#run(prg, file, ...) " {{{1
    if a:prg =~? '\.app$'
        let prg = 'open -a ' . fnameescape(a:prg)
    elseif a:prg == ''
        let prg = 'open '
    else
        let prg = fnameescape(a:prg)
    endif
    " Note mac can handle like 'http://ww.google.com/\#
    let file = fnameescape(a:file)
    " Temp hack, for http://www.com/c?a=1&b=2
    let file = escape(file, '&')

    if file == ''
        let cmd = prg
    else
        let cmd = prg . file
        " let cmd = prg . ' "' . file . '"'
    endif

    if a:0 == 0
        echo system(cmd)
    elseif a:0 == 1 && a:1 == 'd'
        echo cmd
    elseif a:0 == 1 && a:1 == 's'
        let msg = system(cmd)
        if v:shell_error
            call xelltoolkit#echo_msg('Wrong: ' . msg . 'utf-8')
        endif
    elseif a:0 == 1 && a:1 == 'c'
        let @+ = system(cmd)
    else
        call xelltoolkit#echo_msg('Flag must be d, s or c!')
    endif
endfunction
" }}}

function! xelltoolkit#fname_escape(fname) " {{{1
    return fnameescape(a:fname)
endfunction
" }}}

function! xelltoolkit#fname2pattern(fname) " {{{1
	let fname = a:fname
	let fname = escape(fname, '/\~&[]{}.')
	let fname = substitute(fname, ' ', '\\s', 'g')
	return fname
endfunction
" }}}

function! xelltoolkit#fname_ext(fname) " {{{1
	return matchstr(a:fname, '\.\zs[^.]\+\ze$')
endfunction
" }}}

function! xelltoolkit#fname_head(fname) " {{{1
    return substitute(a:fname, '\/[^/]\+$', '', '')
endfunction
" }}}

function! xelltoolkit#fname_name(fname) " {{{1
	"c.f. :ech matchstr('/a/b/c.d_f.e', '\zs[^\/]\+\ze\.[^\/]\+')
	return matchstr(a:fname, '\zs[^\/]\+\ze\.[^\/]\+')
endfunction
" }}}

function! xelltoolkit#fname_ext_mod(fname, ext_mod) " {{{1
	return substitute(a:fname, '\.\zs[^.]\+\ze$', a:ext_mod, '')
endfunction
" }}}

" Note : echo_msg will alwasy display unprintable chars as it is
function! xelltoolkit#echo_msg(msg) " {{{1
	" redraw
	echohl WarningMsg
	echomsg a:msg
	echohl None
endfunction
" }}}

function! xelltoolkit#edit_samename_file(ext) " {{{1
	let cur_filename = expand("%:t:r")
	if a:ext =~ '\.'
		let e_filename = cur_filename . a:ext
	else
		let e_filename = cur_filename . '.' . a:ext
	endif
	exec 'edit ' . fnameescape(e_filename)
endfunction "}}}

" :h QuickFixCmdPost-example
function! xelltoolkit#qf_make_conv()  " {{{1
	if !has("win32") && !has("win64")
		return
	endif

    let qflist = getqflist()
    for i in qflist
       let i.text = iconv(i.text, "cp936", "utf-8")
    endfor
    call setqflist(qflist)
endfunction "}}}

function! xelltoolkit#imap(lhs, rhs, buffer) " {{{1
	let lhs = a:lhs
	let rhs = a:rhs
	let num_of_left = strdisplaywidth(rhs) - match(rhs, '<++>', 0) - 5
	let rhs = substitute(a:rhs, '<++>', '', '')
	let str_left = ''
	while (num_of_left >= 0)
		let str_left .= '<Left>'
		let num_of_left -= 1
	endwhile

	if a:buffer
		exec 'inoremap <buffer> ' . lhs . ' ' . rhs . str_left
	else
		exec 'inoremap ' . lhs . ' ' . rhs . str_left
	endif
endfunction
" }}}

let g:grep_include_dict = {'note': ['t2t', 'md', 'mkd', 'txt'], 'vim': ['vim'], 'all': ['*']}
function! xelltoolkit#grep_in_lcd_r(option, include, pattern) " {{{

	let pattern = a:pattern

	" vimgrep: vimgrep /\cPATTERN/j ./**/*.type1 ./**/*.type2
    let cmd = 'silent! grep! -HnIr'

    if has_key(g:grep_include_dict, a:include)
        let filetypes = g:grep_include_dict[a:include]
    elseif a:include != ''
        let filetypes = [a:include]
    else
        let filetypes = g:grep_include_dict['all']
    endif
    for filetype in filetypes
        let cmd .= ' --include="*.' . filetype . '"'
    endfor

    if a:option == ''
        let cmd .= ' -i'
    endif

    let cmd .= ' "' . pattern . '" .'

	exec cmd

endfunction
"}}}

function! xelltoolkit#get_cmd_output(cmd) "{{{1
	redir @+>
	exec 'silent! ' . a:cmd
	redir END
endfunction
"}}}

function! xelltoolkit#get_buflist_cur_tab(include_cur_win) "{{{1
	" tabpagebuflist(NO_OF_TABPAGE) -> [1,3,1]
	" winnr('$') number of windows of current tabpage
	" winnr()  the no. of current window
	" bufname('%')
	let buflist_dup = tabpagebuflist()
	let d = {}
	let buflist = []

	" Remove duplicates in tabpagebuflist
	for item in buflist_dup
		if has_key(d, item)
			continue
		else
			" Use new list to maintain the order
			let d[item] = 1
			if item == winbufnr(0) && !a:include_cur_win
				continue
			else
				call add(buflist, bufname(item))
			endif
		endif
	endfor

	return buflist
endfunction
"}}}

" Delete file from disk
" c.f. http://vim.wikia.com/wiki/Delete_files_with_a_Vim_command
function xelltoolkit#delete_file(...) "{{{1
  if(exists('a:1'))
    let theFile=a:1
  elseif ( &ft == 'help' )
    echohl Error
    echo "Cannot delete a help buffer!"
    echohl None
    return -1
  else
    let theFile=expand('%:p')
  endif
  let delStatus=delete(theFile)
  if(delStatus == 0)
    echo "Deleted " . theFile
  else
    echohl WarningMsg
    echo "Failed to delete " . theFile . ' ' . delStatus
    echohl None
  endif
  return delStatus
endfunction
"}}}
