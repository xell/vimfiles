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

" Global {{{1
" These convert rule functions only consider current buffer
" Definition : function Wrapper(out_type, config)
let g:docs_convert_buffer_rules = {
			\ 'txt2tags': 'Txt2tagsConvertBufferWrapper',
			\ 'pandoc': 'PandocConvertBufferWrapper',
			\ 'rst': 'RstConvertBufferWrapper',
			\ 'filelist': 'NotesConvertWrapper'}

" Text2tags specification {{{3
let g:t2t_cmd = '/usr/local/bin/txt2tags'
let g:t2t_cf_path = glob('~/Documents/_special/_tpl/t2t')

let g:t2t_target_ext = {'html': 'html', 'md': 'md', 'rst': 'rst', 'txt': 'txt', 'html5': 'html', 'rtf': 'rtf', 'tex': 'tex'}
" }}}

" Pandoc specification {{{3
let g:pandoc_syntax_accuracy = 1
let g:pandoc_syntax_full_html_tex = 1
let g:pandoc_syntax_table = 0
let g:pandoc_fold_level = 2

let g:pandoc_target_ext = {'plain': 'txt', 'markdown': 'md', 'rst': 'rst', 'html': 'html', 'html5': 'html', 'latex': 'tex', 'mediawiki': 'wiki', 'opendocument': 'fodt', 'odt': 'odt', 'docx': 'docx', 'slidy': 'html', 'dzslides': 'html', 'rtf': 'rtf'}

let g:pandoc_exec = 'pandoc'
let g:pandoc_tpl_root = '/Users/xell/Documents/_special/_tpl/pandoc'
let g:pandoc_csl_root = g:pandoc_tpl_root . '/csl'
let g:pandoc_css_root = g:pandoc_tpl_root . '/css'
let g:pandoc_htmltpl_root = g:pandoc_tpl_root . '/html'
let g:pandoc_docx_root = g:pandoc_tpl_root . '/docx'
let g:pandoc_odt_root = g:pandoc_tpl_root . '/odt'
let g:pandoc_bib = 'biblio.bib'
let g:pandoc_csl = g:pandoc_csl_root . '/Chinese-GB7714-2005-Numeric-1.0.csl'

" }}}

" Rst Docutils specification {{{3
let g:rst_target_ext = {'html': 'html', 'odt': 'odt'}

let g:rst2odt_exec = 'rst2odt.py'
let g:rst2html_exec = 'rst2html.py'
let g:rst_tpl_root = '/Users/xell/Documents/_special/_tpl/docutils'
let g:rst_html_root = g:rst_tpl_root . '/html'
let g:rst_html_tpl_root = g:rst_html_root . '/tpl'
let g:rst_html_style_root = g:rst_html_root . '/style'
let g:rst_odt_style_root = g:rst_tpl_root . '/odt'
" }}}

" }}}

command! -nargs=* ConvertBuffer :call <SID>convert_buffer(<f-args>)

function! s:convert_buffer(...) " {{{1
	let in_type = &ft
	if a:0 == 0
		call ConvertBuffer(in_type, '', '')
	elseif a:0 == 1
		call ConvertBuffer(in_type, a:1, '')
	elseif a:0 == 2
		call ConvertBuffer(in_type, a:1, a:2)
	else
		call xelltoolkit#echo_msg('Too many args!')
		return
	endif
endfunction
" }}}

function! ConvertBuffer(in_type, out_type, config) " {{{1
	if exists('g:docs_convert_buffer_rules') && has_key(g:docs_convert_buffer_rules, a:in_type)
		call {g:docs_convert_buffer_rules[a:in_type]}(a:out_type, a:config)
	else
		call xelltoolkit#echo_msg('There is no pre-defined rules for conversion.')
		return
	endif
endfunction
" }}}

" Docs configuration reader {{{1
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

function! s:conf_read(config, flag)
	return matchstr(a:config, '\c,\zs' . a:flag . '[^,]*')
endfunction

" }}}

" End {{{1
let &cpo = s:savecpo
unlet s:savecpo

" vim:fdm=marker
" }}}

