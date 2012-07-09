
" Settings {{{
setlocal tabstop=2
setlocal softtabstop=2
setlocal expandtab
"}}}

" Convert {{{
" command! -buffer -nargs=0 Apply silent call <SID>convert()
command! -buffer -nargs=0 Apply call <SID>convert()
" command! -buffer -nargs=0 Apply silent call <SID>convert(expand('%'))

function! s:get_subdomain_level(line) "{{{
	let str = strpart(a:line, 4)
	return strlen(matchstr(str, '^\s\+')) / 2
endfunction
"}}}

function! s:process(file) "{{{
	
	" Dict to store ips defined by '!xxxx=1.1.1.1'
	let ips = {}

	" Six elements to store the domain and subdomian
	let hosts = [[] ,[] ,[] ,[] ,[] ,[]]

	" Final result
	let result = []

	let filelist = readfile(a:file)

	for line in filelist

		" Test
		if line =~? '^\*$'
			break
		endif

		" Comments
		if line =~? '^\s*#' || line =~? '^\s*$'
			continue
		endif

		" Extract ips name
		if line  =~? '^!'
			let ip_name = matchstr(line, '!\zs[^ ]\+\ze=')
			if !has_key(ips, ip_name)
				let ips[ip_name] = matchstr(line, '=\zs\(\d\+\.\)\{3}\d\+\ze')
			endif
			continue
		endif

		" Extract raw hosts line
		if line =~? '^\s*\d\+\.\d\+\.\d\+\.\d\+\s\+\w'
			call add(result, line)
			continue
		endif

		" Extract hosts

		" First, check if it's not include (by # in the end)
		if line =~? '\s#$'
			let is_included = 0
		else
			let is_included = 1
		endif

		" Second, collect the info

		" Get the level
		let level_num = s:get_subdomain_level(line)

		" Determine if it's specified single ip
		if level_num == 1
			let ip_name_base = strpart(line, 0, 4)
			if !has_key(ips, ip_name_base)
				call xelltoolkit#echo_msg('Wrong ip name: ' . ip_name_base)
				return
			endif
			let ip_name_single = ''
		else
			if line =~? '^[^ ]\+'
				let ip_name_single = strpart(line, 0, 4)
				if !has_key(ips, ip_name_single)
					call xelltoolkit#echo_msg('Wrong ip name: ' . ip_name_single)
					return
				endif
			else
				let ip_name_single = ''
			endif
		endif


		" Process hosts part, save into hosts[]
		let hosts_list = matchstr(line, '\s\s\zs[^ ]\+\ze')
		let hosts[level_num - 1] = []
		if hosts_list =~? ';'
			" Multiple items joined by ;
			let hosts_list .= ';'
			while (1)
				let hosts_list_temp = matchstr(hosts_list, '\zs[^ ]\{-}\ze;')
				if hosts_list_temp != ''
					call add(hosts[level_num - 1], hosts_list_temp)
					let hosts_list = substitute(hosts_list, '[^ ]\{-};', '', '')
				else
					break
				endif
			endwhile
		elseif hosts_list =~? '\['
			" Multiple items expressed by range
			let hosts_list_temp_prefix = matchstr(hosts_list, '^\zs[^ ]\+\ze\[')
			let hosts_list_temp_suffix = matchstr(hosts_list, '\]\zs[^ ]\+\ze')
			let range_start = matchstr(hosts_list, '\[\zs\w\+\ze-')
			let range_end = matchstr(hosts_list, '\[\w\+-\zs\w\+\ze\]')

			if range_start =~? '\d'
				for i in range(str2nr(range_start), str2nr(range_end))
					call add(hosts[level_num - 1], hosts_list_temp_prefix . i . hosts_list_temp_suffix)
				endfor
			else
				for i in range(char2nr(range_start), char2nr(range_end))
					call add(hosts[level_num - 1], hosts_list_temp_prefix . nr2char(i) . hosts_list_temp_suffix)
				endfor
			endif
		else
			" Single item
			let hosts[level_num - 1] = [hosts_list]
		endif

		" Add item to final result
		if is_included
			let result_temp = ''
			let result_temp_ip = ''

			for i in range(0,level_num - 2)
				let result_temp = hosts[i][0] . '.' . result_temp
			endfor

			for item in hosts[level_num - 1]
				let result_temp_ip = ip_name_single != '' ? ips[ip_name_single] : ips[ip_name_base]
				call add(result, substitute(result_temp_ip . ' ' . item . '.' . result_temp, '\.$', '', ''))
			endfor
		endif

	endfor

	return result
	" return ['']
endfunction
"}}}

function! s:convert() "{{{
	let result = s:process(g:hosts_list)
	let result = extend(result, ['127.0.0.1 localhost', '255.255.255.255 broadcasthost', '::1 localhost ', 'fe80::1%lo0 localhost', ''], 0)

	if g:isw
		if writefile(result, 'C:\WINDOWS\system32\drivers\etc\hosts') == -1
			call xelltoolkit#echo_msg('Wrong writing file.')
		endif
		return
	endif

	split +enew!
	setlocal hid
	" put! =result
	call setline(1, result)


	" echo s:process(g:hosts_list)

endfunction
"}}}

"}}}
