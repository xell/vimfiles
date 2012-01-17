""""""""""""""""""""""""""""""""""""""""""""""""""""" 
"
"  \  /
"   \/   |--  |    |
"   /\   |--  |    |
"  /  \  |--  |--  |--
"
" Maintainer: Xell Liu <xell DOT liu AT gmail.com>


" Pre {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""" 

" Use third-part macro to track the startup time {{{2
"let g:startup_profile_csv = 'd:/p/vim-new/vim73/vim_startup_log.csv'
"runtime macros/startup_profile.vim
" }}}

set nocompatible

" System specified g:isw g:ism {{{2
" TODO i don't know how to detect vim terminal in mac
let g:isw = 0
let g:ism = 0
if has("win32") || has("win64")
	let g:isw = 1
else
	let g:ism = 1
endif
" }}}

" Temp {{{2
" XXX need to be deleted after re-constructed
if g:isw
	let g:myvim_dir = 'V:'
else
	let g:myvim_dir = '/Users/xell/Z/testvimfiles'
endif
let g:myvimfiles = g:myvim_dir . '/vimfiles'
let g:myvimfiles_after = g:myvimfiles . '/after'
" $VIM win: d:\p\vim
"      mac: /Applications/MacVim.app/Contents/Resources/vim
" $VRT win: d:\p\vim\vim73
"      mac: /Applications/MacVim.app/Contents/Resources/vim/runtime
" BIN  win: d:\p\vim\vim73\gvim.exe vim.exe
"      mac: /Applications/MacVim.app/Contents/MacOS/MacVim Vim
exec 'set runtimepath=' . g:myvimfiles . ',$VIMRUNTIME,' . g:myvimfiles_after
let $MYVIMRC = g:myvim_dir . '/vimrc'
let $MYGVIMRC = g:myvim_dir . '/gvimrc'
" }}}

" }}}

" Modelines {{{1
" vim:fmr={{{,}}}:fdm=marker:foldcolumn=3:lbr:fileencoding=gbk:ff=unix
