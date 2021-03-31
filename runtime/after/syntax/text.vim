syn match   pdcStrong       '\*\*[^* ].\{-}\*\*' contains=pdcStrongFix
syn match   pdcStrongFix    '\*' contained conceal
hi default link pdcStrong Special
