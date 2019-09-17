syn match   pdcStrong       '\*\*[^* ].\{-}\*\*' contains=@Spell,pdcStrongFix
syn match   pdcStrongFix    '\*' contained conceal
hi default link pdcStrong Special

