"nmap <buffer> <Leader>; :TToC ^;=\{3}\zs[^=].*\ze$<CR>
"nmap <buffer> <Leader>; :Voom ahk<CR>

" command! -buffer -nargs=* Run silent call xelltoolkit#system(g:ahk_exec . ' /r ' . expand('%:p') . ' <args>')
command! -buffer -nargs=0 Run exec 'silent !' . g:ahk_exec . ' /r ' . expand('%:p')

command! -buffer -nargs=0 Help silent call xelltoolkit#run('', g:ahk_help, 's')
