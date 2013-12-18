nmap <Leader><Leader><Leader> :call TestFFS()<CR>
let g:ffs_forbiden_path = ['/Users/xell', '/Users/xell/Library', '/Users/xell/Codes', '/Applications', '/Library', '/P', '/P/apps']

function! TestFFS()
	let t:ffs_start_path = expand("%:p:h")
	for forbiden_path in g:ffs_forbiden_path
		if t:ffs_start_path ==? forbiden_path
			call xelltoolkit#echo_msg("You cannot perform recursive, non-restrict ack in " . forbiden_path)
			return
		endif
	endfor
	topleft new
	silent! file ffs
	resize 1
	set filetype=ffs
	startinsert
	call feedkeys("\<C-x>\<C-o>\<C-p>", 'n')
endfunction

" au BufEnter * if &ft ==# 'xml' | commands | endif

" Delete file from disk
" c.f. http://vim.wikia.com/wiki/Delete_files_with_a_Vim_command
function! DeleteFile(...)
  if(exists('a:1'))
    let theFile=a:1
  elseif ( &ft == 'help' )
    echohl Error
    echo "Cannot delete a help buffer!"
    echohl None
    return -1
  else
    let theFile=expand('%:p')
  endif
  let delStatus=delete(theFile)
  if(delStatus == 0)
    echo "Deleted " . theFile
  else
    echohl WarningMsg
    echo "Failed to delete " . theFile
    echohl None
  endif
  return delStatus
endfunction
"delete the current file
com! Rm call DeleteFile()
"delete the file and quit the buffer (quits vim if this was the last file)
com! RM call DeleteFile() <Bar> bd!
