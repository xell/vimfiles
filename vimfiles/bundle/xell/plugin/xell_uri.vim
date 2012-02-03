" Author:   Xell Liu <xell DOT liu AT gmail.com>
" License:  Same terms as Vim itself (see :help license).
"

" Pre {{{1
if exists("g:loaded_xell_uri") || v:version < 700
  finish
endif
let g:loaded_xell_uri = 1

let s:savecpo = &cpo
set cpo&vim

" }}}

" Open in user specified browser {{{1
" Use ! to enforce unsupported file
function! OpenInBrowser(strict, ...)
	let is_web_protocol = 0

	" If uri is specified
	if a:0 == 1 && a:1 != '' && a:1 =~? g:urlpattern
		let cur_file_path = a:1
		let is_web_protocol = 1
	elseif a:0 == 1 && a:1 != ''
		let cur_file_path = glob(a:1)
		if cur_file_path == ''
			call xelltoolkit#echo_msg('Invalid filename. Please use full path!')
			return
		endif
	else
		let cur_file_path = expand("%:p")
	endif

	if !is_web_protocol && exists('g:browser_open_rules') && a:strict
		let cur_file_ext = xelltoolkit#fname_ext(cur_file_path)
		if has_key(g:browser_open_rules, cur_file_ext)
			let cur_file_path = {g:browser_open_rules[cur_file_ext]}(cur_file_path)
			if cur_file_path == ''
				call xelltoolkit#echo_msg('There is no output HTML file of the current file.')
				return 1
			endif
		endif
	endif

	" If it's url, which can only be given via args
	if is_web_protocol
		let uri = cur_file_path
	" If it's file
	elseif cur_file_path =~? '^\(\/\|\a:\\\)'
		let webserver_dir = xelltoolkit#fname2pattern(g:webserver_dir) . g:slash

		" Determine if the filetype is supported by browser
		if a:strict
			let cur_file_ext = xelltoolkit#fname_ext(cur_file_path)
			if cur_file_ext !~? 'txt\|html\|htm\|xhtml\|xml\|php'
				call xelltoolkit#echo_msg('The filetype is not supported by Browser. Please add ! to enforce.')
				return
			elseif cur_file_ext == 'php' && cur_file_path !~? webserver_dir
				call xelltoolkit#echo_msg('PHP file should be put in "' . g:webserver_dir . '" to make it work. Or add ! to enforce.')
				return
			endif
		endif

		if cur_file_path =~? webserver_dir
			let uri = substitute(cur_file_path, webserver_dir, g:webserver_host . '/', '')
		else
			let uri = cur_file_path
		endif
	else
		call xelltoolkit#echo_msg('Invalid URI!')
		return
	endif

	" Open processed uri
	call xelltoolkit#run(g:webbrowser, uri, 's')

endfunction
" }}}

" Open the folder of current buffer {{{1
" Windows : try to open it in TC, or else in Explorer
" Mac : open in Finder
command! -nargs=0 OpenInFolder call OpenInFolder()

function! OpenInFolder()
	if g:isw
		let totalcmd_exec = 'd:\p\totalcmd\totalcmd.exe'
		if executable(totalcmd_exec)
			call xelltoolkit#system(totalcmd_exec . ' /O /T /L="' . expand("%:p:h") . g:slash . '"')
			" exec 'silent !start d:\p\totalcmd\totalcmd.exe  /O /T /L="' . expand("%:p:h") . '\"'
		else
			call xelltoolkit#run('', expand("%:p:h") . g:slash)
		endif
	elseif g:ism
		call xelltoolkit#system('open .')
	endif
endfunction
" }}}

" End {{{1
let &cpo = s:savecpo
unlet s:savecpo

" vim:fdm=marker
" }}}
