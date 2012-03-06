
" General Config:
"     standa    : a
"     wrap      : w
"     fn_suffix : f
let g:pandoc_conf_general = 'A,w,f'

" Pandoc converter {{{1
function! PandocConverter(input, out_type, config, out_path)

	" Output targets check {{{2
	if !has_key(g:pandoc_target_ext, a:out_type)
		call xelltoolkit#echo_msg('Unsupported target name!')
		return
	endif
	" }}}
	
	" let g:pandoc_target_ext = {'plain': 'txt', 'markdown': 'md', 'rst': 'rst', 'html': 'html', 'html5': 'html', 'latex': 'tex', 'mediawiki': 'wiki', 'opendocument': 'fodt', 'odt': 'odt', 'docx': 'docx', 'slidy': 'html', 'dzslides': 'html', 'rtf': 'rtf'}

	if a:out_type =~? 'html\|slidy\|dzslides'
		call Pandoc_html_conv(a:input, a:out_type, a:config, a:out_path)
	elseif a:out_type =~? 'rst\|latex\|odt\|docx'
		call Pandoc_{a:out_type}_conv(a:input, a:config, a:out_path)
	else
		call Pandoc_other_conv(a:input, a:out_type, a:config, a:out_path)
	endif

endfunction
" }}}

" Other Config:
"     toc       : t
"     ref_link  : r
"     language  : l @ xell
let g:pandoc_conf_other = 'T,R,lzh'
function! Pandoc_other_conv(input, out_type, config, out_path) " {{{1

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

	" Output file {{{2
	if a:out_path == ''
		let o_fname_raw = xelltoolkit#fname_ext_mod(input, o_fname_suf . g:pandoc_target_ext[a:out_type])
	else
		let o_fname_raw = a:out_path . g:slash . xelltoolkit#fname_name(input) . '.' . o_fname_suf . g:pandoc_target_ext[a:out_type]
	endif
	let o_fname = xelltoolkit#fname_escape(o_fname_raw)
	" }}}

	" Markdown pre-process {{{2
	let input = s:mkd_preproc_no_numbering(input, 'tmp.md', g:pandoc_conf_other, a:config)
	" }}}

	let conf .= ' -o ' . o_fname . ' ' . xelltoolkit#fname_escape(input)

	call xelltoolkit#system(g:pandoc_exec . conf)

	" Delete pre-process file {{{2
	let del_err = delete(input)
	if del_err
		call xelltoolkit#echo_msg('Error while deleting temp file: ' . input)
		return ''
	endif
	" }}}

	return o_fname_raw

endfunction
" }}}


" HTML Config: !(a w f)
"     template  : p
"     toc       : t
"     language  : l @ xell
"     css       : c : implies '--self-contained'
"     num_sec   : n
"     self_cont : z
"     num_level : v @ xell number by whole artical
"     num_chap  : h @ xell
"     rst?      : s
"     slide_inc : i
let g:pandoc_conf_html = 'p,T,lzh,cnormal,N,z,V,h,s,I'
function! Pandoc_html_conv(input, out_type, config, out_path) " {{{1

	let conf_g = ',' . g:pandoc_conf_general
	let conf_s = ',' . g:pandoc_conf_html
	let conf_l = a:config == '' ? a:config : ',' . a:config

	" For md -> rst -> html conversion {{{2
	if GetDocsConf(conf_s, conf_l, 's') ==# 'S'
		let conf_l = a:config == '' ? 'M,t' : a:config . ',M'
		let rst_temp_file = Pandoc_rst_conv(a:input, conf_l, a:out_path)
		" call Rst_html_conv(rst_temp_file, a:config, a:out_path)
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

	" Output file {{{2
	if a:out_path == ''
		let o_fname_raw = xelltoolkit#fname_ext_mod(input, o_fname_suf . g:pandoc_target_ext[a:out_type])
	else
		let o_fname_raw = a:out_path . g:slash . xelltoolkit#fname_name(input) . '.' . o_fname_suf . g:pandoc_target_ext[a:out_type]
	endif
	let o_fname = xelltoolkit#fname_escape(o_fname_raw)
	" }}}

	" Markdown pre-process {{{2
	if GetDocsConf(conf_s, conf_l, 'n') ==# 'N'
		let input = s:mkd_preproc_numbering(input, 'tmp.md', g:pandoc_conf_html, a:config)
	else
		let input = s:mkd_preproc_no_numbering_html(input, 'tmp.md', a:config)
	endif
	let input = s:mkd_preproc_html(input, 'tmp.md')
	" }}}

	let conf .= ' -o ' . o_fname . ' ' . xelltoolkit#fname_escape(input)

	call xelltoolkit#system(g:pandoc_exec . conf)

	" Delete pre-process file {{{2
	let del_err = delete(input)
	if del_err
		call xelltoolkit#echo_msg('Error while deleting temp file: ' . input)
		return ''
	endif
	" }}}

	return o_fname_raw
endfunction
" }}}

