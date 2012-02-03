
" General Config:
"     standa    : a
"     wrap      : w
"     fn_suffix : f
let g:pandoc_conf_general = 'A,w,f'
" Pandoc converter {{{1
function! PandocConverter(input, out_type, config)

	" Output targets check {{{2
	if !has_key(g:pandoc_target_ext, a:out_type)
		call xelltoolkit#echo_msg('Unsupported target name!')
		return
	endif
	" }}}
	
	" let g:pandoc_target_ext = {'plain': 'txt', 'markdown': 'md', 'rst': 'rst', 'html': 'html', 'html5': 'html', 'latex': 'tex', 'mediawiki': 'wiki', 'opendocument': 'fodt', 'odt': 'odt', 'docx': 'docx', 'slidy': 'html', 'dzslides': 'html', 'rtf': 'rtf'}

	if a:out_type =~? 'html\|slidy\|dzslides'
		call Pandoc_html_conv(a:input, a:out_type, a:config)
	elseif a:out_type =~? 'rst\|latex\|odt\|docx'
		call Pandoc_{a:out_type}_conv(a:input, a:out_type, a:config)
	else
		call Pandoc_other_conv(a:input, a:out_type, a:config)
	endif

endfunction
" }}}

" Other Config:
"     toc       : t
"     ref_link  : r
let g:pandoc_conf_other = 'T,R'
function! Pandoc_other_conv(input, out_type, config) " {{{1

	let conf_g = ',' . g:pandoc_conf_general
	let conf_s = ',' . g:pandoc_conf_other
	let conf_l = a:config == '' ? a:config : ',' . a:config
	
	let input = s:inputfile(a:input)
	let conf = ' -f markdown -t ' . a:out_type

	" General config {{{2
	if GetDocsConf(conf_g, conf_l, 'a') ==# 'A'
		let conf .= ' -s'
	endif
	if GetDocsConf(conf_g, conf_l, 'w') ==# 'w'
		let conf .= ' --no-wrap'
	endif
	if GetDocsConf(conf_g, conf_l, 'f') =~? 'f\w'
		let o_fname_suf = matchstr(GetDocsConf(conf_g, conf_l, 'f'), '\cf\zs.*$') . '.'
	elseif a:out_type == 'markdown'
		let o_fname_suf = 'pd.'
	else
		let o_fname_suf = ''
	endif
	" }}}

	" Specific config {{{2
	if GetDocsConf(conf_s, conf_l, 't') ==# 'T'
		let conf .= ' --toc'
	endif
	if GetDocsConf(conf_s, conf_l, 'r') ==# 'R'
		let conf .= ' --reference-links'
	endif
	" }}}

	" Biblio config {{{2
	let conf .= s:pandoc_bib_conf(a:input)
	" }}}

	let o_fname = xelltoolkit#fname_escape(xelltoolkit#fname_ext_mod(input, o_fname_suf . g:pandoc_target_ext[a:out_type]))

	let conf .= ' -o ' . o_fname . ' ' . xelltoolkit#fname_escape(input)

	call xelltoolkit#system(g:pandoc_exec . conf)

	return o_fname

endfunction
" }}}


