syn include syntax/css/vim-coloresque.vim

" c.f. http://vim.1045645.n5.nabble.com/syntax-folding-of-html-td1171740.html
syn region SynFold 
	  \ start="<\%(param\|link\|isindex\|input\|hr\|frame\|col\|br\|basefont\|base\|area\|img\|meta\|tr\|td\|p\|dt\|dd\|li\|span\|a\)\@!\z([a-z]\+\)\%(\s[^>]*[^>/]\)*>"
      \ end="</\z1>" 
      \ transparent fold keepend extend
      \ containedin=ALLBUT,htmlComment 

"\ start="<\%(param\)\@!\%(link\)\@!\%(isindex\)\@!\%(input\)\@!\%(hr\)\@!\%(frame\)\@!\%(col\)\@!\%(br\)\@!\%(basefont\)\@!\%(base\)\@!\%(area\)\@!\%(img\)\@!\%(meta\)\@!\z([a-z]\+\)\%(\_s[^>]*/\@![^>]\)*>" 