" RST Config: !(a w f)
"     template  : p
"     toc       : t
"     num_sec   : n
"     ref_link  : r
"     language  : l @ xell
"     num_level : v @ xell number by whole artical
"     num_chap  : h @ xell
"     middle    : m @ xell
let g:pandoc_conf_rst = 'p,T,N,r,lzh,V,h,m'
" XXX toc and num_sec doesn't work?
function! Pandoc_rst_conv(input, config, out_path) " {{{1

	let conf_g = ',' . g:pandoc_conf_general
	let conf_s = ',' . g:pandoc_conf_rst
	let conf_l = a:config == '' ? a:config : ',' . a:config

	let input = s:inputfile(a:input)
	let conf = ' -f markdown -t rst'

	" General config {{{2
	if GetDocsConf(conf_g, conf_l, 'a') ==# 'A'
		let conf .= ' -s'
	endif
	if GetDocsConf(conf_g, conf_l, 'w') ==# 'w'
		let conf .= ' --no-wrap'
	endif
	if GetDocsConf(conf_g, conf_l, 'f') =~? 'f\w'
		let o_fname_suf = matchstr(GetDocsConf(conf_g, conf_l, 'f'), '\cf\zs.*$') . '.'
	else
		let o_fname_suf = ''
	endif
	" }}}

	" Specific config {{{2
	" template p
	let conf_v_tpl = strpart(GetDocsConf(conf_s, conf_l, 'p'), 1) 
	if conf_v_tpl != ''
		let conf_v_tpl = xelltoolkit#fname_escape(g:pandoc_htmltpl_root . g:slash . conf_v_tpl . '.rst')
		let conf .= ' --template=' . conf_v_tpl
	endif

	" toc t
	if GetDocsConf(conf_s, conf_l, 't') ==# 'T'
		let conf .= ' --toc'
		let make_toc = 1
	else
		let make_toc = 0
	endif

	" number-sections n
	if GetDocsConf(conf_s, conf_l, 'n') ==# 'N'
		let conf .= ' -N'
		let make_num_sec = 1
	else
		let make_num_sec = 0
	endif

	" reference-links r
	if GetDocsConf(conf_s, conf_l, 'r') ==# 'R'
		let conf .= ' --reference-links'
	endif

	" middle file for md->rst->html m
	if GetDocsConf(conf_s, conf_l, 'm') ==# 'M'
		let o_fname_suf = 'middle.'
	endif
	" }}}

	" Biblio config {{{2
	let conf .= s:pandoc_bib_conf(a:input)
	" }}}

	" Output file {{{2
	if a:out_path == ''
		let o_fname_raw = xelltoolkit#fname_ext_mod(input, o_fname_suf . g:pandoc_target_ext['rst'])
	else
		let o_fname_raw = a:out_path . g:slash . xelltoolkit#fname_name(input) . '.' . o_fname_suf . g:pandoc_target_ext['rst']
	endif
	let o_fname = xelltoolkit#fname_escape(o_fname_raw)
	" }}}

	" Markdown pre-process {{{2
	if GetDocsConf(conf_s, conf_l, 'n') ==# 'N'
		let input = s:mkd_preproc_numbering(input, 'tmp.md', g:pandoc_conf_html, a:config)
	else
		let input = s:mkd_preproc_no_numbering_html(input, 'tmp.md', a:config)
	endif
	" }}}

	let conf .= ' -o ' . o_fname . ' ' . xelltoolkit#fname_escape(input)

	call xelltoolkit#system(g:pandoc_exec . conf)

	" Delete pre-process file {{{2
	let del_err = delete(input)
	if del_err
		call xelltoolkit#echo_msg('Error while deleting temp file: ' . input)
		return ''
	endif
	" }}}

	" Manipulates the generated rst {{{2
	" To conform to the standard of reStructuredText
    let rstfile = readfile(o_fname_raw)
	let conf_v_lang = strpart(GetDocsConf(conf_s, conf_l, 'l'), 1)

	" Change the title line {{{3
	let line_num = 1
	let end = len(rstfile)
	while (line_num < end)
		let pre = rstfile[line_num - 1]
		let cur = rstfile[line_num]
		if cur =~? '^\(=\|-\|\~\|\^\)\{2,}'
			let rstfile[line_num] = repeat(strpart(cur, 0, 1), strwidth(pre))
		endif
		let line_num = line_num + 1
	endwhile
	unlet end


	" If there is main title
	let subtitle = ''
	if rstfile[0] =~ '^=\+' && rstfile[2] =~ '^=\+' && rstfile[3] == ''
		" Single title
		let rstfile[0] = repeat('=', strwidth(rstfile[1]))
	elseif rstfile[0] =~ '^=\+' && rstfile[3] =~ '^=\+'
		" Double title, i.e. subtitle
		let rstfile[0] = repeat('=', strwidth(rstfile[1]))
		let subtitle = substitute(rstfile[2], '^\s*', '', '')
		let rstfile[2] = rstfile[0]
		call insert(rstfile, '', 4)
		call insert(rstfile, subtitle, 5)
		call insert(rstfile, '', 6)
		let rstfile[3] = ''
		let rstfile[4] = repeat('-', strwidth(rstfile[5]))
		let rstfile[6] = rstfile[4]
	endif
	" }}}

	" Change Author and Date to Chinese {{{3
	if conf_v_lang == 'zh'
		let line_num = 0
		let end_of_file = len(rstfile)
		while (line_num < end_of_file)
			let cur = rstfile[line_num]
			if cur =~ '^\s*:Author:'
				let rstfile[line_num] = substitute(cur, ':Author:', ':作者:', '')
			endif
			if cur =~ '^\s*:Date:'
				let rstfile[line_num] = substitute(cur, ':Date:', ':日期:', '')
			endif
			let line_num = line_num + 1
		endwhile
		unlet line_num end_of_file
	endif
	" }}}

	" Conditionally add toc {{{3
	" 加入 .. contents:: Table of Contents 可以得到目录
	" 参见 http://docutils.sourceforge.net/docs/ref/rst/directives.html#table-of-contents

	if make_toc
		let end = len(rstfile)

		let first_title_num = 99999
		let first_datefield_num = -1
		let insert_num = -1

		if subtitle == ''
			let pattern = '^=\{2,}'
			let line_num = 1
		else
			let pattern = '^-\{2,}'
			let line_num = 5
		endif

		while (line_num < end)
			let cur = rstfile[line_num]
			if cur =~ pattern
				let first_title_num = line_num < first_title_num ? line_num : first_title_num
			endif
			" FIXME
			" if cur =~ '^:Date:\s' || cur =~ '^:Author:\s'
			" 	let first_datefield_num = line_num + 1
			if cur =~ '^:Date:\s'
				let first_datefield_num = line_num
				break
			endif
			let line_num = line_num + 1
		endwhile

		let insert_num = first_title_num > first_datefield_num ? first_title_num : first_datefield_num
		if conf_v_lang == 'zh'
			let xell_docs_toc_title = '目　录'
		else
			let xell_docs_toc_title = 'Table of Contents'
		endif
		if insert_num - 4 < end
			call insert(rstfile, '.. contents:: ' . xell_docs_toc_title, insert_num + 2)
			call insert(rstfile, '   :backlinks: entry', insert_num + 3)
			call insert(rstfile, '', insert_num + 4)
		endif

		unlet end first_title_num first_datefield_num insert_num
	endif
	" }}}

	" Add blank line after figure block {{{3
	let line_num = 1
	while (line_num < len(rstfile))
		let pre = rstfile[line_num - 1]
		let cur = rstfile[line_num]
		if (pre =~? '^\s\+[^ ]\+') && (cur =~? '^[^ ]\+')
			call insert(rstfile, '', line_num)
			let line_num = line_num + 1
		endif
		let line_num = line_num + 1
	endwhile
	" }}}

	" Delete blank line inside table {{{3
	let line_num = 1
	while (line_num < len(rstfile) - 1)
		let pre = rstfile[line_num - 1]
		let cur = rstfile[line_num]
		let next = rstfile[line_num + 1]
		if (pre =~? '^\s*|\s') && (cur =~? '^\s*$') && (next =~? '^\s*+-\+[+-]\+$')
			call remove(rstfile, line_num)
		endif
		let line_num = line_num + 1
	endwhile
	" }}}

	" Make table title by `.. Table::` directive {{{3
	let line_num = 1
	let end = len(rstfile)
	let table_start = []
	let table_cap = []

	" Record the line num of table caption and the start of table
	" Meanwhile change syntax of them
	while (line_num < end - 1)

		let pre = rstfile[line_num - 1]
		let cur = rstfile[line_num]
		let next = rstfile[line_num + 1]

		if (pre == '') && (cur =~? '^+-\+') && (next =~? '^|')
			call add(table_start, line_num)
		endif

		if (cur =~ '^Table:\s')
			call add(table_cap, line_num)
			let rstfile[line_num] = substitute(rstfile[line_num], '^Table:', '.. Table::', '')
		endif

		if (cur =~ '^\(+[-=]\+\||\)')
			let rstfile[line_num] = '   ' . rstfile[line_num]
		endif

		let line_num = line_num + 1
	endwhile

	" unlet end table_start table_cap
	" FIXME
	let index_num = 0
	let end = len(table_start)

	" Manipulate them
	if len(table_cap) > 0
		while (index_num < end )
			call insert(rstfile, rstfile[table_cap[index_num]], table_start[index_num])
			call map(table_cap, 'v:val + 1')
			call map(table_start, 'v:val + 1')

			call insert(rstfile, '', table_start[index_num])
			call map(table_cap, 'v:val + 1')
			call map(table_start, 'v:val + 1')

			call remove(rstfile, table_cap[index_num])
			call map(table_cap, 'v:val - 1')
			call map(table_start, 'v:val - 1')

			call remove(rstfile, table_cap[index_num])
			call map(table_cap, 'v:val - 1')
			call map(table_start, 'v:val - 1')

			let index_num = index_num + 1
		endwhile
	endif
	unlet end table_start table_cap index_num
	" }}}

	" Add sectnum {{{3
	if make_num_sec
		call add(rstfile, '')
		call add(rstfile, '.. sectnum::', )
		call add(rstfile, '')
	endif
	" }}}

	" Add space to * ` _ delete [STRIKEOUT: {{{3
	let line_num = 0
	let end = len(rstfile)
	let exists_strikeout = 0
	while (line_num < end)
		let rstfile[line_num] = substitute(rstfile[line_num],
					\           '\%d160', ' ', 'g')
		" **word**
		let rstfile[line_num] = substitute(rstfile[line_num],
					\           '\([^\x00-\xff]\)\([*]\+[^*]\+[*]\+\)', '\1\\ \2', 'g')
		let rstfile[line_num] = substitute(rstfile[line_num],
					\           '\([*]\+[^*]\+[*]\+\)\([^\x00-\xff]\)', '\1\\ \2', 'g')
		" ``word``
		let rstfile[line_num] = substitute(rstfile[line_num],
					\           '\([^\x00-\xff]\)\([`]\{2}[^`]\+[`]\{2}\)', '\1\\ \2', 'g')
		let rstfile[line_num] = substitute(rstfile[line_num],
					\           '\([`]\{2}[^`]\+[`]\{2}\)\([^\x00-\xff]\)', '\1\\ \2', 'g')
		" `word`_
		let rstfile[line_num] = substitute(rstfile[line_num],
					\           '\([^\x00-\xff]\)\([`][^`]\+[`]_\)', '\1\\ \2', 'g')
		let rstfile[line_num] = substitute(rstfile[line_num],
					\           '\([`][^`]\+[`]_\)\([^\x00-\xff]\)', '\1\\ \2', 'g')
		" word_
		let rstfile[line_num] = substitute(rstfile[line_num],
					\           '\([^\x00-\xff]\)\(_\)', '\1\\ \2', 'g')
		let rstfile[line_num] = substitute(rstfile[line_num],
					\           '\(_\)\([^\x00-\xff]\)', '\1\\ \2', 'g')
		" .. _\ chinese
		let rstfile[line_num] = substitute(rstfile[line_num],
					\           '^\.\.\s_\\ \([^\x00-\xff]\)', '.. _\1', 'g')
		" [STRIKEOUT:dd]
		if exists_strikeout || rstfile[line_num] =~ '\[STRIKEOUT:'
			let exists_strikeout = 1
		endif
		let rstfile[line_num] = substitute(rstfile[line_num],
					\           '\[STRIKEOUT:\([^]]\+\)\]', ':temp:`\1`', 'g')
		let rstfile[line_num] = substitute(rstfile[line_num],
					\           '\([^\x00-\xff]\)\(:temp:`[^]]\+`\)', '\1\\ \2', 'g')
		let rstfile[line_num] = substitute(rstfile[line_num],
					\           '\(:temp:`[^]]\+`\)\([^\x00-\xff]\)', '\1\\ \2', 'g')

		let line_num = line_num + 1
	endwhile
	unlet end
	" }}}

	" Add role {{{3
	" XXX must be insert to the head area?
	if exists_strikeout
		call insert(rstfile, '')
		call insert(rstfile, '.. role:: temp')
	endif
	" }}}

	" Add \ to the end of chinese non-break paragraph {{{3
	" XXX Invalid to list 
	let line_num = 0
	while (line_num < len(rstfile) - 1)
		let cur = rstfile[line_num]
		let next = rstfile[line_num + 1]
		" if (cur =~? '^[^ ]\+') && (next =~? '^\([^ ]\&[^.=~^-]\&[^0-9]\)\+')
		if (cur =~? '^[^ ]\+') && (cur =~? '[^\x00-\xff]$') && (next =~? '^[^\x00-\xff]')
			let rstfile[line_num] = cur . '\'
		endif
		let line_num = line_num + 1
	endwhile
	" }}}

	" Change amonition classes to corresponding rst directives {{{3

	" style_dic = {customized_name: rst_name} TODO
	let style_dict = {'note': 'note', 'warning': 'warning', 'rubric': 'rubric'}
	let style_pattern = '<div[^>]\+class="rst-\([^"]\+\)"[^>]\{0,}>'
	let line_num = 2
	while (line_num < len(rstfile) - 4)
		let cur = rstfile[line_num]

		if cur =~ style_pattern
			" Find rst-style block start, class="rst*"
			let block_start = line_num
			let style_class = style_dict[matchlist(cur, style_pattern)[1]]
			
			" Determine if there are another same-raw-html elements
			if rstfile[block_start - 2] =~ '^\.\.\sraw::\shtml'
				let block_start_single = 1
			else
				let block_start_single = 0
			endif

			" Find rst-style end, next </div>
			let line_num_2 = block_start + 2
			while (line_num_2 < len(rstfile))
				let cur = rstfile[line_num_2]
				let next2 = rstfile[line_num_2 + 2]
				if cur =~ '<\/div>'
					let block_end = line_num_2
					break
				else
					let line_num_2 = line_num_2 + 1
				endif
			endwhile

			" Determine if there are another same-raw-html elements
			if rstfile[block_end + 2] !~ '^\s\{3}'
				let block_end_single = 1
			else
				let block_end_single = 0
			endif


			" echo block_start . ' : ' . block_end . ' : ' . block_start_single . ' : ' block_end_single

			" Re-write

			" Re-write block start, if single, remove ..raw:: html
			let rstfile[block_start] = '.. ' . style_class . '::'
			if block_start_single
				call remove(rstfile, block_start - 1)
				call remove(rstfile, block_start - 2)
				let block_start = block_start - 2
				let block_end = block_end - 2
			endif

			" Re-write block body, add 3 blankspaces before
			let line_num_3 = block_start + 2
			while (line_num_3 < block_end - 3)
				if style_class == 'rubric'
					let rstfile[line_num_3 - 2] = rstfile[line_num_3 - 2] . ' ' . rstfile[line_num_3]
					call remove(rstfile, line_num_3)
					call remove(rstfile, line_num_3 - 1)
					let block_end = block_end - 2
					break
				else
					let rstfile[line_num_3] = '   ' . rstfile[line_num_3]
				endif
				let line_num_3 = line_num_3 + 1
			endwhile

			" Re-write block end, if single, remove ..raw:: html
			if block_end_single
				call remove(rstfile, block_end)
				call remove(rstfile, block_end - 1)
				call remove(rstfile, block_end - 2)
				call remove(rstfile, block_end - 3)
				let block_end = block_end - 3
			else
				call remove(rstfile, block_end)
				call remove(rstfile, block_end - 1)
				let block_end = block_end - 1
			endif

			let line_num = block_end
		else
			let line_num = line_num + 1
		endif
	endwhile
	unlet style_dict style_pattern
	" }}}

    call writefile(rstfile, o_fname_raw)
	" }}}

	return o_fname_raw
