" Author:   Xell Liu <xell DOT liu AT gmail.com>
" License:  Same terms as Vim itself (see :help license).
"

" Pre {{{1
if exists("g:loaded_pandoc_converter") || v:version < 700
  finish
endif
let g:loaded_pandoc_converter = 1

let s:savecpo = &cpo
set cpo&vim
" }}}

command! -nargs=* Pandoc :call PandocConverterBuffer(<f-args>)
nmap <Leader>/ :Pandoc<CR>
let g:target_profile_default = 'normal.html'
let g:pandoc_bib_default = 'biblio.bib'
let g:pandoc_config_file = '/Users/xell/.pandoc/pdconfig'
let g:pandocconverter_scope = ['pandoc', 'markdown']

function! PandocConverterBuffer(...) "{{{1
    let input_type = &ft

    " check if it's supported
    if match(g:pandocconverter_scope, input_type) == -1
        call xelltoolkit#echo_msg("Pandoc doesn't support this filetype!")
        return
    endif
    " determine the profile
    if a:0 == 0
        let target_profile = g:target_profile_default
        let file_content = readfile(expand('%:p'))
        for line_content in file_content
            if line_content =~# '<!--\sPandoc:[^ ]\+\s-->'
                echo "Read profile from current file."
                let target_profile = matchstr(line_content, '<!--\sPandoc:\zs[^ ]\+\ze\s-->')
                break
            endif
        endfor
        unlet file_content
    elseif a:0 == 1
        let target_profile = a:1
    else
        call xelltoolkit#echo_msg("Too many args!")
        return
    endif

    let [outputfile_fullpath, target_profile] = PandocConverter(expand('%:p'), target_profile)
    if outputfile_fullpath == -1
        call xelltoolkit#echo_msg("Wrong profile and/or config!")
        return
    elseif outputfile_fullpath == -2
        call xelltoolkit#echo_msg("Cannot delete middle file.")
        return
    else
        echo "Generated [" . xelltoolkit#fname_name(target_profile) . '] ' . xelltoolkit#fname_name(outputfile_fullpath) . '.' . xelltoolkit#fname_ext(outputfile_fullpath)
    endif
endfunction "}}}

" Given input filename full path and profile name, generate output file
" Return the full path of the generated file
function! PandocConverter(inputfile_fullpath, target_profile) " {{{1
    let inputfile_head = xelltoolkit#fname_head(a:inputfile_fullpath)
    let inputfile_name = xelltoolkit#fname_name(a:inputfile_fullpath)
    let inputfile_ext = xelltoolkit#fname_ext(a:inputfile_fullpath)
    let pandoc_middlefile_fname = inputfile_head. '/tmp.' . inputfile_ext

    " read the profile {{{
    let [pandoc_options, pandoc_target_ext, pandoc_customized_options] = s:read_profile(a:target_profile)
    if pandoc_options == -1 || pandoc_options == ''
        return -1
    endif
    let pandoc_customized_options_flags = split(pandoc_customized_options, '\zs')
    " language 1->zh 0->en
    if pandoc_customized_options_flags[0] == '1'
        let pandoc_cusomized_language = 1
    else
        let pandoc_cusomized_language = 0
    endif
    " is to number the figures and tables
    if pandoc_customized_options_flags[1] == '1'
        let pandoc_customized_number = 1
    else
        let pandoc_customized_number = 0
    endif
    " is number sequence whole x or x-y by chapter/section
    if pandoc_customized_options_flags[2] == '1'
        let pandoc_customized_whole = 1
    else
        let pandoc_customized_whole = 0
    endif
    " is fist level chpater
    if pandoc_customized_options_flags[3] == '1'
        let pandoc_customized_chapter = 1
    else
        let pandoc_customized_chapter = 0
    endif
    " {...} -> ~~{...}~~
    if pandoc_customized_options_flags[4] == '1'
        let pandoc_customized_tag = 1
    else
        let pandoc_customized_tag = 0
    endif

    " echo pandoc_cusomized_language . "." . pandoc_customized_whole . "." . pandoc_customized_chapter . "." . pandoc_customized_tag
    " }}}

    " preprocess file {{{

    let file_content = readfile(a:inputfile_fullpath)
    " process customized tag(s)
    if pandoc_customized_tag
        if pandoc_target_ext =~? 'tex'
            let file_content = s:preproc_customized_tag_tex(file_content)
        else
            let file_content = s:preproc_customized_tag_html_docx(file_content)
        endif
    endif
    " process spaces between en and zh for docx and tex
    if pandoc_target_ext =~? 'docx' || pandoc_target_ext =~? 'tex'
        let file_content = s:preproc_clean_spaces(file_content)
    endif
    " process customized references
    if pandoc_customized_number
        let file_content = s:preproc_numbering(file_content, pandoc_cusomized_language, pandoc_customized_whole, pandoc_customized_chapter)
    else 
        let file_content = s:preproc_no_numbering(file_content, pandoc_cusomized_language)
    endif
    " }}}

    " bibliography {{{
    let biblio = inputfile_head . '/' . g:pandoc_bib_default
    if filereadable(biblio)
        let pandoc_options .= ' --biblio "' . biblio . '" '
    endif
    " }}}

    " prepare output folder {{{
    if inputfile_head =~? xelltoolkit#fname2pattern(g:xell_notes_root)
        let outputfile_fullpath = g:xell_notes_ex_root . '/' . inputfile_name . '.' . pandoc_target_ext
    else
        let outputfile_fullpath = inputfile_head . '/' . inputfile_name . '.' . pandoc_target_ext
    endif
    " }}}

    call writefile(file_content, pandoc_middlefile_fname)
    let cmd = 'pandoc ' . pandoc_options . '-o "' . outputfile_fullpath . '" "' . pandoc_middlefile_fname . '"'
    call xelltoolkit#system(cmd)
    if delete(pandoc_middlefile_fname) != 0
        return -2
    endif
    return [outputfile_fullpath, a:target_profile]
