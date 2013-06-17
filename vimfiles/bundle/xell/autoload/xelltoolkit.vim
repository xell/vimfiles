
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

function! xelltoolkit#slash() " {{{1
	if g:isw && !&shellslash
		return '\'
	else
		return '/'
	endif
endfunction
" }}}

function! xelltoolkit#slash_p() " {{{1
	if g:isw && !&shellslash
		return '\\'
	elseif g:ism
		return '\/'
	endif
endfunction
" }}}

" default: verbose, show message whatever
" d: dry-run, only display the statement
" s: silent run unless v:shell_error
" c: copy the output
function! xelltoolkit#system(cmd, ...) " {{{1
	if g:isw
		let cmd = a:cmd
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
	elseif g:ism
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
	else
		call xelltoolkit#echo_msg('Not support!')
	endif
endfunction
" }}}

" default: verbose, show message whatever
" d: dry-run, only display the statement
" s: silent run unless v:shell_error
" c: copy the output
function! xelltoolkit#run(prg, file, ...) " {{{1
	" Something useful {{{2
	" exec iconv('silent! ! start "Title" "c:\Program Files\Internet Explorer\iexplore.exe" "d:\测试\新的.html"', 'utf-8', g:codepage)
	" echo iconv(system(iconv(' start /b "Title" "c:\Program Files\Internet Explorer\iexplore.exe" d:\测试 a\!新的.html', 'utf-8', g:codepage)), g:codepage, 'utf-8')
	" IE is special, don't need double-quotes even if there is space in
	" filename.
	" }}}
	
	if g:isw
	" Windows {{{2
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
		elseif a:file =~ '\s\|&'
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
	elseif g:ism
	" Mac {{{2
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
			let cmd = prg . ' "' . file . '"'
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

function! xelltoolkit#fname_escape(fname) " {{{1
	if g:isw
		return shellescape(a:fname)
	elseif g:ism
		return fnameescape(a:fname)
	endif
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
	if g:isw
		return substitute(a:fname, '\\[^\\]\+$', '', '')
	elseif g:ism
		return substitute(a:fname, '\/[^/]\+$', '', '')
	endif
endfunction
" }}}

function! xelltoolkit#fname_name(fname) " {{{1
	let slash_p = xelltoolkit#slash_p()
	"c.f. :ech matchstr('/a/b/c.d_f.e', '\zs[^\/]\+\ze\.[^\/]\+')
	return matchstr(a:fname, '\zs[^' . slash_p . ']\+\ze\.[^' . slash_p . ']\+')
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
	let num_of_left = strlen(rhs) - match(rhs, '<++>', 0) - 5
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

	let is_win = 0

	let pattern = a:pattern
	if (g:isw && pattern =~? '[^\x00-\xff]') || !executable('grep')
		let is_win = 1
	endif

	" vimgrep: vimgrep /\cPATTERN/j ./**/*.type1 ./**/*.type2
	if is_win
		let cmd = 'vimgrep '
		" only one option: ignore case
		if a:option == ''
			let cmd .= '/\c' . pattern . '/j'
		else
			let cmd .= '/' . pattern . '/j'
		endif

		if has_key(g:grep_include_dict, a:include)
			let filetypes = g:grep_include_dict[a:include]
		elseif a:include != ''
			let filetypes = [a:include]
		else
			let filetypes = g:grep_include_dict['all']
		endif
		for filetype in filetypes
			let cmd .= ' ./**/*.' . filetype
		endfor
	" grep:    grep  -HnIr --include="*.t2t" --include="*.md" "zen" .
	else
		let cmd = 'grep! -HnIr'

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
	endif

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