endfunction
" }}}

" DOCX Config: !(a w f)
"     refer     : p
"     toc       : t
"     clean_\s  : E
"     language  : l @ xell
"     num_sec   : n
"     num_level : v @ xell number by whole artical
"     num_chap  : h @ xell
let g:pandoc_conf_docx = 'pnormal,t,E,lzh,N,V,h'
function! Pandoc_docx_conv(input, config, out_path) " {{{1

	let conf_g = ',' . g:pandoc_conf_general
	let conf_s = ',' . g:pandoc_conf_docx
	let conf_l = a:config == '' ? a:config : ',' . a:config

	let input = s:inputfile(a:input)
	let conf = ' -f markdown -t docx'

	" General config {{{2
	if GetDocsConf(conf_g, conf_l, 'a') ==# 'A'
		let conf .= ' -s'
	endif
	if GetDocsConf(conf_g, conf_l, 'w') ==# 'w'
		let conf .= ' --no-wrap'
	endif
	if GetDocsConf(conf_g, conf_l, 'f') =~? 'f\w'
		let o_fname_suf = matchstr(GetDocsConf(conf_g, conf_l, 'f'), '\cf\zs.*$') . '.'
	else
		let o_fname_suf = ''
	endif
	" }}}

	" Specific config {{{2
	" template p
	let conf_v_tpl = strpart(GetDocsConf(conf_s, conf_l, 'p'), 1) 
	if conf_v_tpl != ''
		let conf_v_tpl = xelltoolkit#fname_escape(g:pandoc_docx_root . g:slash . conf_v_tpl . '.docx')
		let conf .= ' --reference-docx=' . conf_v_tpl
	endif

	" toc t
	if GetDocsConf(conf_s, conf_l, 't') ==# 'T'
		let conf .= ' --toc'
	endif

	" number-sections n
	if GetDocsConf(conf_s, conf_l, 'n') ==# 'N'
		let conf .= ' -N'
	endif
	" }}}

	" Biblio config {{{2
	let conf .= s:pandoc_bib_conf(a:input)
	" }}}

	" Output file {{{2
	if a:out_path == ''
		let o_fname_raw = xelltoolkit#fname_ext_mod(input, o_fname_suf . g:pandoc_target_ext['docx'])
	else
		let o_fname_raw = a:out_path . g:slash . xelltoolkit#fname_name(input) . '.' . o_fname_suf . g:pandoc_target_ext['docx']
	endif
	let o_fname = xelltoolkit#fname_escape(o_fname_raw)
	" }}}

	" Markdown pre-process {{{2
	if GetDocsConf(conf_s, conf_l, 'e') ==# 'E'
		let input = s:mkd_preproc_clean(input, 'tmp.md')
	endif
	if GetDocsConf(conf_s, conf_l, 'n') ==# 'N'
		let input = s:mkd_preproc_numbering(input, 'tmp.md', g:pandoc_conf_docx, a:config)
	else
		let input = s:mkd_preproc_no_numbering(input, 'tmp.md', g:pandoc_conf_docx, a:config)
	endif
	" }}}

	let conf .= ' -o ' . o_fname . ' ' . xelltoolkit#fname_escape(input)

	call xelltoolkit#system(g:pandoc_exec . conf)

	" Delete pre-process file {{{2
	let del_err = delete(input)
	if del_err
		call xelltoolkit#echo_msg('Error while deleting temp file: ' . input)
		return ''
	endif
	" }}}

	return o_fname_raw

