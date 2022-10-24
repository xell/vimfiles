syn match pdcAtxHeader  /^#\{1,6}\s.\+$/ contains=@Spell
syn match pdcStrong     '\*\*[^* ].\{-}\*\*' contains=pdcStrongFix
syn match pdcStrongFix  '\*' contained conceal
syn match pdcBlockQuote '^\s*>.*$'
syn match textIgnore    '^\s*\/\/.*$'

hi default link pdcAtxHeader Title
hi default link pdcStrong Special
hi default link pdcBlockQuote PreProc
hi default link textIgnore Ignore
