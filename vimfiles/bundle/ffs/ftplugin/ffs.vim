" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

let b:testres1 = []
let b:testres2 = []

setlocal hidden
setlocal bufhidden=delete
setlocal buftype=nofile
setlocal omnifunc=ListsFakeMatches
" setlocal omnifunc=TestLFM

let t:keyword = ''
let t:bufnr = bufnr('%')

nnoremap <buffer> <Esc> :bd!<CR>
inoremap <buffer> <D-Return> <Esc>:call <SID>generate_filelist()<CR>
inoremap <buffer> <Return> <Return><Esc>:call <SID>openfile()<CR>

augroup ffs
	au!
	autocmd CursorMovedI <buffer> let t:keyword = getline('.') | call feedkeys("\<C-x>\<C-o>\<C-p>", 'n')
augroup END

function! TestLFM(findstart, base)
    let pathlen = len(getcwd()) + 1
    call map(ListsFakeMatches(a:findstart, a:base), 'strpart(v:val, pathlen)')
endfunction

function! ListsFakeMatches(findstart, base) " {{{1
	if a:findstart
		return 0
	else
        let res = []
        if t:keyword =~ '^`'
            let tagword = substitute(t:keyword, '`', '\\`', 'g')
            let res += split(system('mdfind -onlyin ' . t:ffs_start_path . ' "kMDItemOMUserTags == ' . "'" . tagword . "'" . '"'), '\n')
        else
            " ack 2.x
            " let res += split(system("ack --text -g '" . t:keyword . "' " . t:ffs_start_path), '\n')
            " let res += split(system("ack --text -l '" . t:keyword . "' " . t:ffs_start_path), '\n')

            " it will cause the file with the name equal to t:keyword is empty file name.
            " let res += split(system("ack --text -g '" . t:keyword . "'"), '\n')
            " let res += split(system("ack --text -l '" . t:keyword . "'"), '\n')

            " ack 1.x
            " let res += split(system("ack -g '" . t:keyword . "' " . t:ffs_start_path), '\n')
            " let res += split(system("ack -l '" . t:keyword . "' " . t:ffs_start_path), '\n')

            " ag
            " https://github.com/ggreer/the_silver_searcher
            " http://betterthanack.com/
            let res += split(system("/usr/local/bin/ag -S -g '" . t:keyword . "' " . t:ffs_start_path), '\n')
            let res += split(system("/usr/local/bin/ag -S -l '" . t:keyword . "' " . t:ffs_start_path), '\n')
            " TODO dirty fix for single line result disappered in the omni complete popup menu
            let res += ["-- END --"]

            " call complete_add(a:base)
        endif
        return res
	endif
endfunction
" }}}

function! s:openfile() " {{{1
	let filename = substitute(getline(1), '^' . t:keyword, '', '')
	" if no existed file was choosen
	if filename == ''
		call xelltoolkit#echo_msg('No such file. Would you like to create it? (y or ext/N)')
		let fileext = input('')
		if fileext == '' || fileext =~? 'n\|no'
			silent! 2,$d
			return
		else
			" add file ext
			let filename = substitute(getline(1), ' ', '\\ ', 'g')
			if fileext =~? 'y\|yes'
				let filename = filename . '.' . g:xell_notes_default_ext
			else
				let filename = filename . '.' . fileext
			endif
		endif
	endif

	botright new
	exec 'silent! edit! ' . filename
	exec 'silent! bdelete! ' . t:bufnr
	augroup! ffs
	normal gg
	let @/ = t:keyword

	" normal n
endfunction
" }}}

function! s:generate_filelist() " {{{1
    let res = []
    if t:keyword =~ '^`'
        let tagword = substitute(t:keyword, '`', '\\`', 'g')
        let res += split(system('mdfind -onlyin ' . t:ffs_start_path . ' "kMDItemOMUserTags == ' . "'" . tagword . "'" . '"'), '\n')
    else
        " ack 2.x
        let res += split(system("ack --text -g '" . t:keyword . "' " . t:ffs_start_path), '\n')
        let res += split(system("ack --text -l '" . t:keyword . "' " . t:ffs_start_path), '\n')
    endif

    let pathlen = len(getcwd()) + 1
    call map(res, 'strpart(v:val, pathlen)')

    unlet b:did_ftplugin
    set ft=filelist
    exec 'resize ' . (len(res) + 3)
    call setline(1, ':' . getcwd())
    call append(1, '')
    call append(2, res)

endfunction
" }}}
