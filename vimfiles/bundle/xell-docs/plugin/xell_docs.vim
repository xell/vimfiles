" Author:   Xell Liu <xell DOT liu AT gmail.com>
" License:  Same terms as Vim itself (see :help license).
"

" Pre {{{1
if exists("g:loaded_xell_docs") || v:version < 700
  finish
endif
let g:loaded_xell_docs = 1

let s:savecpo = &cpo
set cpo&vim

" }}}

command! -nargs=* Convert :call <SID>conversion_wrapper(<f-args>)

function! s:conversion_wrapper(...) " {{{1
	let in_type = &ft
	if a:0 == 0
		call Convertx(in_type, '', '')
	elseif a:0 == 1
		call Convertx(in_type, a:1, '')
	elseif a:0 == 2
		call Convertx(in_type, a:1, a:2)
	else
		call xelltoolkit#echo_msg('Too many args!')
		return
	endif
endfunction
" }}}

" Only consider in_type but not in_file_full_path
function! Convertx(in_type, out_type, config) " {{{1
	if exists('g:docs_convert_rules')
		call {g:docs_convert_rules[a:in_type]}(a:out_type, a:config)
	else
		call xelltoolkit#echo_msg('There is no pre-defined rules for conversion.')
		return
	endif
endfunction
" }}}

" Docs configuration reader {{{1
function! s:conf_read(config, flag)
	return matchstr(a:config, '\c,\zs' . a:flag . '[^,]*')
endfunction

function! GetDocsConf(config_g, config_l, flag)
	let config_g = s:conf_read(a:config_g, a:flag)
	let config_l = s:conf_read(a:config_l, a:flag)

	" XXX No bug-proof
	if config_l != ''
		return config_l
	elseif config_g != ''
		return config_g
	else
		return ''
	endif
endfunction
" }}}

" End {{{1
let &cpo = s:savecpo
unlet s:savecpo

" vim:fdm=marker
" }}}

