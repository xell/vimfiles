if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

" UNDO list {{{
" Reset the following options to undo this plugin.
let b:undo_ftplugin = "setlocal ".
      \ "suffixesadd< isfname< comments< ".
      \ "autowriteall< ".
      \ "formatoptions< foldtext< ".
      \ "foldmethod< foldexpr< commentstring< "
" UNDO }}}

" Settings {{{1
setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab
setlocal isfname-=]
setlocal isfname-=#
setlocal include=\\zs\\k\\+\\.t2t\\ze
"setlocal include='\[[^\s]\+\s.*t2t'
"setlocal include='\\zs[^\\s]\\+\\.t2t\\ze\\]'

setlocal conceallevel=2
setlocal concealcursor=n

setlocal autoindent
" The default comments incude a fb:- which conflict with ' - '
setlocal comments=n:%,:-,:+
setlocal formatoptions+=roc

" setlocal showbreak=\ \ \ 

" }}}

" Mappings {{{1

nmap <buffer> gf <C-W>f
nmap <buffer> j gj
nmap <buffer> k gk

" Use left or right arrow key to shift the level of title
nmap <buffer> <Left> :.s/\(=\+\)=/\1/ge<CR>:.s/\(+\+\)+/\1/ge<CR>
nmap <buffer> <Right> :.s/\(=\+\)/\1=/ge<CR>:.s/\(+\+\)/\1+/ge<CR>

nmap <buffer> [[ zk
nmap <buffer> ]] zj

" Use for indent the list bullets
imap <buffer> <c-w><c-w> <Esc>>>A 
imap <buffer> <c-w><c-q> <Esc><<A 

iab <buffer> xtdate %%date(%Y-%m-%d %X)

" Make selected bold: **xxx**
vmap <buffer> <M-8> "zc**<C-R>Z**<Esc>
" Make selected italic: //xx//
vmap <buffer> <M-/> "zc//<C-R>Z//<Esc>
" Make selected strike: --xx--
vmap <buffer> <M--> "zc--<C-R>Z--<Esc>
" Make selected under: __xx__
vmap <buffer> <M-_> "zc__<C-R>Z__<Esc>
" Make selected coded: ``xx``
" `d<BS> part is used to avoid auto ``<++>
vmap <buffer> <M-c> "zc`d<BS>`<C-R>Z`d<BS>`<Esc>

if g:isw
	call IMAP('****', '**<++>**<++>', 'txt2tags')
	call IMAP('////', '//<++>//<++>', 'txt2tags')
	call IMAP('````', '``<++>``<++>', 'txt2tags')
	call IMAP("''''", "''<++>''<++>", "txt2tags")
	imap <A-c> ((!))
	call IMAP('((!))', '((!<++>))<++>', 'txt2tags')
	imap <A-d> ((_))
	call IMAP('((_))', '((_<++>))<++>', 'txt2tags')
elseif g:ism
	call xelltoolkit#imap('****', '**<++>**<++>', 1)
	call xelltoolkit#imap('////', '//<++>//<++>', 1)
	call xelltoolkit#imap('````', '``<++>``<++>', 1)
	call xelltoolkit#imap("''''", "''<++>''<++>", 1)
	imap <A-c> ((!))
	call xelltoolkit#imap('((!))', '((!<++>))<++>', 1)
	imap <A-d> ((_))
	call xelltoolkit#imap('((_))', '((_<++>))<++>', 1)
endif

let b:search_pattern = g:urlpattern . '\|\%([a-zA-Z_]\+\.t2t[#]\?\)'
nmap <buffer> <Tab> :call xelltoolkit#goto_next_word(b:search_pattern)<CR>
nmap <buffer> <S-Tab> :call xelltoolkit#goto_pre_word(b:search_pattern)<CR>

" }}}

" Fold setting {{{1
setlocal foldtext=CustomFoldText(1)
setlocal foldcolumn=4
"setlocal fillchars=fold:\ ,stlnc:-,vert:\|,diff:-

