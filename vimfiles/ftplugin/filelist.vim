" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

set fenc=utf8

nnoremap <silent> <buffer> <Return> :call <SID>edit_file(0)<CR>
nnoremap <silent> <buffer> <S-CR> :call <SID>edit_file(1)<CR>
" Edit file {{{1
function! s:edit_file(openinnewtab)
	let line = getline('.')
    " exclude :#" and empty lines
    if line =~ '^[:#"]' || line =~ '^[ ]*$'
        return
    endif

    " escape blankspace
    let filename = substitute(line, '\([^\\]\) ', '\1\\ ', 'g')

    " search for the path, i.e. the line started with :
    let i = getpos('.')[1] - 1
    while i >= 1
        if getline(i) =~ '^[:]'
            " ignore if there is / in the end of the path
            let filename = substitute(strpart(getline(i), 1), '\/$', '', 'g') . '/' . filename
            break
        else
            let i -= 1
        endif
    endwhile

    " if there is no path defined
    if i == 0
        call xelltoolkit#echo_msg("There is no path defined!")
        return
    endif

    " if the file does not exist
	if glob(filename) == ''
        call xelltoolkit#echo_msg("There is no such file: " . filename)
        return
	endif

	if a:openinnewtab
		exec 'tabedit ' . filename
	else
		exec 'edit ' . filename
	endif

endfunction
" }}}

" XXX converting is specified for notes, but here it's general for all
" 'filelist' filetype files.
" Converts {{{1

function! NotesConvertWrapper(out_type, config) "{{{2
	if a:out_type == ''
		call s:convert_notes()
		return
	else
		call xelltoolkit#echo_msg('Wrong argument!')
		return
	endif
endfunction
" }}}

function! s:convert_notes() "{{{2
	let files = split(glob(g:xell_notes_root . g:slash . '*.*'), '\n')
	let index = -1
	" Remove all html files
	for file in files
		let index = index + 1
		if file =~? '\.html\?$'
			call remove(files, index)
			let index = index - 1
		endif
	endfor

	for note in files
		let note_time = getftime(note)

		if note =~? '\.t2t$'
			let note_ex_time = getftime(g:xell_notes_ex_root . g:slash .
						\ xelltoolkit#fname_name(note) . '.html')
			if note_time > note_ex_time
				call T2TConverter(note, 'html', 'note', g:xell_notes_ex_root)
			endif
		elseif note =~? '\.\(md\|mkd\|markdown\|pandoc\)$'
			let note_ex_time = getftime(g:xell_notes_ex_root . g:slash .
						\ xelltoolkit#fname_name(note) . '.html')
			if note_time > note_ex_time
				" XXX c means --self-contained and all the images?
				call Pandoc_html_conv(note, 'html', 'cnote', g:xell_notes_ex_root)
			endif
		elseif note =~? '\.rst$'
			let note_ex_time = getftime(g:xell_notes_ex_root . g:slash .
						\ xelltoolkit#fname_name(note) . '.html')
			if note_time > note_ex_time
				call RstConverter(note, 'html', '', g:xell_notes_ex_root)
			endif
		elseif note =~ 'index\.noteindex$'
			let note_ex = g:xell_notes_root . g:slash . 'index.md'
			let note_ex_time = getftime(note_ex)
			if note_time > note_ex_time
				let index_md_file = NoteindexConverter(note, '')
				call Pandoc_html_conv(index_md_file, 'html', 'cnote', g:xell_notes_ex_root)
			endif
		" ignore files
		elseif note !~? '\.\(html\|sw.\)$'
			let note_ex = g:xell_notes_ex_root . g:slash .
						\ xelltoolkit#fname_name(note) . '.' .
						\ xelltoolkit#fname_ext(note)
			let note_ex_time = getftime(note_ex)
			if note_time > note_ex_time
				call writefile(readfile(note), note_ex)
			endif
		else
			"Place holder
		endif
	endfor

endfunction
" }}}

function! NoteindexConverter(note, config) "{{{2
	let index_out = g:xell_notes_root . g:slash . 'index.md'
	let index_file = readfile(a:note)
	let i = 0
	let end_of_file = len(index_file)
	while i < end_of_file
		let line = index_file[i]

		if line =~? '^%'
			let i = i + 1
			continue
		" Blank lines
		elseif line =~? '^\s*$'
			let i = i + 1
			continue
		" Headings
		elseif line =~? '[^)]$'
			let num_of_blank = len(matchstr(line, '^\s\+')) / 4
			let line = repeat('#', num_of_blank + 1) . ' ' . substitute(line, '^\s\+', '', 'g')
			let index_file[i] = line
		" Links
		elseif line =~? ')$'
			let line = substitute(line, '^\s\+', '', 'g')
			let link_text = substitute(matchstr(line, '^\zs.\+\ze('), '\s\+$', '', '')
			let link_file = matchstr(line, '(\zs[^ )]\+\ze)$')
			if link_file =~? '\.\(t2t\|md\|mkd\|markdown\|pandoc\|rst\)$'
				let link_file = xelltoolkit#fname_name(link_file) . '.html'
			endif
			let line = ' * [' . link_text . '](' . link_file . ')'
			let index_file[i] = line
		endif

		" If there is no blank line, add one
		call insert(index_file, '', i)
		let i = i + 2
		let end_of_file = end_of_file + 1
	endwhile

	call writefile(index_file, index_out)
	return index_out
endfunction
" }}}

" }}}