endfunction
" }}}

" ODT Config: !(a w f)
"     refer     : p
"     toc       : t
"     clean_\s  : E
"     language  : l @ xell
"     num_sec   : n
"     num_level : v @ xell number by whole artical
"     num_chap  : h @ xell
"     rst?      : s
let g:pandoc_conf_odt = 'pnormal,T,E,lzh,N,v,h,S'
function! Pandoc_odt_conv(input, config, out_path) " {{{1

	let conf_g = ',' . g:pandoc_conf_general
	let conf_s = ',' . g:pandoc_conf_odt
	let conf_l = a:config == '' ? a:config : ',' . a:config

	" For md -> rst -> odt conversion {{{2
	if GetDocsConf(conf_s, conf_l, 's') ==# 'S'
		let conf_l = a:config == '' ? 'M,t' : a:config . ',M,t'
		let rst_temp_file = Pandoc_rst_conv(a:input, conf_l, a:out_path)
		call Rst_odt_conv(rst_temp_file, a:config, a:out_path)
		return
	endif
	" }}}

	let input = s:inputfile(a:input)
	let conf = ' -f markdown -t odt'

	" General config {{{2
	if GetDocsConf(conf_g, conf_l, 'a') ==# 'A'
		let conf .= ' -s'
	endif
	if GetDocsConf(conf_g, conf_l, 'w') ==# 'w'
		let conf .= ' --no-wrap'
	endif
	if GetDocsConf(conf_g, conf_l, 'f') =~? 'f\w'
		let o_fname_suf = matchstr(GetDocsConf(conf_g, conf_l, 'f'), '\cf\zs.*$') . '.'
	else
		let o_fname_suf = ''
	endif
	" }}}

	" Specific config {{{2
	" template p
	let conf_v_tpl = strpart(GetDocsConf(conf_s, conf_l, 'p'), 1) 
	if conf_v_tpl != ''
		let conf_v_tpl = xelltoolkit#fname_escape(g:pandoc_odt_root . g:slash . conf_v_tpl . '.odt')
		let conf .= ' --reference-odt=' . conf_v_tpl
	endif

	" toc t
	if GetDocsConf(conf_s, conf_l, 't') ==# 'T'
		let conf .= ' --toc'
	endif

	" number-sections n
	if GetDocsConf(conf_s, conf_l, 'n') ==# 'N'
		let conf .= ' -N'
	endif
	" }}}

	" Biblio config {{{2
	let conf .= s:pandoc_bib_conf(a:input)
	" }}}

	" Output file {{{2
	if a:out_path == ''
		let o_fname_raw = xelltoolkit#fname_ext_mod(input, o_fname_suf . g:pandoc_target_ext['odt'])
	else
		let o_fname_raw = a:out_path . g:slash . xelltoolkit#fname_name(input) . '.' . o_fname_suf . g:pandoc_target_ext['odt']
	endif
	let o_fname = xelltoolkit#fname_escape(o_fname_raw)
	" }}}

	" Markdown pre-process {{{2
	if GetDocsConf(conf_s, conf_l, 'e') ==# 'E'
		let input = s:mkd_preproc_clean(input, 'tmp.md')
	endif
	if GetDocsConf(conf_s, conf_l, 'n') ==# 'N'
		let input = s:mkd_preproc_numbering(input, 'tmp.md', g:pandoc_conf_odt, a:config)
	else
		let input = s:mkd_preproc_no_numbering(input, 'tmp.md', g:pandoc_conf_odt, a:config)
	endif
	" }}}

	let conf .= ' -o ' . o_fname . ' ' . xelltoolkit#fname_escape(input)

	call xelltoolkit#system(g:pandoc_exec . conf)

	" Delete pre-process file {{{2
	let del_err = delete(input)
	if del_err
		call xelltoolkit#echo_msg('Error while deleting temp file: ' . input)
		return ''
	endif
	" }}}

	return o_fname_raw

