if exists('g:loaded_livewordcount')
	finish
endif
let g:loaded_livewordcount = 1
"-------------- word count ---------------
"[^\\x00-\\xff]
" from http://stackoverflow.com/questions/114431/fast-word-count-function-in-vim/120386#120386 

" /usr/local/bin/wc_py
command! Wc :echo system("wc_py '" . expand("%:p") . "'")
command! WC :call <SID>counts_all_ft()

function! s:counts_all_ft()
	let files = substitute(glob(expand("%:p:h") . '/**/*.' . expand("%:e")), ' ', '\\ ', 'g')
	let files = substitute(files, '\n', ' ', 'g')
	echo system("wc_py " . files)
endfunction


command! -range=% Num :call NumberOfChars()
function! NumberOfChars() range "{{{
	" let chineseNum = 
	" execute "s/[^\\x00-\\xff]/&/gn" | execute "s/\\w/&/gn"
	" echo chineseNum

	"count double-byte characters
	redir => numChs
	"silent! execute a:firstline.",".a:lastline."s/[^\\x00-\\xff]/&/gn"
	silent! execute "'<,'>s/[^\\x00-\\xff]/&/gn"
	redir END
	if match(numChs,"E486") > 0
		let numC = 0
	else
		let numC = strpart(numChs, 0, stridx(numChs," "))
	endif

	"count english words
	redir => numEng
	silent! execute "'<,'>s/\\<\\(\\w\\|-\\|'\\)\\+\\>/&/gn"
	redir END
	if match(numEng,"E486") > 0
		let numE = 0
	else
		let numE = strpart(numEng, 0, stridx(numEng," "))
	endif

	"echo to vim
	echo ""
	echo numC . " 个中文字符" 
	echo numE . " 个英文词语"
endfunction "}}}

"returns the count of how many words are in the entire file excluding the current line
"updates the buffer variable Global_Word_Count to reflect this
fu! OtherLineWordCount() "{{{1
    let data = []
    "get lines above and below current line unless current line is first or last
    if line(".") > 1
        let data = getline(1, line(".")-1)
    endif
    if line(".") < line("$")
        let data = data + getline(line(".")+1, "$")
    endif
    let count_words = 0
    let pattern = "\\<\\(\\w\\|-\\|'\\)\\+\\>"
    for str in data
        let count_words = count_words + NumPatternsInString(str, pattern)
    endfor
    let b:Global_Word_Count = count_words
    return count_words
endf "}}}

fu! OtherLineWordCount_zh() "{{{1
    let data = []
    "get lines above and below current line unless current line is first or last
    if line(".") > 1
        let data = getline(1, line(".")-1)
    endif
    if line(".") < line("$")
        let data = data + getline(line(".")+1, "$")
    endif
    let count_words = 0
    let pattern = "[^\\x00-\\xff]"
    for str in data
        let count_words = count_words + NumPatternsInString(str, pattern)
    endfor
    let b:Global_Word_Count_zh = count_words
    return count_words
endf "}}}

"returns the word count for the current line
"updates the buffer variable Current_Line_Number
"updates the buffer variable Current_Line_Word_Count
fu! CurrentLineWordCount() "{{{1
    if b:Current_Line_Number != line(".") "if the line number has changed then add old count
        let b:Global_Word_Count = b:Global_Word_Count + b:Current_Line_Word_Count
    endif
    "calculate number of words on current line
    let line = getline(".")
    let pattern = "\\<\\(\\w\\|-\\|'\\)\\+\\>"
    let count_words = NumPatternsInString(line, pattern)
    let b:Current_Line_Word_Count = count_words "update buffer variable with current line count
    if b:Current_Line_Number != line(".") "if the line number has changed then subtract current line count
        let b:Global_Word_Count = b:Global_Word_Count - b:Current_Line_Word_Count
    endif
    let b:Current_Line_Number = line(".") "update buffer variable with current line number
    return count_words
endf "}}}

fu! CurrentLineWordCount_zh() "{{{1
    if b:Current_Line_Number_zh != line(".") "if the line number has changed then add old count
        let b:Global_Word_Count_zh = b:Global_Word_Count_zh + b:Current_Line_Word_Count_zh
    endif
    "calculate number of words on current line
    let line = getline(".")
    let pattern = "[^\\x00-\\xff]"
    let count_words = NumPatternsInString(line, pattern)
    let b:Current_Line_Word_Count_zh = count_words "update buffer variable with current line count
    if b:Current_Line_Number_zh != line(".") "if the line number has changed then subtract current line count
        let b:Global_Word_Count_zh = b:Global_Word_Count_zh - b:Current_Line_Word_Count_zh
    endif
    let b:Current_Line_Number_zh = line(".") "update buffer variable with current line number
    return count_words
endf "}}}

"returns the word count for the entire file using variables defined in other procedures
"this is the function that is called repeatedly and controls the other word
"count functions.
fu! WordCount() "{{{1
    if exists("b:Global_Word_Count") == 0
        let b:Global_Word_Count = 0
        let b:Current_Line_Word_Count = 0
        let b:Current_Line_Number = line(".")
        call OtherLineWordCount()
    endif
    call CurrentLineWordCount()
    return b:Global_Word_Count + b:Current_Line_Word_Count
endf "}}}

fu! WordCount_zh() "{{{1
    if exists("b:Global_Word_Count_zh") == 0
        let b:Global_Word_Count_zh = 0
        let b:Current_Line_Word_Count_zh = 0
        let b:Current_Line_Number_zh = line(".")
        call OtherLineWordCount_zh()
    endif
    call CurrentLineWordCount_zh()
    return b:Global_Word_Count_zh + b:Current_Line_Word_Count_zh
endf "}}}

function! UpdateWordCount() "{{{1
	call OtherLineWordCount()
	call OtherLineWordCount_zh()
	call CurrentLineWordCount()
	call CurrentLineWordCount_zh()
endfunction "}}}

"returns the number of patterns found in a string
fu! NumPatternsInString(str, pat) "{{{1
    let i = 0
    let num = -1
    while i != -1
        let num = num + 1
        let i = matchend(a:str, a:pat, i)
    endwhile
    return num
endf "}}}

" showlivewordcount {{{1
if !exists("s:livewordcount")
	let s:livewordcount = 0
endif
function! ShowLiveWordCount()
	let b:Current_Line_Number = line(".")
	let b:Current_Line_Number_zh = line(".")
	if s:livewordcount % 2 == 1
		if exists('g:mystatusline_fugitive')
			exec 'set statusline=' . g:mystatusline1 . g:mystatusline_fugitive . g:mystatusline2
		else
			exec 'set statusline=' . g:mystatusline1 . g:mystatusline2
		endif
		let s:livewordcount = s:livewordcount + 1
	else
		if exists('g:mystatusline_fugitive')
			exec 'set statusline=' . g:mystatusline1 . g:mystatusline_fugitive . '\ zh:%{WordCount_zh()}\ wc:%{WordCount()}' . g:mystatusline2
		else
			exec 'set statusline=' . g:mystatusline1 . '\ zh:%{WordCount_zh()}\ wc:%{WordCount()}' . g:mystatusline2
		endif
		if s:livewordcount != 0
			call UpdateWordCount()
		endif
		let s:livewordcount = s:livewordcount + 1
	endif
endfunction


