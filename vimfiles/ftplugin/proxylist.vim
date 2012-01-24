setlocal comments=:#

command! -buffer -nargs=0 Apply silent call <SID>convert_proxy()

nmap <buffer> <Leader>; :TToC ^##\s.*$<CR>

let b:search_pattern = '\%(^<[^>]\+>\)' . '\|' . '\%(\s*\zs[^ ]\+\ze\s*|\)' . '\|' . '\%(|\zs.*\ze$\)'
nmap <buffer> <Tab> :call xelltoolkit#goto_next_word(b:search_pattern)<CR>
nmap <buffer> <S-Tab> :call xelltoolkit#goto_pre_word(b:search_pattern)<CR>


" convert xell.proxylist to proxylist.pac {{{
function! s:convert_proxy()
	let list_file = g:proxy_list
	let pac_file = g:proxy_pac

	let proxylist = readfile(list_file)
	let pac = ["function FindProxyForURL(url, host) {"]

	let conv_target = ''
	let conv_proxies = {}
	let conv_lists = []

	" read xell.proxylist and fetch the info
	for item in proxylist
		if item =~ '^@'
			let conv_target = strpart(item, 2)
		elseif item =~ '^!'
			let conv_proxies[matchstr(item, '^!\s\zs[^ ]\+\ze')] = matchstr(item, "'\\zs[^']\\+\\ze'")
		elseif item =~ '^<'
			call add(conv_lists, [matchstr(item, '^<[^>]\+>\s\+\zs[^ ]\+\ze'), matchstr(item, '\s\+|\zs[^ ]\+\ze')])
		endif
	endfor

	" write head of proxylist.pac
	call extend(pac, ["", "var url = url.toLowerCase();", "var host = host.toLowerCase();", "if (isPlainHostName(host)) return 'DIRECT';"])

	" write proxies of proxylist.pac
	for proxy in keys(conv_proxies)
		call add(pac, "var " . proxy . " = '" . conv_proxies[proxy] . "';")
	endfor

	call add(pac, '')

	" write rules of proxylist.pac
	for proxylist in conv_lists
		call add(pac, "if (shExpMatch(url, '" . proxylist[0] . "')) return " . proxylist[1])
	endfor

	" write footer of proxylist.pac
	call extend(pac,['', 'return ''DIRECT''', '}'])

	call writefile(pac, pac_file)

endfunction
" }}}
