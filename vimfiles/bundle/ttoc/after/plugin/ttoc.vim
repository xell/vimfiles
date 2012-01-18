let g:tlib_keyagents_InputList_s[9] = 'tlib#agent#Down'
let g:tlib_keyagents_InputList_s["\<s-tab>"] = 'tlib#agent#Up'
if exists("g:ttoc_world")
	call add(g:ttoc_world.key_handlers, {'key': "\<left>", 'agent': 'tlib#agent#PreviewLine',  'key_name': '<left>', 'help': 'Preview'})
endif

