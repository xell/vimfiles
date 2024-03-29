" Pandoc filetype plugin
" Language:	Pandoc
" Maintainer:	Xell Liu

" Init {{{1

" Credit:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ftplugin/pandoc.vim
"
" Thrown together by David Sanson <https://github.com/dsanson>, who is
" a complete newbie when it comes to vim, so doesn't really know what he is
" doing.

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

" }}}

" Settings {{{1
"
setlocal indentexpr=
setlocal nolinebreak

setlocal expandtab
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4

setlocal concealcursor=n
setlocal conceallevel=2

setlocal formatoptions+=roc
" Do not add two spaces at end of punctuation when joining lines
set nojoinspaces

" HTML style comments
setlocal commentstring=<!--%s-->
setlocal comments+=s:<!--,m:\ \ \ \ ,e:-->,:*,:1.
setlocal comments-=b:#

"setlocal showbreak=\ \ \ 
"setlocal textwidth=80

" TODO Use pandoc to tidy up text
"
" If you use this on your entire file, it will wipe out title blocks.
" To preserve title blocks, use :MarkdownTidy instead. (If you use
" :MarkdownTidy on a portion of your file, it will insert unwanted title
" blocks...)
"
" set equalprg=pandoc\ -t\ markdown\ --no-wrap
" set formatprg=pandoc\ -t\ markdown\ --no-wrap

" }}}

" Mappings {{{1
" Temp for surroundind `` to the selected
" Bold
inoremap <buffer> <D-b> ****<++><Left><Left><Left><Left><Left><Left>
vnoremap <buffer> <D-b> "zc**<C-R>Z**<Esc>
" Italics
vnoremap <buffer> <D-i> "zc*<C-R>Z*<Esc>
" Code C-A-c
nmap <buffer> <D-ã> vt>l"zc`<C-R>Z`<Esc>
vnoremap <buffer> <D-ã> "zc`<C-R>Z`<Esc>
" Highlight
vnoremap <buffer> <D-M> "zc{=<C-R>Z}<Esc>
" Strikethrough C-A-s
vnoremap <buffer> <D-ó> "zc~~<C-R>Z~~<Esc>

nnoremap <buffer> j gj
nnoremap <buffer> k gk
nmap <buffer> <Leader>pp :Pandoc<CR>

call xelltoolkit#imap('**', '*<++>*<++>', 1)
call xelltoolkit#imap('``', '`<++>`<++>', 1)
call xelltoolkit#imap('··', '`<++>`<++>', 1)
call xelltoolkit#imap('[[', '[<++>](<++>)<++>', 1)
call xelltoolkit#imap('["', '[<++>](<++>"<++>")<++>', 1)
call xelltoolkit#imap('~~', '~~<++>~~<++>', 1)
call xelltoolkit#imap('$$', '$<++>$<++>', 1)
call xelltoolkit#imap('{{', '{=<++>}<++>', 1)

" TODO remove the imap?
imap <buffer> <c-w><c-w> <Esc>:call <SID>promote_item()<CR>
imap <buffer> <c-w><c-q> <Esc>:call <SID>demote_item()<CR>
nmap <buffer> <Tab> :call <SID>promote_item()<CR>
nmap <buffer> <S-Tab> :call <SID>demote_item()<CR>
" Shift list {{{2
function! s:promote_item()
	let cur_line = getline('.')
	if match(cur_line, '^\s*\zs[^ ]\ze', 0) == 1
		let leading = '   '
	else
		let leading = '    '
	endif
	if cur_line =~ '\s\+$'
		let suffix = ''
	else
		let suffix = ' '
	endif
	call setline('.', leading . cur_line . suffix)
endfunction
function! s:demote_item()
	let cur_line = getline('.')
	let cur_line = substitute(cur_line, '^' . repeat('\s', 4), '', '')
	call setline('.', cur_line)
endfunction
" }}}

" }}}

