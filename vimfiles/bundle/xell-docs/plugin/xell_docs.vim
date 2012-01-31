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

function! Convertx(in_type, out_type, config) " {{{1
	if exists('g:docs_convert_rules')
		call {g:docs_convert_rules[a:in_type]}(a:out_type, a:config)
	else
		call xelltoolkit#echo_msg('There is no pre-defined rules for conversion.')
		return
	endif
endfunction
" }}}

" Txt2tags converter {{{1
" txt2tags.py --style=xxx.css --config-file=xxx.t2t --outfile=xxx.html xxx.t2t
" t2tcf_html.t2t
" t2tcf_n_html.t2t
" t2tcf_rtf.t2t
" t2tcf_tex.t2t
" t2tcf_txt.t2t
" css/modern.css
" css/normal.css
" css/note.css
" xelltoolkit#fname_escape
function! T2TConverter(input, out_type, config)
	let slash = xelltoolkit#slash()
	
	" Output targets {{{2
	if !has_key(g:t2t_target_ext, a:out_type)
		call xelltoolkit#echo_msg('Unsupported target name!')
		return
	endif
	" }}}

	" Input and output file {{{2
	if a:input == ''
		let input = expand('%:p')
	else
		let input = a:input
	endif
	let output_file = xelltoolkit#fname_escape(xelltoolkit#fname_ext_mod(input, g:t2t_target_ext[a:out_type]))
	let input_file = xelltoolkit#fname_escape(input)
	" }}}

	" Config {{{2
	" Default
	if a:config == 'normal' && a:out_type == 'html'
		let style_file = xelltoolkit#fname_escape(g:t2t_cf_path . slash . 'css' . slash . 'normal.css')
		let config_file = xelltoolkit#fname_escape(g:t2t_cf_path . slash . 't2tcf_html.t2t')
		let config = ' --style=' . style_file . ' --config-file=' . config_file
	elseif a:config == 'note' && a:out_type == 'html'
		let style_file = xelltoolkit#fname_escape(g:t2t_cf_path . slash . 'css' . slash . 'note.css')
		let config_file = xelltoolkit#fname_escape(g:t2t_cf_path . slash . 't2tcf_n_html.t2t')
		let config = ' --style=' . style_file . ' --config-file=' . config_file

	" XXX hack : use a:out_type for config, don't care about a:config
	else
		let config_file = xelltoolkit#fname_escape(g:t2t_cf_path . slash . 't2tcf_' . a:out_type . '.t2t')
		if filereadable(config_file)
			let config = ' --config-file=' . config_file
		else
			let config = ''
		endif
	endif
	" }}}

	" Full exec
	let cmd = g:t2t_cmd . config . ' --target=' . a:out_type . ' --outfile=' . output_file . ' --infile=' . input_file
	call xelltoolkit#system(cmd)
endfunction
" }}}

" End {{{1
let &cpo = s:savecpo
unlet s:savecpo

" vim:fdm=marker
" }}}

