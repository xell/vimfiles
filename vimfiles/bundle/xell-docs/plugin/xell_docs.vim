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

" Pandoc converter {{{1
function! PandocConverter(input, out_type, config)
	let slash = xelltoolkit#slash()

	" Output targets {{{2
	if !has_key(g:pandoc_target_ext, a:out_type)
		call xelltoolkit#echo_msg('Unsupported target name!')
		return
	endif
	" }}}
	
	" let g:pandoc_target_ext = {'plain': 'txt', 'markdown': 'md', 'rst': 'rst', 'html': 'html', 'html5': 'html', 'latex': 'tex', 'mediawiki': 'wiki', 'opendocument': 'fodt', 'odt': 'odt', 'docx': 'docx', 'slidy': 'html', 'dzslides': 'html', 'rtf': 'rtf'}

	" html 可选：是否需要目录；哪个css样式；

	if a:out_type =~? 'html\|slidy\|dzslides'
		call Pandoc_html_conv(a:input, a:out_type, a:config)
		return
	endif

	if a:out_type =~? 'rst\|latex\|odt\|docx'
		call Pandoc_{a:out_type}_conv(a:input, a:out_type, a:config)
		return
	endif

	" Other targets
	" Config: W(wrap) t(no toc)
	let input = s:inputfile(a:input)
	let conf = ' -s -f markdown -t ' . a:out_type
	if a:config !~# 'W'
		let conf .= ' --no-wrap'
	endif
	let conf .= s:pandoc_bib_conf(a:input)
	if a:config =~? 't'
		if a:config =~# 'T'
			let conf .= ' --toc'
		endif
	elseif g:pandoc_toc_general
		let conf .= ' --toc'
	endif
	if g:pandoc_reference_links
		let conf .= ' --reference-links'
	endif
	let conf .= ' -o ' . xelltoolkit#fname_escape(xelltoolkit#fname_ext_mod(input, a:out_type == 'markdown' ? 'pd.md' : g:pandoc_target_ext[a:out_type])) . ' ' . xelltoolkit#fname_escape(input)

	call xelltoolkit#system(g:pandoc_exec . conf)

endfunction
" }}}

function! s:pandoc_bib_conf(input) " {{{1
	if a:input == ''
		let input_head = expand('%:p:h')
	else
		let input_head = xelltoolkit#fname_head(a:input)
	endif

	let bib_file = input_head . xelltoolkit#slash() . g:pandoc_bib
	if filereadable(bib_file)
		return ' --bibliography=' . xelltoolkit#fname_escape(bib_file) . ' --csl=' . xelltoolkit#fname_escape(g:pandoc_csl)
	else
		return ''
	endif
endfunction
" }}}

function! s:inputfile(input)
	if a:input == ''
		return expand('%:p')
	elseif glob(a:input) == ''
		call xelltoolkit#echo_msg('Wrong input file!')
		return
	else
		return a:input
	endif
endfunction


" End {{{1
let &cpo = s:savecpo
unlet s:savecpo

" vim:fdm=marker
" }}}