" HTML Config: !(a w f)
"     template  : p
"     toc       : t
"     language  : l @ rst
"     css       : c : implies '--self-contained'
"     num_sec   : n
"     self_cont : z
"     num_level : v @ xell number by whole artical
"     num_chap  : h @ xell
"     rst?      : s
"     slide_inc : i
let g:pandoc_conf_html = 'p,T,lzh_CN,cnormal,N,z,f,V,h,s,I'
function! Pandoc_html_conv(input, out_type, config) " {{{1

	let conf_g = ',' . g:pandoc_conf_general
	let conf_s = ',' . g:pandoc_conf_html
	let conf_l = a:config == '' ? a:config : ',' . a:config

	" For md -> rst -> html conversion {{{2
	if GetDocsConf(conf_s, conf_l, 's') ==# 'S'
		let rst_temp_file = Pandoc_rst_conv(a:input, a:out_type, a:config)
		call RstConverter(rst_temp_file, a:out_type, a:config)
		return
	endif
	" }}}

	let input = s:inputfile(a:input)
	let conf = ' -f markdown -t ' . a:out_type

	" General config {{{2
	if GetDocsConf(conf_g, conf_l, 'a') ==# 'A'
		let conf .= ' -s'
	endif
	if GetDocsConf(conf_g, conf_l, 'w') ==# 'w'
		let conf .= ' --no-wrap'
	endif
	if GetDocsConf(conf_g, conf_l, 'f') =~? 'f\w'
		let o_fname_suf = matchstr(GetDocsConf(conf_g, conf_l, 'f'), '\cf\zs.*$') . '.'
	elseif a:out_type == 'markdown'
		let o_fname_suf = 'pd.'
	else
		let o_fname_suf = ''
	endif
	" }}}

	" Specific config {{{2
	" template p
	let conf_v_tpl = strpart(GetDocsConf(conf_s, conf_l, 'p'), 1) 
	if conf_v_tpl != ''
		let conf_v_tpl = xelltoolkit#fname_escape(g:pandoc_htmltpl_root . g:slash . conf_v_tpl . '.html')
		let conf .= ' --template=' . conf_v_tpl
	endif

	" toc t
	if GetDocsConf(conf_s, conf_l, 't') ==# 'T'
		let conf .= ' --toc'
	endif

	" css c
	" Note : --css only link file but not embed it
	let conf_v_css = strpart(GetDocsConf(conf_s, conf_l, 'c'), 1) 
	if conf_v_css != ''
		let conf_v_css = xelltoolkit#fname_escape(g:pandoc_css_root . g:slash . conf_v_css . '.html')
		let conf .= ' -H ' . conf_v_css
	endif

	" number-sections n
	if GetDocsConf(conf_s, conf_l, 'n') ==# 'N'
		let conf .= ' -N'
	endif

	" self-contained z
	if GetDocsConf(conf_s, conf_l, 'z') ==# 'Z'
		let conf .= ' --self-contained'
	endif

	" For slides, incremental i
	if a:out_type !~? 'html' && GetDocsConf(conf_s, conf_l, 'i') ==# 'I'
		let conf .= ' -i'
	endif
	" }}}

	let conf .= ' --section-divs'

	" Biblio config {{{2
	let conf .= s:pandoc_bib_conf(a:input)
	" }}}

	let o_fname = xelltoolkit#fname_escape(xelltoolkit#fname_ext_mod(input, o_fname_suf . g:pandoc_target_ext[a:out_type]))

	let conf .= ' -o ' . o_fname . ' ' . xelltoolkit#fname_escape(input)

	call xelltoolkit#system(g:pandoc_exec . conf)

	return o_fname
endfunction
" }}}




function! Pandoc_rst_conv(input, out_type, config) " {{{1
	echo 'Placeholder'
endfunction
" }}}

" Tools {{{1

function! s:pandoc_bib_conf(input) " {{{2
	if a:input == ''
		let input_head = expand('%:p:h')
	else
		let input_head = xelltoolkit#fname_head(a:input)
	endif

	let bib_file = input_head . g:slash . g:pandoc_bib
	if filereadable(bib_file)
		return ' --bibliography=' . xelltoolkit#fname_escape(bib_file) . ' --csl=' . xelltoolkit#fname_escape(g:pandoc_csl)
	else
		return ''
	endif
endfunction
" }}}

function! s:inputfile(input) " {{{2
	if a:input == ''
		return expand('%:p')
	elseif glob(a:input) == ''
		call xelltoolkit#echo_msg('Wrong input file!')
		return
	else
		return a:input
	endif
endfunction
" }}}

" }}}

