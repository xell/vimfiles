" Vim syntax file
" Language:	generic git output
" Maintainer:	Tim Pope <vimNOSPAM@tpope.org>
" Last Change:	2010 May 21

if exists("b:current_syntax")
  finish
endif

syn case match
syn sync minlines=50

syn include @gitDiff syntax/diff.vim

syn region gitHead start=/\%^/ end=/^$/
syn region gitHead start=/\%(^commit \x\{40\}\%(\s*(.*)\)\=$\)\@=/ end=/^$/

" For git reflog and git show ...^{tree}, avoid sync issues
syn match gitHead /^\d\{6\} \%(\w\{4} \)\=\x\{40\}\%( [0-3]\)\=\t.*/
syn match gitHead /^\x\{40\} \x\{40}\t.*/

syn region gitDiff start=/^\%(diff --git \)\@=/ end=/^\%(diff --\|$\)\@=/ contains=@gitDiff fold
syn region gitDiff start=/^\%(@@ -\)\@=/ end=/^\%(diff --\%(git\|cc\|combined\) \|$\)\@=/ contains=@gitDiff

syn region gitDiffMerge start=/^\%(diff --\%(cc\|combined\) \)\@=/ end=/^\%(diff --\|$\)\@=/ contains=@gitDiff
syn region gitDiffMerge start=/^\%(@@@@* -\)\@=/ end=/^\%(diff --\|$\)\@=/ contains=@gitDiff
syn match gitDiffAdded "^ \++.*" contained containedin=gitDiffMerge
syn match gitDiffRemoved "^ \+-.*" contained containedin=gitDiffMerge

syn match  gitKeyword /\%(object\|type\|tag\|commit\|tree\|parent\|encoding\)\>/ contained containedin=gitHead nextgroup=gitHash,gitType skipwhite
syn match  gitKeyword /\%(tag\>\|ref:\)/ contained containedin=gitHead nextgroup=gitReference skipwhite
syn match  gitKeyword /Merge:/  contained containedin=gitHead nextgroup=gitHashAbbrev skipwhite
syn match  gitMode    /\d\{6\}/ contained containedin=gitHead nextgroup=gitType,gitHash skipwhite
syn match  gitIdentityKeyword /\%(author\|committer\|tagger\)\>/ contained containedin=gitHead nextgroup=gitIdentity skipwhite
syn match  gitIdentityHeader /\%(Author\|Commit\|Tagger\):/ contained containedin=gitHead nextgroup=gitIdentity skipwhite
syn match  gitDateHeader /\%(AuthorDate\|CommitDate\|Date\):/ contained containedin=gitHead nextgroup=gitDate skipwhite

syn match  gitReflogHeader /^Reflog:/ contained containedin=gitHead nextgroup=gitReflogMiddle skipwhite
syn match  gitReflogHeader /^Reflog message:/ contained containedin=gitHead skipwhite
syn match  gitReflogMiddle /\S\+@{\d\+} (/he=e-2 nextgroup=gitIdentity

syn match  gitDate      /\<\u\l\l \u\l\l \d\=\d \d\d:\d\d:\d\d \d\d\d\d [+-]\d\d\d\d/ contained
syn match  gitDate      /-\=\d\+ [+-]\d\d\d\d\>/               contained
syn match  gitDate      /\<\d\+ \l\+ ago\>/                    contained
syn match  gitType      /\<\%(tag\|commit\|tree\|blob\)\>/     contained nextgroup=gitHash skipwhite
syn match  gitStage     /\<\d\t\@=/                            contained
syn match  gitReference /\S\+\S\@!/                            contained
syn match  gitHash      /\<\x\{40\}\>/                         contained nextgroup=gitIdentity,gitStage,gitHash skipwhite
syn match  gitHash      /\<\x\{40\}\>/ containedin=gitHead contained nextgroup=gitHash skipwhite
syn match  gitHashAbbrev /\<\x\{4,40\}\>/           contained nextgroup=gitHashAbbrev skipwhite
syn match  gitHashAbbrev /\<\x\{4,39\}\.\.\./he=e-3 contained nextgroup=gitHashAbbrev skipwhite

syn match  gitIdentity /\S.\{-\} <[^>]*>/ contained nextgroup=gitDate skipwhite
syn region gitEmail matchgroup=gitEmailDelimiter start=/</ end=/>/ keepend oneline contained containedin=gitIdentity

syn match  gitNotesHeader /Notes:\ze\n    /

" xell start
syn match gitGraphNode /\zs\*\ze\s/ containedin=ALL
syn match gitGraphLine /|\s\|\\\s\|\/\||\\\||\/\||_/ containedin=ALL
syn match gitHash /\<[0-9a-f]\{40}\>/ containedin=ALL
syn match gitHashAbbrev /\<[0-9a-f]\{6,40}\>/ containedin=ALL
syn match gitDateShort /2\d\{3}-\d\{2}-\d\{2}/ containedin=ALL
syn match gitDate      /2\d\{3}-\d\{2}-\d\{2}\s\d\{2}:\d\{2}:\d\{2}\s[+-]\d\{4}/ containedin=ALL
syn match gitDate      /\<\u\l\l \u\l\l \d\=\d \d\d:\d\d:\d\d \d\d\d\d [+-]\d\d\d\d/ containedin=ALL
syn match gitDate      /-\=\d\+ [+-]\d\d\d\d\>/               containedin=ALL
syn match gitDate      /\<\d\+ \l\+ ago\>/                    containedin=ALL
syn match gitRefName   /-\s\s\zs([^)]\+)\ze/ containedin=ALL
syn match gitCommitter /<\zs.\{-}\ze>/ containedin=ALL

syn case match
syn keyword gitHEADTag HEAD containedin=ALL
syn case ignore

hi link gitDateShort Number
hi link gitGraphNode Type
hi link gitGraphLine Special
hi link gitRefName Include
hi link gitCommitter Underlined
hi link gitHEADTag ErrorMsg
" xell end

hi def link gitDateHeader        gitIdentityHeader
hi def link gitIdentityHeader    gitIdentityKeyword
hi def link gitIdentityKeyword   Label
hi def link gitNotesHeader       gitKeyword
hi def link gitReflogHeader      gitKeyword
hi def link gitKeyword           Keyword
hi def link gitIdentity          Identifier
hi def link gitEmailDelimiter    Delimiter
hi def link gitEmail             Underlined
hi def link gitDate              Number
hi def link gitMode              Number
hi def link gitHashAbbrev        gitHash
hi def link gitHash              Special
hi def link gitReflogMiddle      gitReference
hi def link gitReference         Function
hi def link gitStage             gitType
hi def link gitType              Type
hi def link gitDiffAdded         diffAdded
hi def link gitDiffRemoved       diffRemoved

let b:current_syntax = "git"