endfunction
" }}}

"=================================================================
" Change xell-def cross-refs into texts, etc.
" 标题 [=] 图 [-] 表 [~]

" For md -> html, no numbering
" Change F T links to texts, and S links for hyperlink
function! s:mkd_preproc_no_numbering_html(in, out_fname, config) " {{{1

	" Set language prefix and suffix {{{2
	let conf_s = ',' . g:pandoc_conf_html
	let conf_l = a:config == '' ? a:config : ',' . a:config

	let conf_v_lang = strpart(GetDocsConf(conf_s, conf_l, 'l'), 1)
	" Either zh or en, no other lang support yet
	if conf_v_lang == 'zh'
		let fig_prefix = '图“'
		let fig_suffix = '”'
		let tbl_prefix = '表“'
		let tbl_suffix = '”'
		let sec_prefix = '['
		let sec_suffix = ']'
	else
		let fig_prefix = ' Fig: "'
		let fig_suffix = '"'
		let tbl_prefix = ' Table: "'
		let tbl_suffix = '"'
		let sec_prefix = '['
		let sec_suffix = ']'
	endif
	" }}}

	let out = xelltoolkit#fname_head(a:in) . g:slash . a:out_fname
	let file = readfile(a:in)

	let line_index = 0
	let end_of_file = len(file)
	let link_id_p = '\s'
	while (line_index < end_of_file)
		let cur = file[line_index]

		" Figures {{{2
		if cur =~ '\[-'
			while (1)
				let item = matchlist(cur, '\[-\([^]]\+\)\]', 0)
				if item != []
					let cur = substitute(cur, '\s\?\[-' . item[1] . '\]', fig_prefix . item[1] . fig_suffix, '')
				else
					break
				endif
			endwhile
			let file[line_index] = cur
		endif
		" }}}

		" Tables {{{2
		if cur =~ '\[\~'
			while (1)
				let item = matchlist(cur, '\[\~\([^]]\+\)\]', 0)
				if item != []
					let cur = substitute(cur, '\s\?\[\~' . item[1] . '\]', tbl_prefix . item[1] . tbl_suffix, '')
				else
					break
				endif
			endwhile
			let file[line_index] = cur
		endif
		" }}}

		" Sections {{{2
		if cur =~ '\[='
			while (1)
				let item = matchlist(cur, '\[=\([^]]\+\)\]', 0)
				if item != []
					let item_link = tolower(substitute(item[1], link_id_p, '-', 'g'))
					let cur = substitute(cur, '\s\?\[=' . item[1] . '\]', sec_prefix . item[1] . sec_suffix . '(#' . item_link . ') ', '')
				else
					break
				endif
			endwhile
			let file[line_index] = cur
		endif
		" }}}
		
		let line_index = line_index + 1
	endwhile

	call writefile(file, out)
	return out
