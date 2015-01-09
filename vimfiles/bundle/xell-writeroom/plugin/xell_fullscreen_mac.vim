if has('gui_running')
	finish
endif

if !exists("g:Fullscreen_Enabled")
	let g:Fullscreen_Enabled = 0
endif

function! FullScreenToggle()
  if !g:Fullscreen_Enabled
    " Save the window position and size when running Windows, because my
    " dynamic link library doesn't save/restore them.
      let [s:lines_save, s:columns_save] = [&lines, &columns]
      let [s:winpos_x_save, s:winpos_y_save] = [getwinposx(), getwinposy()]
    " Hide the main menu, tool bar and/or tab line. Remember what was hidden
    " so its visibility can be restored when the user leaves full-screen.
    set fullscreen
    let g:Fullscreen_Enabled = !g:Fullscreen_Enabled
	return
  endif

  if g:Fullscreen_Enabled
	set nofullscreen
    let g:Fullscreen_Enabled = !g:Fullscreen_Enabled
    " Restore display of previously hidden GUI components?
    " Restore window position and size only on Windows.
    let [&lines, &columns] = [s:lines_save, s:columns_save]
    execute 'winpos' s:winpos_x_save s:winpos_y_save
    unlet s:lines_save s:columns_save s:winpos_x_save s:winpos_y_save
    sleep 50 m
	return
  endif
endfunction