" Folding {{{1
" # Folding sections with ATX style headers.
"
" Taken from
" http://stackoverflow.com/questions/3828606/vim-markdown-folding/4677454#4677454
" 1 仅考虑 #，没有额外考虑空行以产生美观的分隔
" 2 有额外空行
" 3
command! -buffer -nargs=1 ChangeMDFoldMethod call <SID>change_fold_method(<args>)
function! s:change_fold_method(level) " {{{2
    if a:level == 0
        setlocal foldmethod=manual
        setlocal foldexpr=
    elseif a:level == 1
		setlocal foldmethod=expr
		setlocal foldexpr=MarkdownLevel1()
    elseif a:level == 2
		setlocal foldmethod=expr
		setlocal foldexpr=MarkdownLevel2()
    elseif a:level == 3
		setlocal foldmethod=expr
		setlocal foldexpr=MarkdownLevel3()
    else
        call xelltoolkit#echo_msg('Only support 0 1 2 3.')
    endif
endfunction
" }}}
function! MarkdownLevel1() " {{{2
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return ">6"
    endif

    return "="
endfunction "}}}
function! MarkdownLevel2() " {{{2
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return ">6"
    endif

	if getline(v:lnum) =~ '^\s*$' 
				\ && getline(v:lnum + 1) =~ '\%(^#\s\)\|\%(^<div\sclass="rst-rubric"\)'
		return "0"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^##\s'
		return "1"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^###\s'
		return "2"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^####\s'
		return "3"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^#####\s'
		return "4"
	endif
    return "="
endfunction "}}}
function! MarkdownLevel3() " {{{2
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return ">6"
    endif
	if getline(v:lnum) =~ '^<!--\s.\+{\{3}\s-->'
		return "a1"
	endif
	if getline(v:lnum) =~ '^<!--\s}\{3}\s-->'
		return "s1"
	endif
	if getline(v:lnum) =~ '^<div\sclass="rst-rubric"'
		return ">1"
	endif

	if getline(v:lnum) =~ '^[^-= ].\+$' && getline(v:lnum+1) =~ '^=\+$'
		return ">1"
	endif
	if getline(v:lnum) =~ '^[^-= ].\+$' && getline(v:lnum+1) =~ '^-\+$'
		return ">2"
	endif

	if getline(v:lnum) =~ '^\s*$' 
				\ && getline(v:lnum + 1) =~ '\%(^#\s\)\|\%(^<div\sclass="rst-rubric"\)'
		return "0"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^##\s'
		return "1"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^###\s'
		return "2"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^####\s'
		return "3"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^#####\s'
		return "4"
	endif
    return "="
endfunction "}}}
if exists('g:pandoc_fold_level')
    call s:change_fold_method(g:pandoc_fold_level)
else
    call s:change_fold_method(2)
endif

setlocal foldcolumn=5
setlocal foldtext=Mkdfoldtext()
function! Mkdfoldtext() "{{{2

    "get first non-blank line {{{3
    let fs = v:foldstart
    while getline(fs) =~ '^\s*$' 
		let fs = nextnonblank(fs + 1)
    endwhile
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        "let line = getline(fs)
        let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
    endif
	" }}}
	
	if line =~ '<div[^>]\+class="rst-rubric">'
		let line = '= ' . matchstr(line, '>\zs.*\ze$')
	endif

	if line =~ '^\s*<!--\s.\+{\{3}\s-->'
		let line = matchstr(line, '<!--\s\zs.\+\ze\s{\{3}\s-->')
		let line = repeat('-', v:foldlevel) . ' ' . line . ' ' . repeat('{', 3)
	endif


    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    " let foldLevelStr = repeat("+--", v:foldlevel - a:n)
	let foldLevelStr = ''


	" n lines
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " " . foldSize . " lines "
	
	" [m%]
    let lineCount = line("$")
    let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "

	" ....
    let expansionString = repeat(".", w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))

    return foldLevelStr . line . expansionString . foldSizeStr . foldPercentage
endfunction
"}}}

nmap <buffer> <c-u>u :call <SID>startvirfold()<CR>
nmap <buffer> <c-u>i :call setline('.', '<!-- ' . repeat('}', 3) . ' -->')<CR>
nmap <buffer> <c-u>o :call setline('.', '<!-- End of List -->')<CR>