endfunction
" }}}

function! s:mkd_preproc_html(in, out_fname) " {{{1
	let out = xelltoolkit#fname_head(a:in) . g:slash . a:out_fname
	let file = readfile(a:in)

	let line_index = 0
	let end_of_file = len(file)
	while (line_index < end_of_file)
		let cur = file[line_index]

		if cur =~? '\~\~\([^~]\+\)\~\~'
			while (1)
				let item = matchlist(cur, '\~\~\([^~]\+\)\~\~', 0)
				if item != []
					let cur = substitute(cur, '\~\~\([^~]\+\)\~\~', '<span style="background-color: orange;">' . item[1] . '</span>', '')
				else
					break
				endif
			endwhile
			let file[line_index] = cur
		endif

		let line_index = line_index + 1
	endwhile

	call writefile(file, out)
	return out
endfunction
" }}}

" For md -> all, no numbering
" Change F T S links to texts
function! s:mkd_preproc_no_numbering(in, out_fname, config_s, config_l) " {{{1 

	" Set language prefix and suffix {{{2
	let conf_s = ',' . a:config_s
	let conf_l = a:config_l == '' ? a:config_l : ',' . a:config_l

	let conf_v_lang = strpart(GetDocsConf(conf_s, conf_l, 'l'), 1)
	" Either zh or en, no other lang support yet
	if conf_v_lang == 'zh'
		let fig_prefix = '图“'
		let fig_suffix = '”'
		let tbl_prefix = '表“'
		let tbl_suffix = '”'
		let sec_prefix = '本文“'
		let sec_suffix = '”'
	else
		let fig_prefix = ' Figure "'
		let fig_suffix = '"'
		let tbl_prefix = ' Table "'
		let tbl_suffix = '"'
		let sec_prefix = ' "'
		let sec_suffix = '"'
	endif
	" }}}

	let out = xelltoolkit#fname_head(a:in) . g:slash . a:out_fname
	let file = readfile(a:in)

	let line_index = 0
	let end_of_file = len(file)
	while (line_index < end_of_file)
		let cur = file[line_index]

		" Figures {{{2
		if cur =~ '\[-'
			while (1)
				let item = matchlist(cur, '\[-\([^]]\+\)\]', 0)
				if item != []
					let cur = substitute(cur, '\s\?\[-' . item[1] . '\]', fig_prefix . item[1] . fig_suffix, '')
				else
					break
				endif
			endwhile
			let file[line_index] = cur
		endif
		" }}}

		" Tables {{{2
		if cur =~ '\[\~'
			while (1)
				let item = matchlist(cur, '\[\~\([^]]\+\)\]', 0)
				if item != []
					let cur = substitute(cur, '\s\?\[\~' . item[1] . '\]', tbl_prefix . item[1] . tbl_suffix, '')
				else
					break
				endif
			endwhile
			let file[line_index] = cur
		endif
		" }}}

		" Sections {{{2
		if cur =~ '\[='
			while (1)
				let item = matchlist(cur, '\[=\([^]]\+\)\]', 0)
				if item != []
					let cur = substitute(cur, '\s\?\[=' . item[1] . '\]', sec_prefix . item[1] . sec_suffix, '')
				else
					break
				endif
			endwhile
			let file[line_index] = cur
		endif
		" }}}
		
		let line_index = line_index + 1
	endwhile

	call writefile(file, out)
	return out
