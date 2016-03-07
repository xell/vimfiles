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
au! BufNewFile,BufRead *.mdindex setf mdindex
" applescript
au! BufNewFile,BufRead *.applescript 	setf applescript
" mediawiki
au BufRead,BufNewFile *.wiki                setf mediawiki
au BufRead,BufNewFile *.wikipedia.org*      setf mediawiki
au BufRead,BufNewFile *.wikibooks.org*      setf mediawiki
au BufRead,BufNewFile *.wikimedia.org*      setf mediawiki
" todo.txt
au BufRead,BufNewFile todo.txt          setf todotxt
" hostlist
au BufRead,BufNewFile *.hostslist       setf hostslist
augroup END

