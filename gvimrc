""""""""""""""""""""""""""""""""""""""""""""""""""""" 
"
"  \  /
"   \/   |--  |    |
"   /\   |--  |    |
"  /  \  |--  |--  |--
"
" Maintainer: Xell Liu <xell DOT liu AT gmail.com>
" Note: For use font with Chinese name in Windows,
"       this file must be cp936 encoding.


" Popup confirmation window
set confirm

" Don't hide mouse, or the cursor will flash in the title
"set nomousehide

" Set colorscheme {{{1
"let g:zenburn_high_Contrast = 1
"let g:zenburn_color_also_Ignore = 1
"colorscheme zenburn
colorscheme xell_dark
" TODO
let g:colorschemes = ['xell_dark', 'xell_light_white', 'xell_light_green']
let g:colorschemes_index = 0
function! s:switch_colorschemes()
    let g:colorschemes_index += 1
    if g:colorschemes_index == len(g:colorschemes)
        let g:colorschemes_index = 0
    endif
    exec 'colorscheme ' . g:colorschemes[g:colorschemes_index]
endfunction
command! -nargs=0 SwitchColorschemes call <SID>switch_colorschemes()
nmap <F6> :SwitchColorschemes<CR>

" https://github.com/macvim-dev/macvim/pull/929
" TODO
function! ChangeBackground()
  if (v:os_appearance == 1)
    set background=dark
    colorscheme xell_dark
  else 
    set background=light
    colorscheme xell_light_white
  endif
  redraw!
endfunction

au OSAppearanceChanged * call ChangeBackground()

" }}}

" Guioptions {{{1
" e gui tabs
set guioptions=e
set guicursor=n-v-c:block-Cursor/lCursor-blinkwait700-blinkon1200-blinkoff250,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
set macthinstrokes
"}}}

" Screen size settings {{{1
" Initial sizes {{{2
" those size responding to font h:9
set lines=40
set columns=101
" }}}

" Change the window size incrementally {{{2
let g:increments = 3
function! ChangeWindowSizeV(incre, direction)
    let y = &lines
    let x = &columns
    if a:direction =~ "down"
        let y += a:incre
        execute 'set lines=' . y
    elseif a:direction =~ "up"
        let y -= a:incre
        execute 'set lines=' . y
    elseif a:direction =~ "left"
        let x -= a:incre
        execute 'set columns=' . x
    elseif a:direction =~ "right"
        let x += a:incre
        execute 'set columns=' . x
    endif
    "execute 'set lines=' . x
endfunction
nmap <C-A-Down> :call ChangeWindowSizeV(g:increments, "down")<CR>
nmap <C-A-Up> :call ChangeWindowSizeV(g:increments, "up")<CR>
nmap <C-A-Left> :call ChangeWindowSizeV(g:increments, "left")<CR>
nmap <C-A-Right> :call ChangeWindowSizeV(g:increments, "right")<CR>
" }}}

" Toggle between two sets of window sizes F1 F2 {{{2
" toggle between two window size, see F1
nmap <silent> <F2> :call <SID>sizeAndPositionOfWindowSmall()<CR>
if !exists("s:sizeandpositionofwindowsmall")
    let s:sizeandpositionofwindowsmall = 0
endif
function! s:sizeAndPositionOfWindowSmall()
    if !s:sizeandpositionofwindowsmall
        set lines=9
        set columns=101
        "winpos 50 60
        let s:sizeandpositionofwindowsmall = !s:sizeandpositionofwindowsmall
    else
        set lines=40
        set columns=101
        "winpos 66 103
        let s:sizeandpositionofwindowsmall = !s:sizeandpositionofwindowsmall
    endif
endfunction
" }}}
" }}}

" Set the guitablabel {{{1
set guitablabel=%{GuiTabLabel()}-%<%t
" set guitablabel=%{tabpagenr()}-%<%t
	  " %-0{minwid}.{maxwid}{item}
" see :h tabpage guitablabel
function! GuiTabLabel()
    let label = ''

    " Add a symble if one of the buffers in the tab page is modified
    let bufnrlist = tabpagebuflist(v:lnum)
    for bufnr in bufnrlist
        if getbufvar(bufnr, "&modified")
            " *✦★✷✸✹✍︎✎✎✍︎⚑⚐ 
            let label .= '⚑ '
            break
        endif
    endfor

    let label .= tabpagenr()

    " Append the number of windows in the tab page if more than one
    "" let wincount = tabpagewinnr(v:lnum, '$')
    "" if wincount > 1
    ""   let label .= wincount
    "" endif
    "" if label != ''
    ""   let label .= ' '
    "" endif

    " Append the buffer name
    " return label . bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
    return label
endfunction
" }}}

" Font setup {{{1
"---------------------------------------
" TODO 切换暗、亮时自动改变字体
let g:guifontsize = 16
let g:guifonts = [
            \ "Inconsolata",
            \ "Consolas",
            \ "Sarasa\\ Mono\\ T\\ SC\\ Extralight"]
let g:guifontwides = [
            \ "PingFang\\ SC\\ Thin",
            \ "Songti\\ SC",
            \ "Sarasa\\ Mono\\ T\\ SC\\ Extralight"]

function! s:get_current_font_size() "{{{2
    return matchstr(&guifont, ':h\zs\d\+\ze')
endfunction "}}}
function! s:get_font_names() "{{{2
    let guifont_name = matchstr(getfontname(), '\zs[^:]\+\ze:h')
    if !empty(&guifontwide)
        return [guifont_name, matchstr(&guifontwide, '\zs[^:]\+\ze:h')]
    else
        return [guifont_name, '']
    endif
endfunction "}}}

function! Set_current_font_size_and_lsp(size, lsp) "{{{2
    let [guifont_name, guifontwide_name] = s:get_font_names()
    exec "set guifont=" . escape(guifont_name, ' ') . ":h" . a:size
    if !empty(guifontwide_name)
        exec "set guifontwide=" . escape(guifontwide_name, ' ') . ":h" . a:size
    endif
    let g:guifontsize = a:size
    if a:lsp == -1
        exe "set linespace=" . float2nr(floor(a:size / 4))
    else
        exe "set linespace=" . a:lsp
    endif
endfunction "}}}
nmap <D--> :call Set_current_font_size_and_lsp(g:guifontsize - 1, -1)<CR>
nmap <D-=> :call Set_current_font_size_and_lsp(g:guifontsize + 1, -1)<CR>
function! Change_linespace(increase) "{{{2
    let cur_lsp = &lsp
    if a:increase
        let &lsp = cur_lsp + 1
    else
        let &lsp = cur_lsp - 1
    endif
endfunction "}}}
nmap <C-D--> :call Change_linespace(0)<CR>
nmap <C-D-=> :call Change_linespace(1)<CR>
command! -nargs=0 ResetFontSizeAndLinespace call Set_current_font_size_and_lsp(16, 4)

" TODO currently only for guifont=Sarasa && guifontwide=PingFang
let s:sarasa_weights=["Extralight", "Light", "", "Medium", "Bold"]
let s:pingfang_weights=["Thin", "Light", "Regular", "Medium", "Semibold"]
" let s:pingfang_weights=["Ultralight", "Thin", "Light", "Regular", "Medium", "Semibold"]
function! Change_current_font_weight(bang, is_next = 1) "{{{2
    if a:bang == 1
        call Setfont(2, 0, g:guifontsize, &linespace)
        return
    endif
    let current_font_name = s:get_font_names()[0]
    " detect unsupported font
    if current_font_name !~? "sarasa" || s:get_font_names()[1] !~? "pingfang"
        call xelltoolkit#echo_msg("Cannot support current font. Only Sarasa & PingFang temporarily.")
        return
    endif
    " get current weight index
    let current_font_weight = matchstr(current_font_name, '\s\zs[^ ]\+\ze$')
    if current_font_weight =~? "sc"
        let current_font_weight = ""
    endif
    let current_font_weight_index = index(s:sarasa_weights, current_font_weight)

    " get and set next/pre weight
    if a:is_next == 1
        " next weight index
        let new_font_weight_index = current_font_weight_index + 1
        if new_font_weight_index == len(s:sarasa_weights)
            let new_font_weight_index = 0
        endif
    else
        " previous weight index
        let new_font_weight_index = current_font_weight_index - 1
        if new_font_weight_index == -1
            let new_font_weight_index = len(s:sarasa_weights) - 1
        endif
    endif
    " set new weight
    let new_font_weight = s:sarasa_weights[new_font_weight_index]
    let sarasa = "Sarasa\\ Mono\\ T\\ SC"
    let pingfang = "PingFang\\ SC"
    if new_font_weight != ""
        let sarasa = sarasa . "\\ " . new_font_weight
    endif
    let pingfang = pingfang . "\\ " . s:pingfang_weights[new_font_weight_index]
    " set fonts
    exec 'set guifont=' . sarasa . ':h' . g:guifontsize
    exec 'set guifontwide=' . pingfang . ':h' . g:guifontsize
endfunction "}}}
" Usage: ! = reset; additional arg other than 1 = previous weight
command! -bang -nargs=? ChangeFontWeight call Change_current_font_weight(<bang>0, <f-args>)

" Setfont ResetFont SetFontProfile {{{
function! Setfont(gf_index, gfw_index, size, lsp)
    exec 'set guifont=' . g:guifonts[a:gf_index] . ':h' . a:size
    exec 'set guifontwide=' . g:guifontwides[a:gfw_index] . ':h' . a:size
    let g:guifontsize = a:size
    let &linespace=a:lsp
endfunction

function! s:setfont_profile(default)
    if a:default == 1
        call Setfont(2, 0, g:guifontsize, &linespace)
    elseif a:default == 2
        call Setfont(0, 1, g:guifontsize, &linespace)
    elseif a:default == 3
        call Setfont(1, 1, g:guifontsize, &linespace)
    else
        call xelltoolkit#echo_msg("Wrong profile!")
    endif
endfunction "}}}
call Setfont(2, 0, 16, 4)
command! -nargs=0 ResetFont call Setfont(2, 0, 16, 4)
command! -nargs=1 SetFontProfile call <SID>setfont_profile(<args>)

" Temp {{{
" Sarasa：Extralight, Light, Medium, Bold
" 下述三个英文字体，在与 Songti SC 搭配时齐平：Inconsolata、Consolas、YaHei\\ Mono
" 下述英文字体不再使用：mononoki, M+\\ 1m\\ light, 
" 下述四个英文字体会导致宽度变大：Roboto\\ Mono\\ Light, IBM\\ Plex\\ Mono\\ Light, Source\\ Code\\ Variable\\ ExtraLight, SF\\ Mono\\ Light

" exe "set linespace=" . float2nr(floor(g:guifontsize / 2))
" function! s:set_font_default_size_lsp(gf_index, gfw_index)
"     call Setfont(a:gf_index, a:gfw_index, g:guifontsize, &linespace)
" endfunction
" command! -nargs=+ SetFont call <SID>set_font_default_size_lsp(<f-args>)
" }}}

" }}}

" Xell Fullscreen and Writeroom {{{1
" TODO refine the code
let g:Fullscreen_Enabled = 0
let g:writeroomstarted = 0

nmap <silent> <F11> <Esc>:if !g:writeroomstarted \| call FullScreenToggle() \| else \| echo "WriteRoom mode. Please end it." \| endif<CR>
command! -nargs=0 WRS call WriteRoomStart()
command! -nargs=0 WRSNew call WriteRoomStart('new')
command! -nargs=0 WRE call WriteRoomEnd()
" }}}

" GUI menu {{{1

macm Edit.Font.Bigger key=<nop>
macm Edit.Font.Smaller key=<nop>

" Don't close the last tab with D-w {{{2
macm File.Close key=<nop>
nnoremap <silent> <D-w> <Esc>:tabclose<CR>
" }}}

" Temp Note(file) Saving {{{2
" As for :macm, must use in has("gui_macvim")
macm File.Save<Tab>:w key=<Nop>
nmap <D-s> :call TempNote()<CR>
imap <D-s> <Esc><D-s>a

macm Edit.Paste<Tab>"+gP key=<Nop>
" imap <D-v> <Esc>"+gpa
" nmap <D-v> "+gp

macm Edit.Find.Use\ Selection\ for\ Find  key=<Nop>
" }}}

" Find General {{{2
macm Edit.Find.Find\.\.\. key=<Nop>
nmap <D-f> :call <SID>find_general()<CR>

" Default -i; include only this filetype; no exclude TODO
function! s:find_general()
    let pattern = input('What to find: ')
    if pattern == ''
        call xelltoolkit#echo_msg('Empty inquery!')
        return
    endif

    let option = input('Ignore case? (Y/n)')


    if expand('%:p:h') =~? xelltoolkit#fname2pattern(g:xell_notes_root)
        let include = 'note'
    else
        let include = input('This filetype? (Y/n)')
        if include == ''
            let include = expand('%:e')
        else
            let include = ''
        endif
    endif

    call xelltoolkit#grep_in_lcd_r(option, include, pattern)

    cwindow

    if &ft == 'qf'
        exec 'match ErrorMsg /\c' . pattern . '/'
    endif
endfunction
" }}}

" }}}

" Modelines {{{1
" vim:fmr={{{,}}}:fdm=marker:foldcolumn=3:lbr:fileencoding=utf-8:ff=unix