endfunction
" }}}

" For md -> all, numbering
function! s:mkd_preproc_numbering(in, out_fname, config_s, config_l) " {{{1

	" Set language prefix and suffix {{{2
	let conf_s = ',' . a:config_s
	let conf_l = a:config_l == '' ? a:config_l : ',' . a:config_l

	let conf_v_lang = strpart(GetDocsConf(conf_s, conf_l, 'l'), 1)
	" Either zh or en, no other lang support yet
	if conf_v_lang == 'zh'
		let fig_prefix = '图 '
		let tbl_prefix = '表 '
		let sec_prefix = '第'
		let sec_suffix = '节'
		let chp_prefix = '第'
		let chp_suffix = '章'
	else
		let fig_prefix = 'Figure '
		let tbl_prefix = 'Table '
		let sec_prefix = 'Section '
		let sec_suffix = ''
		let chp_prefix = 'Chapter '
		let chp_suffix = ''
	endif
	" }}}

	" Set numbering options {{{2
	if GetDocsConf(conf_s, conf_l, 'v') ==# 'V'
		let is_numbering_whole = 1
	else
		let is_numbering_whole = 0
	endif

	if GetDocsConf(conf_s, conf_l, 'h') ==# 'H'
		let is_numbering_chapter = 1
	else
		let is_numbering_chapter = 0
	endif
	" }}}

	let out = xelltoolkit#fname_head(a:in) . g:slash . a:out_fname
	let mkdfile = readfile(a:in)

	let level_list = []
	let toplevel_list = []

	" Translate date {{{2
	let line_index = 0
	let end_of_file = len(mkdfile) < 6 ? len(mkdfile) : 6
	while (line_index < end_of_file)
		let cur = mkdfile[line_index]
		if cur =~ '^%\s\?%date'
			let mkdfile[line_index] = '%' . strftime("%Y-%m-%d")
			break
		endif
		let line_index = line_index + 1
	endwhile
	unlet line_index end_of_file
	" }}}

	" Generate level list and toplevel list {{{2
	" level_list: [[level_num, line_num, title], ...]
	" toplevel_list: [[level_num, line_num], ...]
	let line_index = 0
	let end_of_file = len(mkdfile)
	while (line_index < end_of_file)
		let cur = mkdfile[line_index]

		if cur =~ '^#\+'
			let level = stridx(cur, ' ', 0)
			call add(level_list, [level, line_index, 
						\ substitute(strpart(cur, stridx(cur, ' ', 0) + 1), '\s*$', '', '')])
			if level == 1
				call add(toplevel_list, [level, line_index])
			endif
		endif

		let line_index = line_index + 1
	endwhile
	" let @+ = string(level_list)
	" echo toplevel_list
	if toplevel_list == []
		" there is no need to process forward
		call writefile(mkdfile, out)
		call xelltoolkit#echo_msg("There is no level! Nubmering process stops.")
		return out
	endif
	" }}}
	
	" Numbering figures and tables {{{2
	let line_index = 0
	let end_of_file = len(mkdfile)
	" Dict format: {'title': 'number'}
	let fig_dic = {}
	let tbl_dic = {}

	if is_numbering_whole
		" numbering by whole {{{3
		let fig_index = 1
		let tbl_index = 1
		while (line_index < end_of_file)
			let cur = mkdfile[line_index]
			" figure
			if cur =~ '^\s*!\['
				let fig_title = matchstr(cur, '^\s*!\[\zs.\+\ze\]')
				if has_key(fig_dic, fig_title)
					call writefile(mkdfile, out)
					call xelltoolkit#echo_msg("Duplicated figure title! Process stops!")
					return out
				endif
				let fig_dic[fig_title] = fig_prefix . fig_index
				let title = substitute(cur, '!\[.\+\]', '![' . fig_dic[fig_title] . ' ' . fig_title . ']', '')
				let mkdfile[line_index] = title
				let fig_index = fig_index + 1
			endif
			" table
			if cur =~ '^Table:\s'
				let tbl_title = matchstr(cur, '^Table:\s\zs.*\ze$')
				if has_key(tbl_dic, tbl_title)
					call writefile(mkdfile, out)
					call xelltoolkit#echo_msg("Duplicated figure title! Process stops!")
					return out
				endif
				let tbl_dic[tbl_title] = tbl_prefix . tbl_index
				let title = 'Table: ' . tbl_dic[tbl_title] . ' ' . tbl_title
				let mkdfile[line_index] = title
				let tbl_index = tbl_index + 1
			endif

			let line_index = line_index + 1
		endwhile
		" }}}
	else
		" numbering by toplevel {{{3
		let fig_toplevel_dic = {}
		let tbl_toplevel_dic = {}
		while (line_index < end_of_file)
			let cur = mkdfile[line_index]
			let chapter_index = s:determine_toplevel(toplevel_list, line_index)
			" figure
			if cur =~ '^\s*!\['
				let fig_title = matchstr(cur, '^\s*!\[\zs.\+\ze\]')
				if has_key(fig_dic, fig_title)
					call writefile(mkdfile, out)
					call xelltoolkit#echo_msg("Duplicated figure title! Process stops!")
					return out
				endif
				if has_key(fig_toplevel_dic, chapter_index)
					let fig_index = fig_index + 1
				else
					let fig_toplevel_dic[chapter_index] = 1
					let fig_index = 1
				endif
				let fig_dic[fig_title] = fig_prefix . chapter_index . '-' . fig_index
				let title = substitute(cur, '!\[.\+\]', '![' . fig_dic[fig_title] . ' ' . fig_title . ']', '')
				let mkdfile[line_index] = title
			endif
			" table
			if cur =~ '^Table:\s'
				let tbl_title = matchstr(cur, '^Table:\s\zs.*\ze$')
				if has_key(tbl_dic, tbl_title)
					call writefile(mkdfile, out)
					call xelltoolkit#echo_msg("Duplicated figure title! Process stops!")
					return out
				endif
			if has_key(tbl_toplevel_dic, chapter_index)
				let tbl_index = tbl_index + 1
			else
				let tbl_toplevel_dic[chapter_index] = 1
				let tbl_index = 1
			endif
				let tbl_dic[tbl_title] = tbl_prefix . chapter_index . '-' . tbl_index
				let title = 'Table: ' . tbl_dic[tbl_title] . ' ' . tbl_title
				let mkdfile[line_index] = title
			endif

			let line_index = line_index + 1
		endwhile
		" }}}
	endif
	" }}}

	" Substitute [- and [~ by fig_dic and tbl_dic {{{2
	let line_index = 0
	let end_of_file = len(mkdfile)
	while (line_index < end_of_file)

		" figures
		let cur = mkdfile[line_index]
		if cur =~ '\[-'
			while (1)
				let item = matchlist(cur, '\[-\([^]]\+\)\]', 0)
				if item != []
					if has_key(fig_dic, item[1])
						let cur = substitute(cur, '\[-' . item[1] . '\]', fig_dic[item[1]], '')
					else
						call writefile(mkdfile, out)
						call xelltoolkit#echo_msg("Wrong figure linktext in line " . (line_index + 1))
						call xelltoolkit#echo_msg("Process stops!")
						return out
					endif
				else
					break
				endif
			endwhile
			let mkdfile[line_index] = cur
		endif

		" tables
		let cur = mkdfile[line_index]
		if cur =~ '\[\~'
			while (1)
				let item = matchlist(cur, '\[\~\([^]]\+\)\]', 0)
				if item != []
					if has_key(tbl_dic, item[1])
						let cur = substitute(cur, '\[\~' . item[1] . '\]', tbl_dic[item[1]], '')
					else
						call writefile(mkdfile, out)
						call xelltoolkit#echo_msg("Wrong table linktext in line " . (line_index + 1))
						call xelltoolkit#echo_msg("Process stops!")
						return out
					endif
				else
					break
				endif
			endwhile
			let mkdfile[line_index] = cur
		endif

		let line_index = line_index + 1
	endwhile

	" }}}

	" Substitute [= by level_list {{{2
	let line_index = 0
	let end_of_file = len(mkdfile)
	while (line_index < end_of_file)
		let cur = mkdfile[line_index]
		if cur =~ '\[='
			while (1)
				let item = matchlist(cur, '\[=\([^]]\+\)\]', 0)
				if item != []
					let title_level = s:determine_level(level_list, item[1])
					if title_level == -1
						call writefile(mkdfile, out)
						call xelltoolkit#echo_msg("Title: " . item[1])
						call xelltoolkit#echo_msg("Wrong chapter or section title linktext in line " . (line_index + 1))
						call xelltoolkit#echo_msg("numbering Process stops!")
						return out
					else
						if len(title_level) == 1 && is_numbering_chapter
							let title_level = chp_prefix . title_level . chp_suffix
						else
							let title_level = sec_prefix . title_level . sec_suffix
						endif
						let cur = substitute(cur, '\[=' . item[1] . '\]', title_level, '')
					endif
				else
					break
				endif
			endwhile
			let mkdfile[line_index] = cur
		endif
		let line_index = line_index + 1
	endwhile
	" }}}

	call writefile(mkdfile, out)
	return out

