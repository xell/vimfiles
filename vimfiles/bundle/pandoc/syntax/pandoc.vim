" Vim syntax file
" Filename: pandoc.vim
" Language: Markdown
" Maintainer: Xell Liu
" Last change: 2012-02-01
" 
" This file is a mixture of Schultz's and Sanson's with heavy modification of
" mine.


" Initialization {{{1
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn case ignore
syn spell toplevel
if g:pandoc_syntax_accuracy
	" syn sync linebreaks=1
	" syn sync minlines=10
	syn sync fromstart
else
	syn sync minlines=10
	syn sync maxlines=50
endif
" }}}

" HTML and TeX {{{1
" 不能单单用下面这个，否则无法分辨小于号，语法高亮不正确
" runtime! syntax/html.vim

if exists('g:pandoc_syntax_full_html_tex') && g:pandoc_syntax_full_html_tex
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
	syn match pdcLatex	/\\\w\+{[^}]*}/	contains=@LATEX
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
	syn match pdcTEXMath '\$[^$]\+\$'
	hi link pdcTEXMath Special
endif

" }}}

" TitleBlock, Heading {{{1

" Title Block i.e. the first three lines headed with %
syn match pdcTitleBlock /^%.*\n\(\s\+.*\n\)\?/

" Heading Header
syn match pdcAtxHeader /^#\{1,6}\s.\+$/ contains=@Spell
syn match pdcSetexHeader /^.\+\n[=]\+$/ contains=@Spell
syn match pdcSetexHeader /^.\+\n[-]\+$/ contains=@Spell

" }}}

" Inline {{{1
" CriticMarkup
syn match pdcTempPPP '{[^}]\{-}}' containedin=ALLBUT,cmHighlight,cmHighlightLeft,cmHighlightRight
syn match   cmHighlight     '{==[^=].\{-}==}' contains=@Spell,cmHighlightLeft,cmHighlightRight
syn match   cmHighlightLeft '{==' contained conceal
syn match   cmHighlightRight '==}' contained conceal
" ~~strike~~
syn match   pdcStrike       '\~\~[^\~ ]\([^\~]\|\~ \)*\~\~' contains=@Spell,pdcStrikeFix
syn match   pdcStrikeFix    '\~' contained conceal
" **strong**
syn match   pdcStrong       '\*\*[^* ].\{-}\*\*' contains=@Spell,pdcStrongFix
" *emp*
syn match   pdcEmphasis     '\*[^* ].\{-}\*' contains=@Spell,pdcStrongFix
syn match   pdcStrongFix    '\*' contained conceal
" Subscripts ~a~
syn match   pdcSubscript    '\~[^\~ ].\{-}\~' contains=@Spell
" Superscript ^A^
syn match   pdcSuperscript  '\^[^\^ ].\{-}\^' contains=@Spell

" }}}

" Code {{{1
" The blanks in front of any four-spaces indented group
syn match pdcLeadingBlank '^\(\s\{11}\|\s\{7}\|\s\{3}\)\zs\s\ze' containedin=ALL

