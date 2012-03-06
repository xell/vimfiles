" User defined filetype detection file
" Maintainer: Xell Liu

augroup filetypedetect
" txt2tags file
au! BufRead,BufNewFile *.t2t 			setf txt2tags
" processing
au! BufRead,BufNewFile *.pde 			setf processing 
" srt subtitle
au! BufRead,BufNewFile *.srt 			setf srt
" markdown, suppressed by pandoc
" au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=markdown
au! BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.pd,*.pdk,*.pandoc,*.md setf pandoc
" noteindex c.f. xell_notes
au! BufNewFile,BufRead *.noteindex 		setf noteindex
" applescript
au! BufNewFile,BufRead *.applescript 	setf applescript
augroup END