endfunction
" }}}

" For md -> docx, odt, etc. cleaning the blank between zh and en
function! s:mkd_preproc_clean(in, out_fname) " {{{1
	let out = xelltoolkit#fname_head(a:in) . g:slash . a:out_fname
	let file = readfile(a:in)

	let line_index = 0
	let end_of_file = len(file)
	while (line_index < end_of_file)
		let cur = file[line_index]

		let cur = substitute(cur, '[^\x00-\xff]\zs\s\ze\%(\w\|\[\|\]\)', '', 'g')
		let cur = substitute(cur, '\%(\w\|\[\|\]\)\zs\s\ze[^\x00-\xff]', '', 'g')

		let file[line_index] = cur

		let line_index = line_index + 1
	endwhile

	call writefile(file, out)
	return out
endfunction
" }}}

"=================================================================
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

" 给定行号，返回第几章 {{{2
" toplevel_list: [[level_num, line_num], ...]
function! s:determine_toplevel(toplevel_list, linenum)
	let tmp_list = []
	let level = 0
	for item in a:toplevel_list
		if a:linenum >= item[1]
			let level = level + 1
			call add(tmp_list, level)
		endif
	endfor
	return max(tmp_list)
endfunction
" }}}

" 给定章节标题，返回处理后的章节号 {{{2
" level_list: [[level_num, line_num, title], ...]
" [[1, 15, '应当是第一章或节'], [2, 19, '应当是一一'], [2, 25, '应当是一二'], [1, 29, 'Should be II'], [1, 42, '应当是第三章或节'], [2, 46, '应当是三一'], [3, 50, 'Should be 3.1.1']]
function! s:determine_level(level_list, title)
	let level_num_list = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	for item in a:level_list
		let num = item[0]
		let level_num_list[num - 1] += 1
		let level_num_list[num] = 0
		if item[2] == a:title
			break
		endif
	endfor

	let text = ''
	let suffix = '.'
	for i in level_num_list
		if i == 0
			break
		else
			let text = text . i . suffix
		endif
	endfor
	return text == '' ? -1 : strpart(text, 0, len(text) - 1)

endfunction
" }}}

" }}}

