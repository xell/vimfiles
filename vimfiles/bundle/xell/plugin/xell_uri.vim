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

command -bang -nargs=? Open call Open(<bang>1, '<args>')

function! OpenInBrowser(strict, ...) " {{{1
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

	" If it's url, which can only be given via args
	if is_web_protocol
		let uri = cur_file_path
	" If it's file
	elseif cur_file_path =~? '^\(\/\|\a:\\\)'
		let webserver_dir = xelltoolkit#fname2pattern(g:webserver_dir)
		if g:isw && !&shellslash
			let webserver_dir .= '\'
		else
			let webserver_dir .= '/'
		endif

		" Determine if the filetype is supported by browser
		if a:strict
			let cur_file_ext = matchstr(cur_file_path, '\.\zs[^.]\+\ze$')
			if cur_file_ext !~? 'txt\|html\|htm\|xml\|php'
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



" End {{{1
let &cpo = s:savecpo
unlet s:savecpo

" vim:fdm=marker
" }}}
