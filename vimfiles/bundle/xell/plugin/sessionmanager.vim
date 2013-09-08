if exists('g:loaded_xell_sessionmanager')
	finish
endif
let g:loaded_xell_sessionmanager = 1

command! MS call <SID>makesession()
command! -nargs=? LS call <SID>loadsession('<args>')

function! s:makesession()

	if v:this_session == '' ||
			\ (v:this_session != '' &&
			\ input(v:this_session . "\nAre you sure overriding? (Y/n)") =~? '^n')
		let session_name = input("Session name: ")
		if session_name != ''
			let v:this_session = g:session_path . g:slash . session_name . '.vim'
		else
			call xelltoolkit#echo_msg("Empty session name. No session created!")
			return
		endif
	endif
	exec 'mks! ' . v:this_session
	call xelltoolkit#echo_msg("Save session " . v:this_session)
endfunction

function! s:loadsession(...)
	if a:1 != ''
		let session_name = g:session_path . g:slash . a:1 . '.vim'
		if filereadable(session_name)
			exec 'so ' . session_name
		else
			call xelltoolkit#echo_msg("There is no " . a:1 . " session!")
		endif
		return
	endif

	let session_files = split(substitute(
			\ glob(g:session_path . g:slash . '*.vim'),
			\ escape(g:session_path . g:slash, '/'), '', 'g'), '\n')

	topleft new
	setlocal hidden
	setlocal bufhidden=delete
	setlocal buftype=nofile
	set ft=sessionlist fenc=utf-8
	silent! file sessionlist

	call append(line(0), session_files)
	exec 'resize ' . (len(session_files) + 1)
	nmap <buffer> <Return> :exec 'so ' . g:session_path . g:slash . getline('.')<CR>
endfunction
