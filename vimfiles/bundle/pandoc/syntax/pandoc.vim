" Vim syntax file
" Filename: pandoc.vim
" Language: Markdown
" Maintainer: Xell Liu
" Last change: 2012-02-01
" 
" This file is a mixture of Schultz's and Sanson's with heavy modification of
" mine.


" Init:
" Initialization {{{1
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn case ignore
syn spell toplevel
if g:pandoc_syntax_accuracy
	syn sync linebreaks=1
	" syn sync minlines=10
	" syn sync fromstart
else
	syn sync minlines=10
	syn sync maxlines=50
endif
" }}}

" Include: HTML and TeX
" HTML and TeX {{{1
" 不能单单用下面这个，否则无法分辨小于号，语法高亮不正确
" runtime! syntax/html.vim

if g:pandoc_syntax_full_html_tex
	" Set embedded HTML highlighting
	syn include @HTML syntax/html.vim
	syn match pdcHTML	/<\a[^>]\+>/	contains=@HTML
	" Support HTML multi line comments XXX (dispaly?)
	syn region pdcHTMLComment   start=/<!--/ end=/-->/ display
	" 
	" Set embedded LaTex (pandoc extension) highlighting
	" Unset current_syntax so the 2nd include will work
	unlet b:current_syntax
	syn include @LATEX syntax/tex.vim
	" Single Tex command
	syn match pdcLatex	/\\\w\+{[^}]\+}/	contains=@LATEX
	" Tex Block (begin-end)
	syn region pdcLatex start=/\\begin{[^}]\+}\ze/ end=/\ze\\end{[^}]\+}/ contains=@LATEX
	" Math Tex
	syn match pdcLatex	/\$.\{-}\$/	   contains=@LATEX
else
	" Xell HTML and TeX
	syn match pdcHTMLTag '<\/\?[^+>]\+>'
	hi link pdcHTMLTag Directory

	syn region pdcHTMLComment   start=/<!--/ end=/-->/ display

	" syn match pdcTEXTag '\\\a\+{\a\+}'
	syn region pdcTEXTag start='\\\a\+{' end='}' oneline display
	hi link pdcTEXTag PreProc
endif

" }}}

" Def: Blankline, Docinfo, Heading
" Blankline, Docinfo, Heading {{{1
syn cluster pdcBeautifiers contains=pdcStrike,pdcEmphasis,pdcStrong,pdcCode

syn match pdcBlankLine   '\(^\s*\n\|\%^\)'    nextgroup=pdcAtxHeader,pdcSetexHeader,pdcCodeBlock,pdcBlockquote,pdcHRule,pdcListItem transparent
" ,pdcListItem,pdcListItem1,pdcHRule,pdcTableHeader,pdcTableMultiStart,pdcBlockquote transparent

" Title Block i.e. the first three lines headed with %
" syn match pdcTitleBlock /\(^%.*\n\)\{1,3}$/
syn match pdcTitleBlock /\%^\(%.*\n\)\{1,3}$/ skipnl

" Heading Header
syn match pdcAtxHeader /^\s*#\{1,6}.*\n/ contains=@Spell
syn match pdcSetexHeader /^.\+\n[=]\+$/ contains=@Spell
syn match pdcSetexHeader /^.\+\n[-]\+$/ contains=@Spell
syn match pdcSetexHeader /^.\+\n[_]\+$/ contains=@Spell

" }}}

" Inline:
" Inline markup {{{1
" **strong**
syn match   pdcStrong       '\*\*\S\(\|.\{-}\S\)\*\*\+'hs=s+2,he=e-2 contains=@Spell,pdcStrongFix
" ~~temp~~
syn match   pdcStrike       '\~\~[^\~ ]\([^\~]\|\~ \)*\~\~' contains=@Spell
" *emp*
syn match   pdcEmphasis     '\(\*\)\([^\* ]\|[^\*]\( [^\*]\)\+\)\+\1' contains=@Spell,pdcStrongFix
syn match   pdcStrongFix    '\*' contained conceal
" subscripts: ~a~
syn match pdcSubscript   /\~\([^\~\\ ]\|\(\\ \)\)\+\~/   contains=@Spell
" superscript: ^A^
syn match pdcSuperscript /\^\([^\^\\ ]\|\(\\ \)\)\+\^/   contains=@Spell

