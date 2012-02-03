
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



