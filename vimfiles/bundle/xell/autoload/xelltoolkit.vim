
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

" e: only echo | n: no silent | u: utf-8, no iconv
" TODO modify as with #run
function! xelltoolkit#shell_exec(cmd, ...) " {{{1
	let exec_cmd_ori = a:cmd
	let exec_cmd_esc = escape(a:cmd, '!#;|%')
	if g:isw
		" let exec_cmd_esc = substitute(exec_cmd_esc, '\/', '\\', 'g')
		" Hack for soffice macro:/// or other protocol like file:/// XXX
		" let exec_cmd_esc = substitute(exec_cmd_esc, ':\\\\\\', ':\/\/\/', 'g')
		if (a:cmd =~? '[^\x00-\xff]') && (a:0 == 0 || (a:0 != 0 && a:1 !~? 'u'))
			let exec_cmd_esc = iconv(exec_cmd_esc, 'utf-8', g:codepage)
		endif
		let exec_cmd_icv = exec_cmd_esc
	elseif g:ism
		let exec_cmd_icv = exec_cmd_esc
	endif

	if a:0 != 0 && a:1 =~? '[en]\+'
		if a:1 == 'e'
			echo "ori : " . exec_cmd_ori
			echo "esc : " . exec_cmd_esc
			echo "icv : " . exec_cmd_icv
		elseif a:1 == 'n'
			if g:isw
				echo iconv(system(exec_cmd_icv), g:codepage, 'utf-8')
			elseif g:ism
				echo system(exec_cmd_icv)
			endif
		endif
	elseif a:0 == 0
		let msg = system(exec_cmd_icv)
		if v:shell_error
			if g:isw
				let msg = iconv(msg, g:codepage, 'utf-8')
			endif
			call xelltoolkit#echo_msg('Invalid command. Shell return: ' . msg)
		endif
	else
		call xelltoolkit#echo_msg('Wrong flag, which must be e, n and/or u.')
	endif

endfunction
" }}}

" default: verbose, show message whatever
" d: dry-run, only display the statement
" s: silent run unless v:shell_error
" c: copy the output
function! xelltoolkit#run(prg, file, ...) " {{{1
	" Windows {{{2
	if g:isw
		" let prg = a:prg =~ '\s' ? ' start /b "Title" ' . shellescape(a:prg) : a:prg
		if a:prg == ''
			let prg = ' start /b "Title" '
		elseif a:prg =~ '\s'
			let prg = ' start /b "Title" ' . shellescape(a:prg)
		else
			let prg = a:prg
		endif

		" File part
		if a:file == ''
			let file = ''
		elseif a:prg =~? 'iexplore\.exe'
			" Hack for ie
			let file = a:file
		elseif a:file =~ '\s'
			" Just surroud it double-quote
			let file = shellescape(a:file)
		else
			let file = a:file
		endif

		let cmd = prg . ' ' . file
		let cmd_iconv = iconv(cmd, 'utf-8', g:codepage)

		if a:0 == 0
			echo iconv(system(cmd_iconv), g:codepage, 'utf-8')
		elseif a:0 == 1 && a:1 == 'd'
			echo cmd
			echo cmd_iconv
		elseif a:0 == 1 && a:1 == 's'
			let msg = system(cmd_iconv)
			if v:shell_error
				call xelltoolkit#echo_msg('Wrong: ' . iconv(msg, g:codepage, 'utf-8'))
			endif
		elseif a:0 == 1 && a:1 == 'c'
			let @+ = iconv(system(cmd_iconv), g:codepage, 'utf-8')
		else
			call xelltoolkit#echo_msg('Flag must be d, s or c!')
		endif
		" }}}
	" Mac {{{2
	elseif g:ism
		if a:prg =~? '\.app$'
			let prg = 'open -a ' . fnameescape(a:prg)
		elseif a:prg == ''
			let prg = 'open '
		else
			let prg = fnameescape(a:prg)
		endif
		" Note mac can handle like 'http://ww.google.com/\#
		let file = fnameescape(a:file)

		if file == ''
			let cmd = prg
		else
			let cmd = prg . ' ' . file
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
		" }}}
	else
		call xelltoolkit#echo_msg('Not support!')
	endif
endfunction
" }}}

function! xelltoolkit#fname2pattern(fname) " {{{1
	let fname = a:fname
	let fname = escape(fname, '/\~&[]{}')
	let fname = substitute(fname, ' ', '\s', 'g')
	return fname
endfunction
" }}}

" Note echo_msg will alwasy display unprintable chars as it is
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
	exec 'edit ' . e_filename
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

