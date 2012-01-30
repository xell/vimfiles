if exists('g:loaded_xell_tempfile')
	finish
endif
let g:loaded_xell_tempfile = 1

if !exists("g:XellTemporaryFiles")
	let g:XellTemporaryFiles = []
endif

function! XellWriteFiles()
	try
		write
	catch /^Vim\%((\a\+)\)\=:E32/	" catch error E32 No file name
		let tempfilename = tempname()
		call add(g:XellTemporaryFiles, tempfilename)
		execute 'write ' . tempfilename
		echo "Write to a temporary file."
	endtry
endfunction

function! XellDeleteTempFiles()
	for tempfile in g:XellTemporaryFiles
		"echo tempfile
		call delete(tempfile)
	endfor
endfunction

