
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
"     language  : l @ xell @ rst
let g:pandoc_conf_other = 'T,R,lzh'
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

	" Markdown pre-process {{{2
	let input = s:mkd_preproc_no_numbering(input, 'tmp.md', a:config)
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

	return o_fname

endfunction
" }}}


" HTML Config: !(a w f) {{{1
"     template  : p
"     toc       : t
"     language  : l @ xell @ rst
"     css       : c : implies '--self-contained'
"     num_sec   : n
"     self_cont : z
"     num_level : v @ xell number by whole artical
"     num_chap  : h @ xell
"     rst?      : s
"     slide_inc : i
" }}}
let g:pandoc_conf_html = 'p,T,lzh,cnormal,N,z,f,V,h,s,I'
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

	" Markdown pre-process {{{2
	if GetDocsConf(conf_s, conf_l, 'n') ==# 'N'
		let input = s:mkd_preproc_numbering(input, 'tmp.md', a:config)
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

	return o_fname
endfunction
" }}}

function! Pandoc_rst_conv(input, out_type, config) " {{{1
	echo 'Placeholder'
endfunction
" }}}

"=================================================================
" Change xell-def cross-refs into texts
" 标题 [=] 图 [-] 表 [~]

" For other targets, no numbering, basic conversion
function! s:mkd_preproc_no_numbering(in, out_fname, config) " {{{1 

	" Set language prefix and suffix {{{2
	let conf_s = ',' . g:pandoc_conf_other
	let conf_l = a:config == '' ? a:config : ',' . a:config

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
		let fig_prefix = ' Fig: "'
		let fig_suffix = '"'
		let tbl_prefix = ' Table: "'
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

" For md -> html with n, no numbering, change section links
function! s:mkd_preproc_no_numbering_html(in, out_fname, config) " {{{1

	" Set language prefix and suffix {{{2
	let conf_s = ',' . g:pandoc_conf_other
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

" For md -> all, numbering
function! s:mkd_preproc_numbering(in, out_fname, config) " {{{1

	" Set language prefix and suffix {{{2
	let conf_s = ',' . g:pandoc_conf_other
	let conf_l = a:config == '' ? a:config : ',' . a:config

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
		if cur =~ '^%\s?%date'
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

