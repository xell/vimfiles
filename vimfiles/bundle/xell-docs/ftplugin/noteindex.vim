" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

" Settings {{{1
setlocal expandtab
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4

setlocal nolinebreak

setlocal concealcursor=n
setlocal conceallevel=2
" }}}

" Folding {{{1
nnoremap <silent> <buffer> J zj
nnoremap <silent> <buffer> K :call GoUpFold()<CR>
setlocal foldexpr=NoteIndexFoldLevel()
setlocal foldmethod=expr
setlocal foldcolumn=4
setlocal foldtext=CustomFoldText(4)
setlocal foldlevel=99

function! NoteIndexFoldLevel()
	if getline(v:lnum) =~ '^[^ %].*[^)]$'
		return ">1"
	endif
	if getline(v:lnum) =~ '^\s\{4}[^ ].*[^)]$'
		return ">2"
	endif
	if getline(v:lnum) =~ '^\s\{8}[^ ].*[^)]$'
		return ">3"
	endif
	if getline(v:lnum) =~ '^\s\{12}[^ ].*[^)]$'
		return ">4"
	endif
	if getline(v:lnum) =~ '^\s\{16}[^ ].*[^)]$'
		return ">5"
	endif

	if getline(v:lnum) =~ '^\s*$'
				\ && getline(v:lnum + 1) =~ '^[^ %].*[^)]$'
		return "0"
	endif
	if getline(v:lnum) =~ '^\s*$'
				\ && getline(v:lnum + 1) =~ '^\s\{4}[^ ].*[^)]$'
		return "1"
	endif
	if getline(v:lnum) =~ '^\s*$'
				\ && getline(v:lnum + 1) =~ '^\s\{8}[^ ].*[^)]$'
		return "2"
	endif
	if getline(v:lnum) =~ '^\s*$'
				\ && getline(v:lnum + 1) =~ '^\s\{12}[^ ].*[^)]$'
		return "3"
	endif
	if getline(v:lnum) =~ '^\s*$'
				\ && getline(v:lnum + 1) =~ '^\s\{16}[^ ].*[^)]$'
		return "4"
	endif

	return "="
endfunction

" }}}

" Edit notes {{{1
" In index file, use <CR> or <S-CR> to edit notes
nnoremap <silent> <buffer> <CR> :call <SID>edit_note(0)<CR>
nnoremap <silent> <buffer> <S-CR> :call <SID>edit_note(1)<CR>

function! s:edit_note(openinnewtab)
	let line = getline('.')
	let note = matchstr(line, '(\zs[^ )]\+\ze)$')
	" There is no note to edit
	if note == ''
		normal j
		return
	endif
	let note = g:xell_notes_root . g:slash . note

	if !filereadable(note)
		let answer = input("Note doesn't exist. Create it?(Y/n) ")
		if answer =~? 'n'
			return
		else
			call writefile(['%'], note)
		endif
	endif

	if a:openinnewtab
		exec 'tabedit ' . note
	else
		exec 'edit ' . note
	endif

endfunction
" }}}

" Delete notes {{{1
command! -buffer -nargs=0 -bang DeletNote call <SID>delete_note(<bang>0)