" Following are deprecated. see vimrc CustomFoldText()
function! MyFoldText() "{{{2
  let line = getline(v:foldstart)
  """ the original, used for reference
  " let sub = substitute(line, '/\*\|\*/\|<<<\d\=', '', 'g')

  """ the following will output == Title Text
  " let sub = substitute(line, '=\+[^=]\+\zs=\+\ze', '', 'g')

  """ the following will output combination of \1 \2 and \3
  " let sub = substitute(line, '\(=\+\)\([^=]\+\)\(=\+\)', '\1\2', 'g')

  """ the following will output ×× Title Text ==
  " let sub = substitute(line, '=\+[^=]\+\zs=\+\ze','Ф','g')
  " let sub = substitute(sub, '=','×','g')
  " let sub = substitute(sub, 'Ф','','g')

  """ the following will output ×= Title Text ==
  "let sub = substitute(line, '^[=+]', '×','g')
  
  let sub = line
  if strpart(sub, 1, 1) != '='
	let sub .= '---------------------------------'
	let sub .= '---------------------------------'
	let sub .= '---------------------------------'
	let sub .= '---------------------------------'
	let sub .= '---------------------------------'
	let sub .= '---------------------------------'
  endif
"  " return v:folddashes . sub
"  let inittext = repeat('◎',v:foldlevel - 1)
"  " return "   " . inittext . " " . sub
  return sub
endfunction "}}}
function! MyFoldText2() "{{{2

    "get first non-blank line
    let fs = v:foldstart
    while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
    endwhile
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let line = getline(fs)
    endif

    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " " . foldSize . " lines "
    let foldLevelStr = repeat("+--", v:foldlevel - 1)
    let lineCount = line("$")
    let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
    "let expansionString = repeat(".", w - strlen(foldSizeStr) - strlen(line) - strlen(foldLevelStr) - strlen(foldPercentage))
    let expansionString = repeat(".", w - strwidth(foldSizeStr) - strwidth(line) - strwidth(foldLevelStr) - strwidth(foldPercentage))
    "return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
    return foldLevelStr . line . expansionString . foldSizeStr . foldPercentage
endfunction
function! s:length(str)
      return len(substitute(a:str, ".", "x", "g"))
endfunction
" }}}

" Define folding based on wiki headings; start with all folds open.
" See http://vim.wikia.com/wiki/VimTip1565
setlocal foldlevel=20
setlocal foldmethod=expr
" setlocal foldexpr=HeadingLevel(v:lnum)
" if !exists("*HeadingLevel") "{{{2
"   function HeadingLevel(lnum)
"     " n is the number of consecutive '=' at start of line
"     let n = strlen(substitute(getline(a:lnum), '[^=+].*', '', ''))
" 	n = (n >= 2) ? n - 1 : 0
"     return (n == 0) ? '=' : '>' . n
"   endfunction
" endif
" Foldexpr {{{2
setlocal foldexpr=Txt2tagsLevel()
function! Txt2tagsLevel() "{{{3
    if getline(v:lnum) =~ '^= .*=$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^== .*==$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^=== .*===$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^==== .*====$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^===== .*=====$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^====== .*======$'
        return ">6"
    endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^=\s'
		return "0"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^==\s'
		return "1"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^===\s'
		return "2"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^====\s'
		return "3"
	endif
	if getline(v:lnum) =~ '^\s*$' && getline(v:lnum + 1) =~ '^=====\s'
		return "4"
	endif
    return "="
endfunction "}}}
" }}}
" }}}

" Following comes the converter

" Buffer command T2TConvert {{{1
command! -buffer -nargs=* T2TConvert call <SID>t2t_convert(<f-args>)
" }}}

" Wrapper {{{1
" Default : file %; out_type html; config 
function! Txt2tagsConversionWrapper(out_type, config)
	if expand('%:p') =~? xelltoolkit#fname2pattern(g:xell_notes_root) && a:out_type == '' && a:config == ''
		call s:t2t_convert_bulk()
		return
	endif

	if a:out_type == ''
		let out_type = 'html'
	else
		let out_type = a:out_type
	endif

	if a:config == ''
		let config = 'normal'
	else
		let config = a:config
	endif

	"Only convert current buffer.
	call s:t2t_convert('', out_type, config)

endfunction
" }}}

" General converter {{{1
" txt2tags.py --style=xxx.css --config-file=xxx.t2t --outfile=xxx.html xxx.t2t
" t2tcf_html.t2t
" t2tcf_n_html.t2t
" t2tcf_rtf.t2t
" t2tcf_tex.t2t
" t2tcf_txt.t2t
" css/modern.css
" css/normal.css
" css/note.css
" xelltoolkit#fname_escape
function! s:t2t_convert(input, out_type, config)
	let slash = xelltoolkit#slash()
	
	" Output targets {{{2
	if !has_key(g:t2t_target_ext, a:out_type)
		call xelltoolkit#echo_msg('Unsupported target name!')
		return
	endif
	" }}}

	" Input and output file {{{2
	if a:input == ''
		let input = expand('%:p')
	else
		let input = a:input
	endif
	let output_file = xelltoolkit#fname_escape(xelltoolkit#fname_ext_mod(input, g:t2t_target_ext[a:out_type]))
	let input_file = xelltoolkit#fname_escape(input)
	" }}}

	" Config {{{2
	" Default
	if a:config == 'normal' && a:out_type == 'html'
		let style_file = xelltoolkit#fname_escape(g:t2t_cf_path . slash . 'css' . slash . 'normal.css')
		let config_file = xelltoolkit#fname_escape(g:t2t_cf_path . slash . 't2tcf_html.t2t')
		let config = ' --style=' . style_file . ' --config-file=' . config_file
	elseif a:config == 'note' && a:out_type == 'html'
		let style_file = xelltoolkit#fname_escape(g:t2t_cf_path . slash . 'css' . slash . 'note.css')
		let config_file = xelltoolkit#fname_escape(g:t2t_cf_path . slash . 't2tcf_n_html.t2t')
		let config = ' --style=' . style_file . ' --config-file=' . config_file

	" XXX hack : use a:out_type for config, don't care about a:config
	else
		let config_file = xelltoolkit#fname_escape(g:t2t_cf_path . slash . 't2tcf_' . a:out_type . '.t2t')
		if filereadable(config_file)
			let config = ' --config-file=' . config_file
		else
			let config = ''
		endif
	endif
	" }}}

	" Full exec
	let cmd = g:t2t_cmd . config . ' --target=' . a:out_type . ' --outfile=' . output_file . ' --infile=' . input_file
	call xelltoolkit#system(cmd)
endfunction
" }}}

" Bulk converter (placeholder)  {{{1
function! s:t2t_convert_bulk()
	call xelltoolkit#echo_msg('Not support yet.')
endfunction
" }}}

"====================================================================

" XXX Because I won't heavily use txt2tags in future -- in fact, I'd like to
" use Markdown to replace it progressively but totally -- here I just
" implement some basical function.  Old functions remain private below for
" further referrence, however they won't be called publicly any longer.

" Selectively convert all or single t2t files  {{{1
"cab xt2t !d:/p/txt2tags/txt2tags.py --outfile=x:/temp/%:t:r.html %
"%:p   全路径包括文件名
"%:p:h 全路径目录 但没有最后的 /
"%:t   文件名加后缀 = %
"%:t:r 文件名
"%:e   单独的后缀
"对于 t2t 转换 html 的情况，css 文件的路径是绝对与 t2t 文件的，而且用配置文件
"的方式无法指定硬盘路径，因此只好加在命令行中了。

" command! -buffer -nargs=* Xconvert call <SID>convert(<args>)
" command! -buffer Xbuildtags call NoteTagsBuild()
" let g:t2t_notes_ex_cf = 't2tcf_n_html.t2t'

function! s:convert(...) " {{{2

	if a:0
		let target = a:1
	else
		let target = 'html'
	endif

	let current_file_path = expand("%:p:h") . '/'
	let current_filename = expand("%:t:r")
	let config_file = g:t2t_cf_path . 't2tcf_' . target . '.t2t'
	let export_file = current_filename . '.' . target
	
	" if the sources are the notes
	if current_file_path == g:xell_notes_root
		if target != 'html'
			echomsg 'Notes can not be specified target other than html.'
		endif

		let filelist = glob(g:xell_notes_root . '*.t2t')
		for file in split(filelist, '\n')
			let filename = substitute(substitute(file, g:xell_notes_root, '', ''), g:xell_notes_ext, '', '')
			if filename == 'test'
				continue
			endif
			let export_file = g:xell_notes_ex_root . filename . '.html'
			let file_time = getftime(file)
			let exp_file_time = getftime(export_file)
			if file_time >= exp_file_time
				echomsg 'silent !' . g:t2t_cmd . ' --style=' . g:t2t_cf_path . 'css/note.css' . ' --config-file=' . g:t2t_cf_path . g:t2t_notes_ex_cf . ' --outfile=' . s:iconvconvert(export_file) . ' ' . s:iconvconvert(filename . g:xell_notes_ext)
			endif
		endfor
		return 1
	endif

	if target == 'html'
		echomsg '!' . g:t2t_cmd . ' --style=' . g:t2t_cf_path . 'css/normal.css' . ' --config-file=' . config_file . ' --outfile=' . s:iconvconvert(export_file) . ' ' . s:iconvconvert(expand("%"))
	else
		echomsg '!' . g:t2t_cmd . ' --config-file=' . config_file . ' --outfile=' . s:iconvconvert(export_file) . ' ' . s:iconvconvert(expand("%"))
		if target == 'tex'
			call s:preparetex()
		endif
	endif

endfunction
" }}}

function! s:iconvconvert(filename) " {{{2
	return iconv(escape(a:filename, '!'), "utf-8", "gbk")
endfunction
" }}}

function! s:preparetex() " {{{2
	"prepare the setup/ dir
	let tex_setup_path = expand("%:p:h") . '/setup'
	if !isdirectory(tex_setup_path)
		execute 'silent !md "' . escape(iconv(tex_setup_path, "utf-8", "gbk"), '!') . '"'
	endif
	let tex_packages_ori = g:t2t_cf_path . 'tex/packages.tex'
	let tex_definitions_ori = g:t2t_cf_path . 'tex/definitions.tex'
	if !filereadable(tex_setup_path . '/packages.tex')
		call writefile(readfile(tex_packages_ori), tex_setup_path . '/packages.tex')
	endif
	if !filereadable(tex_setup_path . '/definitions.tex')
		call writefile(readfile(tex_definitions_ori), tex_setup_path . '/definitions.tex')
	endif

	"prepare the figures/ dir
	let tex_figures_path = expand("%:p:h") . '/figures'
	" TODO make all images by ebb.exe
	" if !isdirectory(tex_figures_path)
	" 	execute 'silent !md "' . escape(iconv(tex_figures_path, "utf-8", "gbk"), '!') . '"'
	" endif
	
	"change the head of generated tex file
	let tex_file = expand("%:t:r") . '.tex'
	
	"try to close the existed tex window if possible
	"E94 No matching buffer
	try
		execute 'bd! ' . tex_file
		catch /^Vim\%((\a\+)\)\=:E94/
		echo "done"
	endtry
	if filereadable(tex_file)
		"open the generated tex file
		execute 'rightbelow split ' . tex_file
		"write the preamble
		call setline(1, '\documentclass[12pt,a4paper]{article}')
		call setline(2, '\input{setup/packages}')
		call setline(3, '\input{setup/definitions}')
		"delete the remaining old preamble
		normal 4G3dd
		"delete the pagebreak between title and toc
		execute '%g/maketitle\n\zs\\clearpage\ze/normal jS\thispagestyle{empty}'
		"autosize all graphics
		try
			execute '%s/includegraphics{/includegraphics[width=0.80\\textwidth]{/g'
		"E486 pattern no found
		catch /^Vim\%((\a\+)\)\=:E486/
			echo "no matching"
		endtry
		"substitute all \_ in math equations
		try
			execute '%s/\$[^$]\{-}\zs\\_\ze[^$]\{-}\$/_/g'
		catch /^Vim\%((\a\+)\)\=:E486/
			echo "no matching"
		endtry
		"folding
		"update the file
		write!
		normal ,rf
		normal gg
	endif
endfunction
" }}}

" }}}

