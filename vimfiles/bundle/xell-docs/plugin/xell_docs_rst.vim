
function! RstConverter(input, out_type, config, out_path)
	if a:out_type =~? '\(html\|odt\)'
		call Rst_{a:out_type}_conv(a:input, a:config, a:out_path)
	else
		call xelltoolkit#echo_msg('Target unsupported.')
		return
	endif
endfunction

function! Rst_html_conv(input, config, out_path)
	echo "Place holder."
endfunction

" TODO odt configuration
" {{{1
function! Rst_odt_conv(input, config, out_path)
	let input = s:inputfile(a:input)

	" Determine if it's middle {{{2
	let input_name = xelltoolkit#fname_name(input)
	if input_name =~? '\.middle$'
		let middle_files = [input]
		let input_name = substitute(input_name, '\.middle$', '', '')
	else
		let middle_files = []
	endif
	" }}}

	" Output file {{{2
	let input_head = xelltoolkit#fname_head(input)
	if a:out_path == ''
		let o_fname_raw = input_head . g:slash . input_name . '.odt'
	else
		let o_fname_raw = a:out_path . g:slash . input_name . '.odt'
	endif
	let o_fname = xelltoolkit#fname_escape(o_fname_raw)
	" }}}

	" Additional pre-process {{{2

	let temp_rst_name = input_head . g:slash . input_name . '.tmp.rst'
	call add(middle_files, temp_rst_name)
	let temp_rst = readfile(input)

	" Delete space in * ` _ [ {{{3
	let line_num = 0
	let end = len(temp_rst)
	while (line_num < end)
		" chinese word chinese
		let temp_rst[line_num] = substitute(temp_rst[line_num],
					\           '\([^\x00-\xff]\)\s\([0-9A-Za-z]\)', '\1\2', 'g')
		let temp_rst[line_num] = substitute(temp_rst[line_num],
					\           '\([0-9A-Za-z]\)\s\([^\x00-\xff]\)', '\1\2', 'g')
		" chinese `word`_ chinese
		let temp_rst[line_num] = substitute(temp_rst[line_num],
					\           '\([^\x00-\xff]\)\s\([`][^`]\{-}[`]_\)', '\1\\ \2', 'g')
		let temp_rst[line_num] = substitute(temp_rst[line_num],
					\           '\([`][^`]\{-}[`]_\)\s\([^\x00-\xff]\)', '\1\\ \2', 'g')
		" chinese [word] chinese
		let temp_rst[line_num] = substitute(temp_rst[line_num],
					\           '\([^\x00-\xff]\)\s\(\[\)', '\1\\ \2', 'g')
		let temp_rst[line_num] = substitute(temp_rst[line_num],
					\           '\(\]\)\s\([^\x00-\xff]\)', '\1\\ \2', 'g')

		let line_num = line_num + 1
	endwhile
	unlet end
	" }}}

	call writefile(temp_rst, temp_rst_name)

	" }}}
	
	let conf = ' --language=zh_CN --create-links --no-sections --stylesheet=' . g:rst_odt_style_root . g:slash . 'normal.odt' . ' --custom-odt-footer="%p%"'
	let cmd = g:rst2odt_exec . conf . ' ' . xelltoolkit#fname_escape(temp_rst_name) . ' ' . o_fname

	call xelltoolkit#system(cmd)

	call s:delete_middle_files(middle_files)

	return o_fname_raw
endfunction
" }}}

function! s:delete_middle_files(files) "{{{2
	for file in a:files
		if delete(file)
			call xelltoolkit#echo_msg('Cannot delete middle file: ' . file)
		endif
	endfor
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
