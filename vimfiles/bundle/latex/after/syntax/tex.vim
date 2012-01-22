syn match  texRefZone		'\\ucite\%([tp]\*\=\)\=' nextgroup=texRefOption,texCite
syn match  texRefZone		'\\url\%([tp]\*\=\)\=' nextgroup=texRefOption,texCite
syn region texTemp matchgroup=texStatement start="\\temp{" end="}" containedin=ALL concealends
syn region texChapterZone matchgroup=texSection start='\\chapterp\?\>' end='\ze\s*\\\%(chapterp\?\>\|part\>\|end\s*{\s*document\s*}\)' fold contains=@texFoldGroup,@texChapterGroup,@Spell

hi link texTemp Temp