" }}}

" Code: Inline and block
" Code {{{1
" `code`
" syn region pdcCode start=/`\S/ end=/`\|^\s*$/ oneline containedin=ALL
" syn region pdcCode start=/``[^`]*/ end=/``\|^\s*$/ oneline containedin=ALL
" syn match pdcCodePre /<pre>.\{-}<\/pre>/ skipnl containedin=ALL
" syn match pdcCodePre /<code>.\{-}<\/code>/ skipnl containedin=ALL
syn region pdcCode start=/`\S/ end=/`\|^\s*$/ oneline
syn region pdcCode start=/``[^`]*/ end=/``\|^\s*$/ oneline
syn match pdcCodePre /<pre>.\{-}<\/pre>/ skipnl
syn match pdcCodePre /<code>.\{-}<\/code>/ skipnl

" Old code block def
" syn match  pdcCodeBlock    '\(\s\{4,}\|\t\{1,}\).*\n' contained nextgroup=pdcCodeBlock
" syn region pdcCodeBlock     start='^\~\{3,}.*$'hs=s+3 end='^\~\{3,}.*$'he=e-3

" New code block def
syn region pdcCodeBlock   start=/\(\(\d\|\a\|*\).*\n\)\@<!\(^\(\s\{4,}\|\t\+\)\).*\n/ end=/.\(\n^\s*\n\)\@=/

" Delimited Code Blocks:
syn region pdcDelimitedCodeBlock start=/^\z(\~\{3,}\~*\)\( {.\+}\)*/ end=/\z1\~*/ skipnl contains=pdcDelimitedCodeBlockLanguage
syn match pdcDelimitedCodeBlockLanguage /{.\+}/ contained containedin=pdcDelimitedCodeBlock

syn match pdcLeadingBlank '^\(\s\{11}\|\s\{7}\|\s\{3}\)\zs\s\ze' containedin=ALL
" }}}

" List:
" All Lists {{{1
" Lists : Xell Simple version {{{2
" syn match pdcList '^\s*[-+*]\s\S'me=e-1
" syn match pdcList '^\s*[1-9a-z]\(\.\|)\)\s\S'me=e-1
" syn match pdcList '^\s*(@)\s\S'me=e-1
" hi link pdcList   Statement
"}}}
" Normal Lists {{{2
syn match pdcListCont /\s*[^-+*].*\n/ contained nextgroup=pdcListCont,pdcListItem,pdcListSkipNL transparent

"   Skip empty lines
syn match pdcListSkipNL /\s*\n/ contained nextgroup=pdcListItem,pdcListSkipNL

"   Unorder list
syn match  pdcListItem /\s*[-*+]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl

"   Order list, numeric
syn match  pdcListItem  /\s*(\?\(\d\+\|#\)[\.)]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl

"   Order list, roman numerals (does not guarantee correct roman numerals)
syn match  pdcListItem  /\s*(\?[ivxlcdm]\+[\.)]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl

"   Order list, lowercase letters
syn match  pdcListItem  /\s*(\?\l[\.)]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl

"   Order list, uppercase letters, does not include '.'
syn match  pdcListItem  /\s*(\?\u[\)]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl

"   Order list, uppercase letters, special case using '.' and two or more spaces
syn match  pdcListItem  /\s*\u\.\([ ]\{2,}\|\t\+\)/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl

"  Numbered Example list (doesn't handle hyphens or underscores in labels)
syn match  pdcListItem  /\s*(\?@\a*[\.)]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl
" }}}
" Definitions {{{2

syn match pdcDefinitionBlock /^.*\n\(^\s*\n\)*\s\{0,2}[:~]\(\s\{1,3}\|\t\).*\n\(\(^\s\{4,}\|^\t\).*\n\)*/ skipnl contains=pdcDefinitionBlockTerm,pdcDefinitionBlockMark,pdcEmphasis,pdcStrong,pdcStrike,pdcSubscript,pdcSuperscript,@Spell
syn match pdcDefinitionBlockTerm /^.*\n\(^\s*\n\)*\(\s*[:~]\)\@=/ contained containedin=pdcDefinitionBlock contains=pdcEmphasis
syn match pdcDefinitionBlockMark /^\s*[:~]/ contained containedin=pdcDefinitionBlock
" }}}
" }}}

" Link:
" Links and footnote {{{1

" [LinkText] or [LinkText] [ID]
syn match pdcLinkText /\[[^]]\+\]\(\s\?\[[^]]\+\]\)\?/ contains=@Spell,pdcLinkLeft,pdcLinkRight
syn match pdcLinkLeft /\[/ contained conceal
syn match pdcLinkRight /\]/ contained conceal

" [LinkText](url)
" syn match pdcLinkTextInLine /\[[^]]\+\]([^)]\+)/ contains=@Spell,pdcLinkURLInLine
" syn match pdcLinkURLInLine /\zs([^)]\+)\ze/ contained conceal
" syn match pdcLinkTextInLine '\(\[[^]]\+\]\)(\([^ ]\+\%(\s"[^"]\+"\)\?\))' contains=pdcLinkURLInLine
" syn match pdcLinkURLInLine '\]\zs(\([^ ]\+\%(\s"[^"]\+"\)\?\))\ze' contained conceal
syn match pdcLinkTextInLine '\(\[[^]]\+\]\)(\([^ ]\{-}\%(\s"[^"]\{-}"\)\?\))' contains=pdcLinkURLInLine
syn match pdcLinkURLInLine '\]\zs(\([^ ]\{-}\%(\s"[^"]\{-}"\)\?\))\ze' contained conceal

" ![Figure]
syn match pdcFigure '^\s*\zs!\ze\['

" [LinkRef]: http...
syn match pdcLinkRef '^\s*\[[^]]\+\]:\s\+\S.*$'

" Footnote
syn match pdcFootnoteID /\[\^[^\]]\+\]/ nextgroup=pdcFootnoteDef
" syn region pdcFootnoteDef  start=/:/ end=/^\n\+\(\(\t\+\|[ ]\{4,}\)\S\)\@!/ contained contains=pdcFootnoteDef
syn region pdcFootnoteDef matchgroup=pdcFootnoteID start=/\^\[/ matchgroup=pdcFootnoteID end=/\]/ oneline

" }}}

" Other:
" Quote, HRule and Newline {{{1
" > ...
syn match pdcBlockquote	    /\s*>.*$/  nextgroup=pdcBlockquote,pdcBlockquote2 contained skipnl
syn match pdcBlockquote2    /[^>].*/  nextgroup=pdcBlockquote2 skipnl contained

" 3 or more * on a line
syn match pdcHRule  /\s\{0,3}\(-\s*\)\{3,}\n/	contained nextgroup=pdcHRule
" 3 or more - on a line
syn match pdcHRule  /\s\{0,3}\(\*\s*\)\{3,}\n/	contained nextgroup=pdcHRule

" Newline
" syn match pdcNewLine '  $'
syn match pdcNewLine /\(  \|\\\)$/

" Table TODO

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlights: 
" Highlights {{{1
hi link pdcAtxHeader Title
hi link pdcSetexHeader Title
hi link pdcSetexHeader Title
hi link pdcEmphasis VisualNOS
" hi pdcEmphasis gui=bold,underline
hi link pdcStrong Special
hi link pdcStrike Temp
hi link pdcSubscript		Special
hi link pdcSuperscript		Special
hi link pdcCode     PreProc

hi pdcLeadingBlank guifg=#31465B gui=Underline
hi link pdcCodeBlock String
hi link pdcDelimitedCodeBlock String
hi link pdcDelimitedCodeBlockLanguage Comment
hi link pdcCodePre String

hi link pdcLinkRef Comment
hi link pdcLinkText		Identifier
hi link pdcLinkTextInLine Identifier
hi link pdcFootnoteID		Underlined
hi link pdcFootnoteDef		Comment

hi link pdcFigure WildMenu

hi link pdcTitleBlock	String

hi link pdcBlockquote	    	Comment
hi link pdcBlockquote2	    	Comment

hi link pdcHRule		Underlined

hi link pdcNewLine  Pmenu

hi link pdcHTMLComment Comment

hi link pdcListItem   Statement

hi link pdcDefinitionBlockTerm Identifier
hi link pdcDefinitionBlockMark Operator
" }}}

let b:current_syntax = "pandoc"
