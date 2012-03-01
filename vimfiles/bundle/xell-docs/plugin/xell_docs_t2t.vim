
" txt2tags.py --style=xxx.css --config-file=xxx.t2t --outfile=xxx.html xxx.t2t
" t2tcf_html.t2t
" t2tcf_n_html.t2t
" t2tcf_rtf.t2t
" t2tcf_tex.t2t
" t2tcf_txt.t2t
" css/modern.css
" css/normal.css
" css/note.css
" Txt2tags converter {{{1
function! T2TConverter(input, out_type, config, out_path)
	
	" Output targets {{{2
	if !has_key(g:t2t_target_ext, a:out_type)
		call xelltoolkit#echo_msg('Unsupported target name!')
		return
	endif
	" }}}

	" Input and output file {{{2
	if a:input == ''
		let input = expand('%:p')
	else
		let input = a:input
	endif
	if a:out_path == ''
		let output_file_raw = xelltoolkit#fname_ext_mod(input, g:t2t_target_ext[a:out_type])
	else
		let output_file_raw = a:out_path . g:slash . xelltoolkit#fname_name(input) . '.' . g:t2t_target_ext[a:out_type]
	endif
	let output_file = xelltoolkit#fname_escape(output_file_raw)
	let input_file = xelltoolkit#fname_escape(input)
	" }}}

	" Config {{{2
	" Default
	if a:config == 'normal' && a:out_type == 'html'
		let style_file = xelltoolkit#fname_escape(g:t2t_cf_path . g:slash . 'css' . g:slash . 'normal.css')
		let config_file = xelltoolkit#fname_escape(g:t2t_cf_path . g:slash . 't2tcf_html.t2t')
		let config = ' --style=' . style_file . ' --config-file=' . config_file
	elseif a:config == 'note' && a:out_type == 'html'
		let style_file = xelltoolkit#fname_escape(g:t2t_cf_path . g:slash . 'css' . g:slash . 'note.css')
		let config_file = xelltoolkit#fname_escape(g:t2t_cf_path . g:slash . 't2tcf_n_html.t2t')
		let config = ' --style=' . style_file . ' --config-file=' . config_file

	" XXX hack : use a:out_type for config, don't care about a:config
	else
		let config_file = xelltoolkit#fname_escape(g:t2t_cf_path . g:slash . 't2tcf_' . a:out_type . '.t2t')
		if filereadable(config_file)
			let config = ' --config-file=' . config_file
		else
			let config = ''
		endif
	endif
	" }}}

	" Full exec
	let cmd = g:t2t_cmd . config . ' --target=' . a:out_type . ' --outfile=' . output_file . ' --infile=' . input_file
	call xelltoolkit#system(cmd)
	return output_file_raw
endfunction
" }}}