endfunction "}}}

"=================================================================
" Preprocess customized tag
function! s:preproc_customized_tag_html_docx(file_content) " {{{1
    let file_content = a:file_content
	let line_index = 0
	let end_of_file = len(file_content)
	while (line_index < end_of_file)
		let cur = file_content[line_index]

        " {=...} -> ~~{...}~~
		if cur =~? '{=\([^=][^}]\{-}\)}'
            let cur = substitute(cur, '{=\([^=][^}]\{-}\)}', '\~\~{\1}\~\~', 'g')
			let file_content[line_index] = cur
        endif
		" if cur =~? '{\([^}]\+\)}'
		" 	while (1)
		" 		let item = matchlist(cur, '{\([^}]\+\)}', 0)
		" 		if item != []
		" 			let cur = substitute(cur, '{\([^}]\+\)}', '\~\~' . item[0] . '\~\~', '')
		" 		else
		" 			break
		" 		endif
		" 	endwhile
		" 	let file_content[line_index] = cur
		" endif

		let line_index = line_index + 1
	endwhile

	return file_content
endfunction
" }}}
function! s:preproc_customized_tag_tex(file_content) " {{{1
    let file_content = a:file_content
	let line_index = 0
	let end_of_file = len(file_content)
	while (line_index < end_of_file)
		let cur = file_content[line_index]

        " {=...} -> \temp{\{...\}}
		if cur =~? '{[^}]\+}'
            let cur = substitute(cur, '{=\([^=][^}]\{-}\)}', '\\temp{\\{\1\\}}', 'g')
        endif
        " ~~...~~ -> \temp{...}
        if cur =~? '\~\~\([^~]\+\)\~\~'
            let cur = substitute(cur, '\~\~\([^~]\+\)\~\~', '\\temp{\1}', 'g')
        endif

        let file_content[line_index] = cur
		let line_index = line_index + 1
	endwhile

	return file_content
endfunction
" }}}

" Cleaning the blank between zh and en for docx
function! s:preproc_clean_spaces(file_content) " {{{1
" 处理中英文之间的空格，对应 docx 输出，因为这些软件可以自动调整字符间距
    let file_content = a:file_content

	let line_index = 0
	let end_of_file = len(file_content)
	while (line_index < end_of_file)
		let cur = file_content[line_index]

		let cur = substitute(cur, '[^\x00-\xff]\zs\s\ze\%(\w\|\[\|\]\|\$\|`\|\.\)', '', 'g')
		let cur = substitute(cur, '\%(\w\|\[\|\]\|\$\|`\|\.\)\zs\s\ze[^\x00-\xff]', '', 'g')

		let file_content[line_index] = cur

		let line_index = line_index + 1
	endwhile

	return file_content
endfunction
" }}}

