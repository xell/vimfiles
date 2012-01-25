" Thanks to http://www.vim.org/scripts/script.php?script_id=3123
" And http://www.vim.org/scripts/script.php?script_id=2596
if !(g:isw && has('gui_running'))
	finish
endif

let s:fullscreen_dll = expand("<sfile>:p:h") . '\gvimfullscreen.dll'

if !exists("g:Fullscreen_Enabled")
	let g:Fullscreen_Enabled = 0
endif
if !exists("g:shell_fullscreen_items")
	let g:shell_fullscreen_items = 'mTe'
endif


function! FullScreenToggle()
  if !g:Fullscreen_Enabled
    " Save the window position and size when running Windows, because my
    " dynamic link library doesn't save/restore them.
      let [s:lines_save, s:columns_save] = [&lines, &columns]
      let [s:winpos_x_save, s:winpos_y_save] = [getwinposx(), getwinposy()]
    " Hide the main menu, tool bar and/or tab line. Remember what was hidden
    " so its visibility can be restored when the user leaves full-screen.
    let s:go_toggled = ''
    for item in split(g:shell_fullscreen_items, '.\zs')
      if &go =~# item
        let s:go_toggled .= item
        execute 'set go-=' . item
      endif
    endfor
    if g:shell_fullscreen_items =~# 'e' && &stal != 0
      let s:stal_save = &stal
      set showtabline=0
    endif
    call libcallnr(s:fullscreen_dll, "ToggleFullScreen", 0)
    let g:Fullscreen_Enabled = !g:Fullscreen_Enabled
	return
  endif

  if g:Fullscreen_Enabled
    call libcallnr(s:fullscreen_dll, "ToggleFullScreen", 0)
    let g:Fullscreen_Enabled = !g:Fullscreen_Enabled
    " Restore display of previously hidden GUI components?
    let &go .= s:go_toggled
    if exists('s:stal_save')
      let &stal = s:stal_save
      unlet s:stal_save
    endif
    unlet s:go_toggled
    " Restore window position and size only on Windows.
    let [&lines, &columns] = [s:lines_save, s:columns_save]
    execute 'winpos' s:winpos_x_save s:winpos_y_save
    unlet s:lines_save s:columns_save s:winpos_x_save s:winpos_y_save
    sleep 50 m
	return
  endif

endfunction