function! s:delete_note(forced)
	let line = getline('.')
	let note = matchstr(line, '(\zs[^ )]\+\ze)$')
	" There is no note to edit
	if note == ''
		call xelltoolkit#echo_msg('No note specified to delete!')
		return
	endif

	if !filereadable(g:xell_notes_root . g:slash . note)
		call xelltoolkit#echo_msg("The note doesn't exist!")
		return
	endif

	if !a:forced
		let answer = input('Really want to delete?(y/N) ')
		if answer !~? 'y'
			echo 'Deletion canceled.'
			return
		endif
	endif

	" Delete note and the export html
	call delete(g:xell_notes_root . g:slash . note)
	let note_ext = xelltoolkit#fname_ext(note)
	if note_ext =~? 'md\|mkd\|markdown\|pandoc\|rst\|t2t'
		call delete(g:xell_notes_ex_root . g:slash . xelltoolkit#fname_name(note) . '.html')
	else
		call delete(g:xell_notes_ex_root . g:slash . note)
	endif
	call xelltoolkit#echo_msg('Delete note and its export: ' . note)
	return

endfunction
" }}}

" Check notes and corresponding files {{{1
command! -buffer -nargs=0 Check call <SID>check()
function! s:check()

	" Generate notes of index dict {{{2
	let index_file = getline(1, '$')
	" {notefile_name: [line_num1, line_num2, ...]}
	let files_in_index_dict = {}
	let i = 1
	for line in index_file
		if line =~? ')$'
			let notefile = matchstr(line, '(\zs[^ )]\+\ze)$')
			if !has_key(files_in_index_dict, notefile)
				let files_in_index_dict[notefile] = [i]
			else
				call add(files_in_index_dict[notefile], i)
			endif
		endif
		let i += 1
	endfor
	" }}}

	" Generate notes of folder dict {{{2
	let files_in_folder = split(glob(g:xell_notes_root . g:slash . '*.*'), '\n')
	let files_in_folder_dict = {}
	let i = 0
	let end = len(files_in_folder)
	while i < end
		let file = files_in_folder[i]
		let file = substitute(file, xelltoolkit#fname2pattern(g:xell_notes_root) . '.', '', '')
		let files_in_folder[i] = file
		if file =~? '\(index\.md\|index\.noteindex\|\.swp\)$'
			call remove(files_in_folder, i)
			let end -= 1
			continue
		endif
		let files_in_folder_dict[file] = 1
		let i += 1
	endwhile
	" }}}

	" Generate results {{{2
	" {notefile, duplicate_line_num_in_index}
	let item_dup = {}
	" {notefile, line_num_in_index}
	let item_iso_index = {}
	" [file1, file2, ...]
	let item_iso_folder = []
	for file in sort(keys(files_in_index_dict))
		" Duplicated item in index.noteindex
		if len(files_in_index_dict[file]) > 1
			let item_dup[file] = files_in_index_dict[file]
		endif
		" File in index but NOT in folder
		if !has_key(files_in_folder_dict, file)
			let item_iso_index[file] = files_in_index_dict[file]
		endif
	endfor

	for file in sort(keys(files_in_folder_dict))
		" File in folder but NOT in index
		if !has_key(files_in_index_dict, file)
			call add(item_iso_folder, file)
		endif
	endfor
	" }}}

	" Empty result {{{2
	if item_dup == {} && item_iso_index == {} && item_iso_folder == []
		echo "Everything's OK!"
		return
	endif
	" }}}

	" Nonempty result {{{2
	let info = "  检查结果：\n\n"

	if item_dup != {}
		let info .= "  以下为 index 中重复出现的笔记条目：\n\n"
		for file in sort(keys(item_dup))
			let num_str = ''
			for num in item_dup[file]
				let num_str .= num . ' '
			endfor
			let info .= '    ' . file . " 重复出现在第 " . num_str . "行\n"
		endfor
		let info .= "\n\n"
	endif

	if item_iso_index != {}
		let info .= "  以下文件出现在 index 中，但不在电脑目录中：\n\n"
		for file in sort(keys(item_iso_index))
			let info .= '    ' . file . " 定义在第 " . item_iso_index[file][0] . " 行\n"
		endfor
		let info .= "\n\n"
	endif

	if item_iso_folder != []
		let info .= "  以下文件出现在电脑目录中，但不在 index 中：\n\n"
		for file in item_iso_folder
			let info .= '    ' . file . "\n"
		endfor
	endif

	topleft split 'Check information'
    let s:bufNo = bufnr('%')
	put =info
	setlocal nomodifiable
	setlocal nobuflisted
	setlocal nonumber
	setlocal noswapfile
	setlocal buftype=nofile
	setlocal bufhidden=delete
	setlocal noshowcmd
	setlocal nowrap
	" }}}

endfunction
" }}}
