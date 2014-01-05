setlocal hidden
setlocal bufhidden=delete
setlocal buftype=nofile
setlocal omnifunc=ListsFakeMatches

let t:keyword = ''
let t:bufnr = bufnr('%')

nnoremap <buffer> <Esc> :bd!<CR>
inoremap <buffer> <Return> <Return><Esc>:call <SID>openfile()<CR>

augroup ffs
	au!
	autocmd CursorMovedI <buffer> let t:keyword = getline('.') | call feedkeys("\<C-x>\<C-o>\<C-p>", 'n')
augroup END

function! ListsFakeMatches(findstart, base)
	if a:findstart
		" return col('.')
		return 0
	else
		" let t:keyword = getline(1)
		let res = []
        " ack 1.x
		" let res += split(system("ack --text --nobinary -g '" . t:keyword . "' " . t:ffs_start_path), '\n')
		" let res += split(system("ack --text --nobinary -l -m1 '" . t:keyword . "' " . t:ffs_start_path), '\n')
        " ack 2.x
		let res += split(system("ack --text -g '" . t:keyword . "' " . t:ffs_start_path), '\n')
		let res += split(system("ack --text -l '" . t:keyword . "' " . t:ffs_start_path), '\n')

		" call complete_add(a:base)
		return res
	endif
endfunction

function! s:openfile()
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
	exec 'silent! edit! ' . substitute(filename, ' ', '\\ ', 'g')
	exec 'silent! bdelete! ' . t:bufnr
	augroup! ffs
	normal gg
	let @/ = t:keyword

	" normal n
endfunction

" ack --help-types {{{1
"    --[no]actionscript .as .mxml
"    --[no]ada          .ada .adb .ads
"    --[no]asm          .asm .s
"    --[no]batch        .bat .cmd
"    --[no]binary       Binary files, as defined by Perl's -B op (default: off)
"    --[no]cc           .c .h .xs
"    --[no]cfmx         .cfc .cfm .cfml
"    --[no]clojure      .clj
"    --[no]cpp          .cpp .cc .cxx .m .hpp .hh .h .hxx
"    --[no]csharp       .cs
"    --[no]css          .css
"    --[no]delphi       .pas .int .dfm .nfm .dof .dpk .dproj .groupproj .bdsgroup .bdsproj
"    --[no]elisp        .el
"    --[no]erlang       .erl .hrl
"    --[no]fortran      .f .f77 .f90 .f95 .f03 .for .ftn .fpp
"    --[no]go           .go
"    --[no]haskell      .hs .lhs
"    --[no]hh           .h
"    --[no]html         .htm .html .shtml .xhtml
"    --[no]java         .java .properties
"    --[no]js           .js
"    --[no]jsp          .jsp .jspx .jhtm .jhtml
"    --[no]lisp         .lisp .lsp
"    --[no]lua          .lua
"    --[no]make         Makefiles (including *.mk and *.mak)
"    --[no]mason        .mas .mhtml .mpl .mtxt
"    --[no]objc         .m .h
"    --[no]objcpp       .mm .h
"    --[no]ocaml        .ml .mli
"    --[no]parrot       .pir .pasm .pmc .ops .pod .pg .tg
"    --[no]perl         .pl .pm .pod .t
"    --[no]php          .php .phpt .php3 .php4 .php5 .phtml
"    --[no]plone        .pt .cpt .metadata .cpy .py
"    --[no]python       .py
"    --[no]rake         Rakefiles
"    --[no]ruby         .rb .rhtml .rjs .rxml .erb .rake .spec
"    --[no]scala        .scala
"    --[no]scheme       .scm .ss
"    --[no]shell        .sh .bash .csh .tcsh .ksh .zsh
"    --[no]skipped      Files, but not directories, normally skipped by ack (default: off)
"    --[no]smalltalk    .st
"    --[no]sql          .sql .ctl
"    --[no]tcl          .tcl .itcl .itk
"    --[no]tex          .tex .cls .sty
"    --[no]text         Text files, as defined by Perl's -T op (default: off)
"    --[no]tt           .tt .tt2 .ttml
"    --[no]txt          .txt .text .t2t .md .mkd .markdown .pandoc
"    --[no]vb           .bas .cls .frm .ctl .vb .resx
"    --[no]verilog      .v .vh .sv
"    --[no]vhdl         .vhd .vhdl
"    --[no]vim          .vim
"    --[no]xml          .xml .dtd .xsl .xslt .ent
"    --[no]yaml         .yaml .yml
" }}}
