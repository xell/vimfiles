" let files = []
" let files = glob("/Volumes/photo/photos/1304_huazhaojie/DSC*.*", 0, 1)
" for file in files
" 	let filedate = system('stat -f "%Sm" -t "2013%m%d%H%M.%S" ' . file)
" 	let filedate = substitute(filedate, '\n', '', 'g')
" 	call system('touch -t ' . filedate . ' ' . file)
" 	" echo 'touch -mt ' . filedate . ' ' . file
" 	" touch -mt 201304131456.14 DSC00686.JPG
" endfor