" Change xell-def cross-refs into texts, etc.
" 标题 [=] 图 [-] 表 [~]
" Preprocess figures, tables and title references by language
" For -N --number-sections
function! s:preproc_numbering(file_content, language, is_whole, is_chapter) "{{{

    let file_content = a:file_content
    let is_whole = a:is_whole

    " language definition {{{2
	if a:language
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

	let level_list = []
	let toplevel_list = []

	" Translate date {{{2
	let line_index = 0
	let end_of_file = len(file_content) < 6 ? len(file_content) : 6
	while (line_index < end_of_file)
		let cur = file_content[line_index]
		if cur =~ '\s\?%date'
            if a:language
                let file_content[line_index] = '%' . strftime("%Y-%m-%d")
            elseif
                let file_content[line_index] = '%' . strftime("%m/%d/%Y")
            endif
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
	let end_of_file = len(file_content)
	while (line_index < end_of_file)
		let cur = file_content[line_index]

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
        " fake the toplevel to process
        " i.e. treat the whole article as the content of a top level
        let toplevel_list = [[1,1]]
	endif
    " force use is_whole because there is only one top level
    if len(toplevel_list) == 1
        let is_whole = 1
    endif
	" }}}
	
	" Numbering figures and tables {{{2
	let line_index = 0
	let end_of_file = len(file_content)
	" Dict format: {'title': 'number'}
	let fig_dic = {}
	let tbl_dic = {}

	if is_whole
		" numbering by whole {{{3
		let fig_index = 1
		let tbl_index = 1
		while (line_index < end_of_file)
			let cur = file_content[line_index]
			" figure
			if cur =~ '^\s*!\['
				let fig_title = matchstr(cur, '^\s*!\[\zs.\+\ze\]')
				if has_key(fig_dic, fig_title)
					call xelltoolkit#echo_msg("Duplicated figure title! Preprocess stopped")
					return file_content
				endif
				let fig_dic[fig_title] = fig_prefix . fig_index
				let title = substitute(cur, '!\[.\+\]', '![' . fig_dic[fig_title] . ' ' . fig_title . ']', '')
				let file_content[line_index] = title
				let fig_index = fig_index + 1
			endif
			" table
			if cur =~ '^Table:\s'
				let tbl_title = matchstr(cur, '^Table:\s\zs.*\ze$')
				if has_key(tbl_dic, tbl_title)
					call xelltoolkit#echo_msg("Duplicated table title! Preprocess stopped")
					return file_content
				endif
				let tbl_dic[tbl_title] = tbl_prefix . tbl_index
				let title = 'Table: ' . tbl_dic[tbl_title] . ' ' . tbl_title
				let file_content[line_index] = title
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
			let cur = file_content[line_index]
			let chapter_index = s:determine_toplevel(toplevel_list, line_index)
			" figure
			if cur =~ '^\s*!\['
				let fig_title = matchstr(cur, '^\s*!\[\zs.\+\ze\]')
				if has_key(fig_dic, fig_title)
					call xelltoolkit#echo_msg("Duplicated figure title! Preprocess stopped")
					return file_content
				endif
				if has_key(fig_toplevel_dic, chapter_index)
					let fig_index = fig_index + 1
				else
					let fig_toplevel_dic[chapter_index] = 1
					let fig_index = 1
				endif
				let fig_dic[fig_title] = fig_prefix . chapter_index . '-' . fig_index
				let title = substitute(cur, '!\[.\+\]', '![' . fig_dic[fig_title] . ' ' . fig_title . ']', '')
				let file_content[line_index] = title
			endif
			" table
			if cur =~ '^Table:\s'
				let tbl_title = matchstr(cur, '^Table:\s\zs.*\ze$')
				if has_key(tbl_dic, tbl_title)
					call xelltoolkit#echo_msg("Duplicated table title! Preprocess stopped")
					return file_content
				endif
			if has_key(tbl_toplevel_dic, chapter_index)
				let tbl_index = tbl_index + 1
			else
				let tbl_toplevel_dic[chapter_index] = 1
				let tbl_index = 1
			endif
				let tbl_dic[tbl_title] = tbl_prefix . chapter_index . '-' . tbl_index
				let title = 'Table: ' . tbl_dic[tbl_title] . ' ' . tbl_title
				let file_content[line_index] = title
			endif

			let line_index = line_index + 1
		endwhile
		" }}}
	endif
	" }}}

	" Substitute [- and [~ by fig_dic and tbl_dic {{{2
	let line_index = 0
	let end_of_file = len(file_content)
	while (line_index < end_of_file)

		" figures
		let cur = file_content[line_index]
		if cur =~ '\[-'
			while (1)
				let item = matchlist(cur, '\[-\([^]]\+\)\]', 0)
				if item != []
					if has_key(fig_dic, item[1])
						let cur = substitute(cur, '\[-' . item[1] . '\]', fig_dic[item[1]], '')
					else
						call xelltoolkit#echo_msg("Wrong figure linktext in line " . (line_index + 1))
						call xelltoolkit#echo_msg("Preprocess stopped")
						return file_content
					endif
				else
					break
				endif
			endwhile
			let file_content[line_index] = cur
		endif

		" tables
		let cur = file_content[line_index]
		if cur =~ '\[\~'
			while (1)
				let item = matchlist(cur, '\[\~\([^]]\+\)\]', 0)
				if item != []
					if has_key(tbl_dic, item[1])
						let cur = substitute(cur, '\[\~' . item[1] . '\]', tbl_dic[item[1]], '')
					else
						call xelltoolkit#echo_msg("Wrong table linktext in line " . (line_index + 1))
						call xelltoolkit#echo_msg("Preprocess stopped")
						return file_content
					endif
				else
					break
				endif
			endwhile
			let file_content[line_index] = cur
		endif

		let line_index = line_index + 1
	endwhile

	" }}}

	" Substitute [= by level_list {{{2
	let line_index = 0
	let end_of_file = len(file_content)
	while (line_index < end_of_file)
		let cur = file_content[line_index]
		if cur =~ '\[='
			while (1)
				let item = matchlist(cur, '\[=\([^]]\+\)\]', 0)
				if item != []
					let title_level = s:determine_level(level_list, item[1])
					if title_level == -1
						call xelltoolkit#echo_msg("Title: " . item[1])
						call xelltoolkit#echo_msg("Wrong chapter or section title linktext in line " . (line_index + 1))
						call xelltoolkit#echo_msg("Preprocess stopped")
						return file_content
					else
						if len(title_level) == 1 && a:is_chapter
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
			let file_content[line_index] = cur
		endif
		let line_index = line_index + 1
	endwhile
	" }}}

	return file_content