function! s:startvirfold() "{{{2
	let fold_title = input('Title: ')
	if fold_title == ''
		let fold_title = 'links'
	endif
	let fold_title = fold_title . ' ' . repeat('{', 3)
	let fold_title = substitute(fold_title, '^Title:\s', '', '')
	let fold_title = '<!-- ' . fold_title . ' -->'

	call setline('.', fold_title)
endfunction "}}}

" }}}

" Link {{{1
" Search, copy and open
nmap <buffer> <expr> <Leader>y xelltoolkit#get_copy(<SID>get_link())
nmap <buffer> <D-> :call <SID>open()<CR>
" TODO diff with urlpattern?
nnoremap <buffer> gn :call xelltoolkit#goto_next_word(b:tabpattern)<CR>
nmap <buffer> gN :call xelltoolkit#goto_pre_word(b:tabpattern)<CR>

" let b:tabpattern = '\(\[[^\^]\{-}\]\([:\[]\)\@!\(([^)]\{-})\)\?\)\|' . g:urlpattern
let b:tabpattern = '\(\[[^\^]\{-}\]\([:\[]\)\@!\(([^ ]\{-}\%(\s"[^"]\{-}"\)\?)\)\?\)\|' . g:urlpattern

function! s:open()
    call OpenInBrowser(1,s:get_link())
endfunction

function! s:get_link()
	let linktext = xelltoolkit#get_word_at_cursor(b:tabpattern)

	if linktext == ''
		echohl WarningMsg | echomsg 'Wrong URI!' | echohl None
		return ''
	elseif linktext !~ '^\['   " http or file
		return linktext
	elseif linktext =~ '\]('   " [linktext](http title)
		return matchstr(linktext, '\](\(\zs[^ ]\{-}\ze\%(\s"[^"]\{-}"\)\?\))', 0)
	endif

	" [linktext][id] or [linktext][] or [linktext]
	if linktext =~ '\]\[' && linktext !~ '\[\]'
		let id = matchstr(linktext, '\]\[\zs[^]]\+\ze\]', 0)
	else
		let id = matchstr(linktext, '^\[\zs[^]]\+\ze\]', 0)
	endif
	return matchstr(getline(searchpos('^[ ]\{0,3}\[' . id . '\]:\s', 'n')[0]), '\]:\s\zs[^ ]\+\ze')
endfunction
" }}}

" Textbundle {{{
" http://textbundle.org/spec/
let s:textbundle_filename = expand("%:r")

command! -buffer -nargs=0 ExportTextbundle call <SID>export_textbundle()
function! s:export_textbundle()
    " Is it already in a Textbundle?
    if expand("%:p:h:t") =~ '\.textbundle$'
        echohl ErrorMsg | echo "It's already a Textbundle." | echohl None
        return
    endif
    " Is there an assests directory?
    let current_dir = expand("%:p:h")
    if !isdirectory(current_dir . '/assets')
        echohl ErrorMsg | echo "There's no 'assets' directory." | echohl None
        return
    endif
    " CD to current directory to siimplify the following operations
    exec 'cd ' . current_dir
    let textbundle_filename = expand("%:t:r")
    " let textbundle_path = current_dir . '/' . textbundle_filename . '.textbundle'
    " call mkdir(textbundle_path)
    call mkdir(textbundle_filename . '.textbundle')
    echo system('cp -r assets "' . textbundle_filename . '.textbundle/"')
    echo system('cp "' . expand("%:p:t") . '" "' . textbundle_filename . '.textbundle/text.md"')
    let info_json_content = ['{', '"version" : 2,',
                \ '"type": "net.daringfireball.markdown",',
                \ '"transient" : true,',
                \ '"creatorURL" : "file:///Applications/MacVim.app",',
                \ '"creatorIdentifier" : "org.vim",',
                \ '"sourceURL": ""', '}']
    call writefile(info_json_content, 'info.json', )
    echo system('mv info.json "' . textbundle_filename . '.textbundle/"')
    " echohl MoreMsg
    echom textbundle_filename . ".textbundle"
    echom "was successfully created in"
    echom current_dir
    " echohl None
endfunction
" }}}

