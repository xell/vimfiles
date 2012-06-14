" Todo.txt syntax
" Language: todotxt
" Maintainer:	Xell Liu
" Last Change:	2012-06-14

function! GetDate(...)
	if a:0 > 0
		let day_in_sec = a:1 * 60 * 60 * 24
	else
		let day_in_sec = 0
	endif

	return strftime("%Y-%m-%d", localtime() + day_in_sec)

endfunction

syn match todoNormal /^[^x].*$/ contains=todoProject,todoContext
exec 'syn match todoDateToday /.*' . GetDate() . '\s.*$/ contains=todoProject,todoContext'
exec 'syn match todoDateTomorrow /.*' . GetDate(1) . '\s.*$/ contains=todoProject,todoContext'
for i in range(2,7)
	exec 'syn match todoDateWeek /.*' . GetDate(i) . '\s.*$/ contains=todoProject,todoContext'
endfor
syn match todoPriority /^([A-Z])\s.*$/ contains=todoProject,todoContext

syn match todoProject /^\zs+[^+ ]\+\ze\s/ contained
syn match todoProject /\s\zs+[^+ ]\+\ze\s/ contained
syn match todoProject /\s\zs+[^+ ]\+\ze$/ contained
syn match todoContext /^\zs@[^@ ]\+\ze\s/ contained
syn match todoContext /\s\zs@[^@ ]\+\ze\s/ contained
syn match todoContext /\s\zs@[^@ ]\+\ze$/ contained

syn match todoDone /^x\s.*$/

hi link todoDateToday Question
hi link todoDateTomorrow Title
hi link todoDateWeek Directory

hi link todoPriority Statement

hi link todoProject LineNr
hi link todoContext Special

hi link todoDone Comment