endfunction

" }}}
" For no -N --number-sections
function! s:preproc_no_numbering(file_content, language) "{{{

    let file_content = a:file_content

    " language definition {{{2
	if a:language
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

	" Translate date {{{2
	let line_index = 0
	let end_of_file = len(file_content) < 6 ? len(file_content) : 6
	while (line_index < end_of_file)
		let cur = file_content[line_index]
		if cur =~ '\s\?%date'
            if a:language
                let file_content[line_index] = '%' . strftime("%Y-%m-%d")
            elseif
                let file_content[line_index] = '%' . strftime("%m/%d/%Y")
            endif
			break
		endif
		let line_index = line_index + 1
	endwhile
	unlet line_index end_of_file
	" }}}

	let line_index = 0
	let end_of_file = len(file_content)
	while (line_index < end_of_file)
		let cur = file_content[line_index]

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
			let file_content[line_index] = cur
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
			let file_content[line_index] = cur
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
			let file_content[line_index] = cur
		endif
		" }}}
		
		let line_index = line_index + 1
	endwhile

	return file_content
endfunction
" }}}

" Read profile
function! s:read_profile(profile) "{{{
    let pandoc_config = readfile(g:pandoc_config_file)

    let pandoc_options = ''
    let pandoc_target_ext = ''
    let pandoc_customized_options = ''

    " check if there's the profile AND the ext 0000
    let profile_linenum = match(pandoc_config, '^\[' . a:profile . '\][01]\{5}')
    if profile_linenum == -1
        return [-1, -1, -1]
    endif

    let pandoc_target_ext = matchstr(pandoc_config[profile_linenum], '\.\zs[^ ]\+\ze\]')
    let pandoc_customized_options = matchstr(pandoc_config[profile_linenum], '\]\zs[01]\{5}\ze$')
	let end = len(pandoc_config)
    let line_num = profile_linenum + 1
    while(line_num < end)
        let line_content = pandoc_config[line_num]
        if line_content =~? '^\['
            break
        endif
        if line_content =~? '^#' || line_content =~? '^[:blank:]*$'
            let line_num = line_num + 1
            continue
        endif
        let pandoc_options .= line_content . ' '
        let line_num = line_num + 1
    endwhile

    return [pandoc_options, pandoc_target_ext, pandoc_customized_options]
endfunction
" }}}

" 给定行号，返回第几章
function! s:determine_toplevel(toplevel_list, linenum) "{{{
" toplevel_list: [[level_num, line_num], ...]
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

" 给定章节标题，返回处理后的章节号
function! s:determine_level(level_list, title) "{{{
" level_list: [[level_num, line_num, title], ...]
" [[1, 15, '应当是第一章或节'], [2, 19, '应当是一一'], [2, 25, '应当是一二'], [1, 29, 'Should be II'], [1, 42, '应当是第三章或节'], [2, 46, '应当是三一'], [3, 50, 'Should be 3.1.1']]
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

" End {{{1
let &cpo = s:savecpo
unlet s:savecpo
" vim:fdm=marker
" }}}