" Check duplicated ids {{{1
command! -buffer -nargs=0 CheckDupIDs call <SID>check_dup_ids()
function! s:check_dup_ids() "{{{2
	let end_of_file = line('$')
	let line_index = 1
	let data = []
	while (line_index <= end_of_file)
		call add(data, getline(line_index))
		let line_index = line_index + 1
	endwhile

	" echo data
	
	" search [link]
	let pattern_link = '\[[^]]\+\]\(([^ ]\+)\|\[[^]]\+\]\)\?\(:\)\@!'
	let link_map = {}

	let line_index = 0
	while (line_index < len(data))
		let line_match_index = 1
		while (1)
			let line_match_item = matchstr(data[line_index], pattern_link, 0, line_match_index)
			let data[line_index] = substitute(data[line_index], pattern_link, '', '')
			if line_match_item != ''
				" analyze the item and get the actual link_id
				if line_match_item =~ '\]\['
					let link_id = matchstr(line_match_item, '\]\[\zs[^]]\+\ze\]')
				else
					let link_id = matchstr(line_match_item, '\[\zs[^]]\+\ze\]')
				endif

				if !has_key(link_map, link_id)
					let link_map[link_id] = []
				endif

				call add(link_map[link_id], line_index + 1)

				let line_match_index = line_match_index + 1
			else
				break
			endif
		endwhile
		let line_index = line_index + 1
	endwhile

	let info_links = "Duplicated link id:\n"
	for link_id in keys(link_map)
		if len(link_map[link_id]) > 1
			let info_links = info_links . link_id . "\t\t: " . string(link_map[link_id])
			let info_links = info_links . "\n"
		endif
	endfor
	" echo info_links

	"""""""""""""""""
	" search [ref]:
	let pattern_ref = '^[ ]\{0,3}\[[^]]\+\]:\s'
	let ref_map = {}

	let line_index = 0
	while (line_index < len(data))
		let line_match_item = matchstr(data[line_index], pattern_ref)
		if line_match_item != ''
			let link_id = matchstr(line_match_item, '\[\zs[^]]\+\ze\]:')
			if !has_key(ref_map, link_id)
				let ref_map[link_id] = []
			endif
			call add(ref_map[link_id], line_index + 1)
		endif
		let line_index = line_index + 1
	endwhile

	let info_refs = "\nDuplicated link ref:\n"
	for link_id in keys(ref_map)
		if len(ref_map[link_id]) > 1
			let info_refs = info_refs . link_id . "\t\t: " . string(ref_map[link_id])
			let info_refs = info_refs . "\n"
		endif
	endfor
	" echo info_refs
	
	to sp 'Duplicated Items Preview'
    let s:bufNo = bufnr('%')
	put =info_links
	put =info_refs
	setlocal nomodifiable
	setlocal nobuflisted
	setlocal nonumber
	setlocal noswapfile
	setlocal buftype=nofile
	setlocal bufhidden=delete
	setlocal noshowcmd
	setlocal nowrap
endfunction "}}}
" }}}

" Create reference links {{{1
imap <buffer> <C-D-l> <Esc>:call <SID>ref_links()<CR>
function! s:ref_links()
	let ori_col = col(".")
	let ori_line = line(".")
	let end_of_file = line('$')

	let def_pattern = '^[ ]\{0,3}\[[^]^]\{-}\]:\s'

	" find the next blank line
	let blankline = -1
	let line_index = ori_line + 1
	while (line_index <= end_of_file)
		if getline(line_index) == ''
			let blankline = line_index
			break
		else
			let line_index = line_index + 1
		endif
	endwhile

	" compute the insert line
	if blankline == -1              
		" no blank line until eof, create one
		call append(end_of_file, '')
		let end_of_file = line('$')
		let insert_line = end_of_file
	elseif blankline == end_of_file
		" sole blank line in eof
		let insert_line = end_of_file
	elseif getline(blankline + 1) !~ def_pattern && getline(blankline + 1) != ''
		" normal, need to insert addional blank line
		let insert_line = blankline
		call append(insert_line, '')
	elseif getline(blankline + 1) !~ def_pattern && getline(blankline + 1) == ''
		" continuous blank lines
		let insert_line = blankline
	elseif getline(blankline + 1) =~ def_pattern && blankline + 1 == end_of_file
		" sole def line in eof
		let insert_line = end_of_file
	else
		" find the end of the def block
		let insert_line = blankline + 1
		while (insert_line < end_of_file - 1)
			" criteria:
			" 0 == [link] && 1 == '' && 2 != [^ft]
			if getline(insert_line + 1) == '' 
				break
			else
				let insert_line = insert_line + 1
			endif
		endwhile
	endif

	" receive link id and check if duplicated
	while (1)
		let link_id = input('Link ID: ')
		if search('\[' . link_id . '\]:', 'nw')
			call input('Duplicated Link ID. Re-enter please!')
			continue
		else
			break
		endif
	endwhile

	let @x = '[' . link_id . ']'
	let link_def = input('Link Def: ')

	call append(insert_line, '  [' . link_id . ']: ' . link_def)

	" determine if it's the begin of line
	if ori_col > 2
		normal "xp
	else
		normal "xP
	endif

	" determine if it's the end of line, 3 for double-width char and 1 for ascii char
	if col("$") - col(".") < 4
		startinsert!
	else
		startinsert
	endif

endfunction
" }}}

" Convert from inline-link to reference-link {{{1
vmap <buffer> <c-i> :call <SID>trans_in_ref()<CR>
function! s:trans_in_ref() range "{{{2

	" store the lines into data
	let index = 0
	let data = []
	while (index <= a:lastline - a:firstline)
		call add(data, getline(a:firstline + index))
		let index = index + 1
	endwhile
	
	" process the link in data
	
	" link_map stores the refers, so it must be a dict
	" i.e. no duplicated items
	let link_map = {}
	let pattern = '\(\[[^]]\+\]\)(\([^ ]\{-}\%(\s"[^"]\{-}"\)\?\))'
	" let pattern = '\(\[[^]]\+\]\)(\([^`]\+\))'
	let data_index = 0
	while (data_index < len(data))
		let line_match_index = 1

		" line_link_list stores the urls of the current line
		" cause there may be ids of the same name, it must be a list
		" i.e. it could contain duplicates.
		let line_link_list = []

		" search all pattern, store them in link_map and line_link_list
		while (1)
			let link_map_item = matchlist(data[data_index], pattern, 0, line_match_index)
			if link_map_item != []
				if has_key(link_map, link_map_item[1]) 
							\ && link_map[link_map_item[1]] != link_map_item[2]
					echohl WarningMsg
					echomsg "Duplicated Link ID but URL differs! Please re-check!"
					let error_line = a:firstline + data_index
					let dup_id = link_map_item[1]
					echomsg "Line: " . error_line . " ID: " . dup_id
					echohl None
					return
				endif
				call s:extend_dict(link_map, link_map_item[1], link_map_item[2])
				call add(line_link_list, link_map_item[2])
				let line_match_index = line_match_index + 1
			else
				break
			endif
		endwhile

		" process the links in the current line into data
		for link in line_link_list
			let link = escape(link, '~')
			let data[data_index] = substitute(data[data_index], '(' . link . ')', '', '')
		endfor

		let data_index = data_index + 1

	endwhile

	" check
	if empty(link_map)
		echohl WarningMsg
		echo "No link needs to be processed."
		echohl None
		return
	endif
	
	" setline from new data
	let data_index = 0
	while (data_index < len(data))
		call setline(a:firstline + data_index, data[data_index])
		let data_index = data_index + 1
	endwhile

	" add link ref block from link_map
	call append(a:lastline, '')
	let line_index = 1
	for link_id in keys(link_map)
		call append(a:lastline + line_index, '  ' . link_id . ': ' . link_map[link_id])
		let line_index = line_index + 1
	endfor
	call append(a:lastline + line_index, '')

	echohl Statement
	echo "Processes " . len(link_map) . " links. Done."
	echohl None

endfunction "}}}

function! s:extend_dict(dict, key, value) "{{{2
	let temp_d = {}
	let temp_d[a:key] = a:value
	call extend(a:dict, temp_d)
endfunction "}}}
" TODO
"" Jump back to existing reference link (or fn link)
" map <buffer><silent> <LocalLeader>br :call pandoc_misc#Pandoc_Back_From_Ref()<cr>
" }}}

" Toc jumping {{{1
" https://github.com/plasticboy/vim-markdown
command! -buffer Toc call s:Toc()
command! -buffer Toch call s:Toc('horizontal')
command! -buffer Tocv call s:Toc('vertical')
command! -buffer Toct call s:Toc('tab')

let s:headersRegexp = '\v^(#|.+\n(\=+|-+)$)'

let s:levelRegexpDict = {
    \ 1: '\v^(#[^#]@=|.+\n\=+$)',
    \ 2: '\v^(##[^#]@=|.+\n-+$)',
    \ 3: '\v^###[^#]@=',
    \ 4: '\v^####[^#]@=',
    \ 5: '\v^#####[^#]@=',
    \ 6: '\v^######[^#]@='
\ }

function! s:Toc(...)
    if a:0 > 0
        let l:window_type = a:1
    else
        let l:window_type = 'vertical'
    endif


    let l:cursor_line = line('.')
    let l:cursor_header = 0
    let l:header_list = s:GetHeaderList()
    let l:indented_header_list = []
    if len(l:header_list) == 0
        echom "Toc: No headers."
        return
    endif
    let l:header_max_len = 0
    let l:vim_markdown_toc_autofit = get(g:, "vim_markdown_toc_autofit", 0)
    for h in l:header_list
        " set header number of the cursor position
        if l:cursor_header == 0
            let l:header_line = h.lnum
            if l:header_line == l:cursor_line
                let l:cursor_header = index(l:header_list, h) + 1
            elseif l:header_line > l:cursor_line
                let l:cursor_header = index(l:header_list, h)
            endif
        endif
        " indent header based on level
        let l:text = repeat('  ', h.level-1) . h.text
        " keep track of the longest header size (heading level + title)
        let l:total_len = strdisplaywidth(l:text)
        if l:total_len > l:header_max_len
            let l:header_max_len = l:total_len
        endif
        " append indented line to list
        let l:item = {'lnum': h.lnum, 'text': l:text, 'valid': 1, 'bufnr': h.bufnr, 'col': 1}
        let l:indented_header_list = l:indented_header_list + [l:item]
    endfor
    call setloclist(0, l:indented_header_list)

    if l:window_type ==# 'horizontal'
        lopen
    elseif l:window_type ==# 'vertical'
        vertical lopen
        " auto-fit toc window when possible to shrink it
        if (&columns/2) > l:header_max_len && l:vim_markdown_toc_autofit == 1
            " header_max_len + 1 space for first header + 3 spaces for line numbers
            execute 'vertical resize ' . (l:header_max_len + 1 + 3)
        else
            execute 'vertical resize ' . (&columns/2)
        endif
    elseif l:window_type ==# 'tab'
        tab lopen
    else
        lopen
    endif
    setlocal modifiable
    for i in range(1, line('$'))
        " this is the location-list data for the current item
        let d = getloclist(0)[i-1]
        call setline(i, d.text)
    endfor
    setlocal nomodified
    setlocal nomodifiable
    execute 'normal! ' . l:cursor_header . 'G'
endfunction

function! s:GetHeaderList()
    let l:bufnr = bufnr('%')
    let l:fenced_block = 0
    let l:front_matter = 0
    let l:header_list = []
    let l:vim_markdown_frontmatter = get(g:, "vim_markdown_frontmatter", 0)
    for i in range(1, line('$'))
        let l:lineraw = getline(i)
        let l:l1 = getline(i+1)
        let l:line = substitute(l:lineraw, "#", "\\\#", "g")
        " exclude lines in fenced code blocks
        if l:line =~ '````*' || l:line =~ '\~\~\~\~*'
            if l:fenced_block == 0
                let l:fenced_block = 1
            elseif l:fenced_block == 1
                let l:fenced_block = 0
            endif
        " exclude lines in frontmatters
        elseif l:vim_markdown_frontmatter == 1
            if l:front_matter == 1
                if l:line == '---'
                    let l:front_matter = 0
                endif
            elseif i == 1
                if l:line == '---'
                    let l:front_matter = 1
                endif
            endif
        endif
        " match line against header regex
        if join(getline(i, i + 1), "\n") =~ s:headersRegexp && l:line =~ '^\S'
            let l:is_header = 1
        else
            let l:is_header = 0
        endif
        if l:is_header == 1 && l:fenced_block == 0 && l:front_matter == 0
            " remove hashes from atx headers
            if match(l:line, "^#") > -1
                let l:line = substitute(l:line, '\v^#*[ ]*', '', '')
                let l:line = substitute(l:line, '\v[ ]*#*$', '', '')
            endif
            " append line to list
            let l:level = s:GetHeaderLevel(i)
            let l:item = {'level': l:level, 'text': l:line, 'lnum': i, 'bufnr': bufnr}
            let l:header_list = l:header_list + [l:item]
        endif
    endfor
    return l:header_list
endfunction

function! s:GetHeaderLevel(...)
    if a:0 == 0
        let l:line = line('.')
    else
        let l:line = a:1
    endif
    let l:linenum = s:GetHeaderLineNum(l:line)
    if l:linenum != 0
        return s:GetLevelOfHeaderAtLine(l:linenum)
    else
        return 0
    endif
endfunction

function! s:GetHeaderLineNum(...)
    if a:0 == 0
        let l:l = line('.')
    else
        let l:l = a:1
    endif
    while(l:l > 0)
        if join(getline(l:l, l:l + 1), "\n") =~ s:headersRegexp
            return l:l
        endif
        let l:l -= 1
    endwhile
    return 0
endfunction

function! s:GetLevelOfHeaderAtLine(linenum)
    let l:lines = join(getline(a:linenum, a:linenum + 1), "\n")
    for l:key in keys(s:levelRegexpDict)
        if l:lines =~ get(s:levelRegexpDict, l:key)
            return l:key
        endif
    endfor
    return 0
endfunction



" }}}

" XXX Disabled {{{1
" # Save folding between sessions
"
" autocmd BufWinLeave * if expand("%") != "" | mkview | endif
" autocmd BufWinEnter * if expand("%") != "" | loadview | endif
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set dictionary=~/.pandoc/citationkeys.dict
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Autocomplete citationkeys using function
"
"
" let s:completion_type = ''
" 
" function! Pandoc_Complete(findstart, base)
" 	if a:findstart
" 		" return the starting position of the word
" 		let line = getline('.')
" 		let pos = col('.') - 1
" 		while pos > 0 && line[pos - 1] !~ '\\\|{\|\[\|<\|\s\|@\|\^'
" 			let pos -= 1
" 		endwhile
" 
" 		let line_start = line[:pos-1]
" 		if line_start =~ '.*@$'
" 			let s:completion_type = 'bib'
" 		"else if line_start =~ '\[\^\=$'
" 			"let s:completion_type = 'ref'
" 		endif
" 		return pos
" 	else
" 		" return suggestions in an array
" 		let suggestions = []
" 		if s:completion_type == 'bib'
" 			" suggest BibTeX entries
" 			let suggestions = Pandoc_BibComplete(a:base)
" 		endif
" 		return suggestions
" 	endif
" endfunction
" 
" function! Pandoc_BibComplete(regex)
" 	let res = []
" 	for m in split(Pandoc_BibKey(a:regex))
" 		call add(res, m)
" 	endfor
" 	return res
" endfunction
" 
" function! Pandoc_BibKey(partkey)
" ruby << EOL
" bib="/Users/david/Documents/Dropbox/bib/sanson.bib"
" 
" def extractcitekeys(somestrings,text)
"   keys = []
"   somestrings.each { |match| 
"     match.chomp
"     keys = keys + text.scan(/@.*?\{(#{match}.*?),/i)
"   }
"   keys.uniq!
"   keys.sort!
"   return keys
" end
" 
" strings=VIM::evaluate('a:partkey')
" File.open(bib) { |file|
"     mytext = file.read
"     mykeys = extractcitekeys(strings,mytext)
" 	puts mykeys.join(" ")
" }
" EOL
" 
" endfunction
" 
" set omnifunc=Pandoc_Complete
" }}}