" Inline codes
syn region pdcCode start=/`\S/ end=/`\|^\s*$/ oneline
syn region pdcCode start=/``[^`]*/ end=/``\|^\s*$/ oneline
syn match  pdcCodePre /<pre>.\{-}<\/pre>/
syn match  pdcCodePre /<code>.\{-}<\/code>/

" Code blocks
syn match pdcCodeBlock '^\s\{4,}.*$' contains=pdcListItem

" Delimited Code Blocks
syn region pdcDelimitedCodeBlock start=/^\z(\~\{3,}\~*\)\( {.\+}\)*/ end=/\z1\~*/ skipnl contains=pdcDelimitedCodeBlockLanguage
syn match pdcDelimitedCodeBlockLanguage /{.\+}/ contained containedin=pdcDelimitedCodeBlock
" }}}

" Lists {{{1
" Normal lists
syn match pdcListItem '^\s*[-+*]\s\+\S'me=e-1 contained
syn match pdcListItem '^\s*[#0-9a-zA-Z]\+\(\.\|)\)\s\+\S'me=e-1 contained
syn match pdcListItem '^\s*(@\a*)\s\+\S'me=e-1 contained
syn match pdcListItem '^\s*[-+*]\s\+\S'me=e-1
syn match pdcListItem '^\s*[#0-9a-zA-Z]\+\(\.\|)\)\s\+\S'me=e-1
syn match pdcListItem '^\s*(@\a*)\s\+\S'me=e-1

" Definitions
syn match pdcDefinitionBlock /^.*\n\(^\s*\n\)*\s\{0,2}[:~]\(\s\{1,3}\|\t\).*\n\(\(^\s\{4,}\|^\t\).*\n\)*/ skipnl contains=pdcDefinitionBlockTerm,pdcDefinitionBlockMark,pdcEmphasis,pdcStrong,pdcStrike,pdcSubscript,pdcSuperscript,@Spell
syn match pdcDefinitionBlockTerm /^.*\n\(^\s*\n\)*\(\s*[:~]\)\@=/ contained containedin=pdcDefinitionBlock contains=pdcEmphasis
syn match pdcDefinitionBlockMark /^\s*[:~]/ contained containedin=pdcDefinitionBlock
" }}}

" Links {{{1
" [LinkText] or [LinkText] [ID] ==================================
syn match pdcLinkText /\[.\{-}\]\%(\s\?\[.\{-}\]\)\?/ contains=@Spell,pdcLinkSE
syn match pdcLinkSE /\[\|\]/ contained conceal

" [LinkText](url) ================================================
syn match pdcLinkTextInLine '\[.\{-}\](\@='
syn match pdcLinkURLInLine '\]\@<=(.\{-})' conceal

" ![Figure] =====================================================
syn match pdcFigure '!\[\@='

" [LinkRef]: http... ============================================
syn match pdcLinkRef '^\s*\[.\{-}\]:\s\+\S.*$'

" Footnote ======================================================
syn match pdcFootnoteID /\[\^[^\]]\+\]/ nextgroup=pdcFootnoteDef
syn region pdcFootnoteDef matchgroup=pdcFootnoteID start=/\^\[/ matchgroup=pdcFootnoteID end=/\]/ oneline

" }}}

" Others {{{1
" Quotes
syn match pdcBlockQuote '^\s*>.*$'

" 3 or more * on a line
syn match pdcHRule  /\s\{0,3}\(-\s*\)\{3,}\n/
" 3 or more - on a line
syn match pdcHRule  /\s\{0,3}\(\*\s*\)\{3,}\n/
" Newline
syn match pdcNewLine /\(  \|\\\)$/
" }}}

" Tables {{{1
" Caution: pdcBlankLine will dramatically slow down vim.
if exists('g:pandoc_syntax_table') && g:pandoc_syntax_table
	syn match pdcBlankLine '^\s*\n' nextgroup=pdcTableHeader,pdcTableMultiStart transparent
	" Regular Table
	syn match pdcTableHeader /\s*\S\+\(\s\+\S\+\)\+\s*\n\s*-\+\(\s\+-\+\)\+\s*\n/ contained nextgroup=pdcTableBody
	syn match pdcTableBody	 /\s*\S\+\(\s\+\S\+\)\+\s*\n/ contained nextgroup=pdcTableBody,pdcTableCaption skipnl
	syn match pdcTableCaption /\n\+\s*Table.*\n/ contained nextgroup=pdcTableCaptionCont 
	syn match pdcTableCaptionCont /\s*\S.\+\n/ contained nextgroup=pdcTableCaptionCont 

	" Multi-line Table
	syn match pdcTableMultiStart /^\s\{0,3}-\+\s*\n\ze\(\s*\S\+\(\s\+\S\+\)\+\s*\n\)\+\s*-\+\(\s\+-\+\)\+\s*\n/ contained nextgroup=pdcTableMultiHeader
	syn match pdcTableMultiEnd /^\s\{0,3}-\+/ contained nextgroup=pdcTableMultiCaption skipnl
	syn match pdcTableMultiHeader /\(\s*\S\+\(\s\+\S\+\)\+\s*\n\)\+\s*-\+\(\s\+-\+\)\+\s*\n/ contained nextgroup=pdcTableMultiBody 
	syn match pdcTableMultiBody /^\(\s\{3,}[^-]\|[^-\s]\).*$/ contained nextgroup=pdcTableMultiBody,pdcTableMultiSkipNL,pdcTableMultiEnd skipnl
	syn match pdcTableMultiSkipNL /^\s*\n/ contained nextgroup=pdcTableMultiBody,pdcTableMultiEnd skipnl
	syn match pdcTableMultiCaption /\n*\s*Table.*\n/ contained nextgroup=pdcTableCaptionCont 

	" TODO Grid table c.f. rst syntax
endif
" }}}

" ===============================================
" Highlights {{{1

hi default link pdcHTMLComment Comment

hi default link pdcTitleBlock String
hi default link pdcAtxHeader Title
hi default link pdcSetexHeader Title


hi default link cmHighlight Temp
hi default link pdcStrike Temp
hi default link pdcStrong Special
hi default link pdcEmphasis VisualNOS
hi default link pdcSubscript Special
hi default link pdcSuperscript Special

if &background == 'dark'
	hi pdcLeadingBlank guifg=#31465B gui=Underline
else
	hi pdcLeadingBlank guifg=#bccfd7 gui=Underline
endif
hi default link pdcCode PreProc
hi default link pdcCodePre String
hi default link pdcCodeBlock String
hi default link pdcDelimitedCodeBlock String
hi default link pdcDelimitedCodeBlockLanguage Comment

hi default link pdcListItem Statement
hi default link pdcDefinitionBlockTerm Identifier
hi default link pdcDefinitionBlockMark Operator

hi default link pdcLinkText Identifier
hi default link pdcLinkTextInLine Identifier
hi default link pdcFigure WildMenu
hi default link pdcLinkRef Comment
hi default link pdcFootnoteID Underlined
hi default link pdcFootnoteDef Comment

hi default link pdcBlockQuote Comment
hi default link pdcHRule Underlined
hi default link pdcNewLine Pmenu

hi default link pdcTableMultiStart Comment
hi default link pdcTableMultiEnd Comment
hi default link pdcTableHeader Define
hi default link pdcTableMultiHeader Define
hi default link pdcTableBody Identifier
hi default link pdcTableMultiBody Identifier
hi default link pdcTableCaption Label
hi default link pdcTableMultiCaption Label
hi default link pdcTableCaptionCont Label
" }}}

" syn match pdcTempPPP '{[^}]\{-}}' containedin=ALLBUT,cmHighlight,cmHighlightLeft,cmHighlightRight
" syn match pdcTempPPP '{[^=][^=][^}]\{-}[^=][^=]}' containedin=ALL
" syn match pdcTempPPP '{[^=][^=][^}]\{-}[^=][^=]}' containedin=ALLBUT,cmHighlight
hi default link pdcTempPPP MoreMsg


let b:current_syntax = "pandoc"
