" MacVim colorscheme color file
" Author: Xell Liu <xell.liu@gmail.com>

" Pre: {{{
highlight clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "xell_dark"
" }}}

" Function: {{{
" guifg guibg guisp = bg/fg/NONE/colorname/#rrggbb *highlight-guifg* *gui-colors* *macvim-colors*
" gui = bold/underline/undercurl/reverse/italic/standout/nocombine/NONE *highlight-gui* *attr-list*
" ctermfg ctermbg = color-nr *highlight-ctermfg* *cterm-colors*
function! LinkHighlight(from, to)
  exec 'highlight! link' a:from a:to
endfunction
function! AddHighlight(group, guifg, ...)
    if a:0 == 0
        exec 'highlight ' . a:group . ' guifg=' . a:guifg . ' guibg=bg'
    elseif a:0 == 1
        exec 'highlight ' . a:group . ' guifg=' . a:guifg . ' guibg=' . a:1
    elseif a:0 == 2
        exec 'highlight ' . a:group . ' guifg=' . a:guifg . ' guibg=' . a:1 . ' gui=' . a:2
    elseif a:0 == 3
        exec 'highlight ' . a:group . ' guifg=' . a:guifg . ' guibg=' . a:1 . ' gui=' . a:2 . ' guisp=' . a:3
    endif
endfunction
" }}}

" Constants: {{{
" Take from Safari reading mode, [dark, gray, brown]
let none = 'NONE'
let bold = 'bold' | let italic = 'italic' | let reverse = 'reverse'
let underline = 'underline' | let undercurl = 'undercurl'
let white = 'White' | let black = 'Black'

let fg = ['#B0B0B0', '#D7D7D8'][0]
let bg = ['#121212', '#4A4A4D'][1]
let bg = '#262626'
let gray = ['#1C1C1E', '#2C2C2E', '#48484A', '#8E8E93', '#98989D']

let blue = ['#0A84FF', '#5E9EF8'] 
let green = ['#30D158', '#88DB7F']
let indigo = ['#5856D6', '#5E5CE6']
let orange = ['#F56F2A', '#FF9F0A', '#F4B463', '#744605']
let orange = ['#F56F2A', '#FF9F0A', '#F4B463', '#9f5d00']
let pink = '#FF375F'
let purple = ['#BF5AF2', '#C183EE']
let red = ['#FF453A', '#EF766A']
let teal = '#64D2FF'
let yellow = ['#FFD60A', '#FADE6E']
" }}}

" Definitions: {{{
" General:
call AddHighlight('Normal', fg, bg)
" call AddHighlight('Normal', 'MacTextColor', 'MacTextBackgroundColor', 'NONE')
call AddHighlight('NonText', gray[2], bg)

" Vim: Specific
call AddHighlight('MoreMsg', orange[1], none, bold)
call AddHighlight('Search', black, orange[0], none)
call AddHighlight('IncSearch', none, none, reverse)

call AddHighlight('LineNr', gray[3], bg)
call AddHighlight('Cursor', bg, fg)
call AddHighlight('CursorLineNr', none, gray[1], bold)
call AddHighlight('CursorLine', none, gray[1])
call AddHighlight('CursorColumn', none, gray[1])
call AddHighlight('CursorIM', none, red[0])
call AddHighlight('ColorColumn', white, gray[2])
call AddHighlight('StatusLine', white, gray[2], none)
call AddHighlight('StatusLineNC', fg, gray[1], none)
call AddHighlight('VertSplit', gray[1], gray[1], none)
call AddHighlight('TabLineSel', white, gray[2], none)
call AddHighlight('TabLine', none, gray[1], none)
call AddHighlight('TabLineFill', none, gray[1], none)

" Real Elements:
call AddHighlight('Title', green[1], bg, none)
call LinkHighlight('Folded', 'Title')
call AddHighlight('FoldColumn', gray[2], bg)
call AddHighlight('Directory', blue[1], none)
call AddHighlight('Question', green[0], bg, bold)
call AddHighlight('SpellBad', fg, bg, undercurl, red[0])
call AddHighlight('SpellCap', fg, bg, undercurl, blue[0])
call AddHighlight('SpellRare', fg, bg, undercurl, red[1])
call AddHighlight('SpellLocal', fg, bg, undercurl, teal)
call AddHighlight('SpecialKey', pink, bg, italic)
call AddHighlight('WarningMsg', red[1], bg)
call AddHighlight('WildMenu', black, yellow[0], bold)
call AddHighlight('Pmenu', fg, gray[1])
call LinkHighlight('PmenuSel', 'WildMenu')
call AddHighlight('PmenuSbar', fg, fg) "TODO
call AddHighlight('PmenuThumb', gray[1], fg) "TODO
call AddHighlight('SignColumn', pink, bg) "TODO
call LinkHighlight('Conceal', 'NonText')
call AddHighlight('MatchParen', none, none, reverse)
call AddHighlight('DiffAdd', black, green[1])
call AddHighlight('DiffChange', black, purple[1])
call AddHighlight('DiffDelete', black, red[1])
call AddHighlight('DiffText', white, red[0])

" Programming: *W18*
call AddHighlight('Comment', gray[2], none, bold) "FIXME
call AddHighlight('Constant', green[0], none)
call AddHighlight('Identifier', blue[1], none)
call AddHighlight('Underlined', blue[1], none, underline, blue[1])
call AddHighlight('Statement', yellow[1], none)
call AddHighlight('PreProc', purple[1], none) "FIXME
call AddHighlight('Type', orange[2], none, none)
call AddHighlight('Special', pink, none)
call AddHighlight('Ignore', gray[1], none)
call AddHighlight('Error', white, red[0])
call AddHighlight('ErrorMsg', red[0], bg)
" call AddHighlight('Todo', white, orange[3], bold)
call AddHighlight('Todo', orange[0], bg, undercurl, orange[0])

" Visual:
" Change the selection color on focus change (but only if the "macvim"
" colorscheme is active).
call AddHighlight('Visual', none, 'MacSelectedTextBackgroundColor' )
if has("gui_macvim") && !exists("s:augroups_defined")
  au FocusLost * if exists("colors_name") && colors_name == "xell_dark" | hi Visual guibg=MacSecondarySelectedControlColor | endif
  au FocusGained * if exists("colors_name") && colors_name == "xell_dark" | hi Visual guibg=MacSelectedTextBackgroundColor | endif

  let s:augroups_defined = 1
endif
" }}}

" Other: {{{
" Transparency and blur only for MacVim GUI
if &term == 'builtin_gui'
    set transparency=3
    set blurradius=100
endif
set guifont=Sarasa\ Mono\ T\ SC\ Extralight:h16
set guifontwide=PingFang\ SC\ Thin:h16
" }}}
