
let g:test_rules = {'t3t': 'T_xx'}

function! T_xx()
	return 'aa'
endfunction

function! Test()
	let key = 't2t'
	let str = ''
	if has_key(g:test_rules, key)
		let str = {g:test_rules[key]}()
	endif
	echo str
endfunction

