"=============================================================================
" $Id: local_vimrc.vim 848 2014-06-20 16:49:45Z luc.hermitte@gmail.com $
" File:		plugin/local_vimrc.vim                                     {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.0.1
" Created:	09th Apr 2003
" Last Update:	12th Sep 2014
" License:      GPLv3
"------------------------------------------------------------------------
" Description:	Solution to Yakov Lerner's question on Vim ML {{{2
"	Search for a _vimrc_local.vim file in the parents directories and
"	source it if found.
"
"	Initial Question:
"	"Is it possible, after sourcing ~/.exrc, to traverse from $HOME down
"	 to cwd, and source .exrc from every directory if present ?
"	 (And if cwd is not under $HOME, just source ~/.exrc).
"	 What do I put into .vimrc to do this ?
" 
"	"Example: current dir is ~/a/b/c. Files are sourced in this order:
"	 ~/.exrc, then ~/a/.exrc, ~/a/b/.exrc, ~/a/b/c/.exrc.
"	 No messages if some of .exrc does not exist."
" }}}2
"------------------------------------------------------------------------
" Installation:	{{{2
" 	0- Set g:local_vimrc in your .vimrc if you wish to use filenames other
" 	   than '_vimrc_local.vim'
" 	a- Drop this plugin into a {rtp}/plugin/ directory, and install
" 	   lh-vim-lib v3.2.1
" 	b- Define _vimrc_local.vim files into your directories
"
" 	   Ideally, each foo/bar/_vimrc_local.vim should be defined the same
" 	   way as a ftplugin, i.e.: {{{3
"		" Global stuff that needs to be updated/override
"		let g:bar = 'bar'  " YES! This is a global variable!
"		
"		" Local stuff that needs to be defined once for each buffer
"		if exists('b:foo_bar_local_vimrc') | finish | endif
"		let b:foo_bar_local_vimrc = 1
"		setlocal xxx
"		nnoremap <buffer> foo :call <sid>s:Foo()<cr>
"		let b:foo = 'foo'
"		
"		" Global stuff that needs to be defined once only => functions
"		if exists('g:foo_bar_local_vimrc') | finish | endif
"		let g:foo_bar_local_vimrc = 1
"		function s:Foo()
"		  ...
"		endfunction
"	c- In order to load the local variable before a skeleton is read, ask
"	   the maintainer of template-file expander pluin to explicitly execute
"	   :SourceLocalVimrc before doing the actual expansion.
"
" History:	{{{2
"       v2.0.1  Updated to match changes in lh-vim-lib 3.2.2.
"       v2.0    Code refactored.
"               -> Search function deported to lh-vim-lib
"               -> dependencies to vim7 and to lh-vim-lib introduced
"               Support for directory of local_vimrc_files added
"	v1.11   Less errors are printed when the file loaded contains errors
"	v1.10   s:k_version in local_vimrc files is automatically incremented
"	        on saving
"	v1.9    New command :SourceLocalVimrc in order to explicitly load the
"	        local-vimrc file before creating new files from a template (We
"	        can't just rely on BufNewFile as there is no guaranty
"	        local_vimrc's BufNewFile will be called before the one from the
"	        Template Expander Plugin => it's up to the TEP to call the
"	        function)
"	v1.8    No more infinite recursion on file in non existent paths.
"	        + patch from cristiklein to support paths with spaces
"	v1.7    Don't search a local vimrc with remote paths (ftp://, http, ... )
"	v1.6    Sometimes root path is Z:\\, which is quite odd
"	v1.5    The auto-command is moved to the au-group LocalVimrc
"	v1.4	Stop the recursion when we get to // or \\ (UNC paths)
"	v1.3    More comments.
"	        Trace of the directories searched when 'verbose' >= 2
"	v1.2	Stops at $HOME or at root (/)
" 	v1.1	Uses _vimrc_local.vim
" 	v1.0	Initial solution
" TODO:		{{{2
" 	(*) Add option to stop looking at $HOME or elsewhere
" 	    ([bg]:lv_stop_at : string, default $HOME) 
" See also: alternative scripts: #441, #3393, #1860, ...
" }}}1
"=============================================================================

"=============================================================================
" Avoid global reinclusion {{{1
let s:k_version = 201
if exists("g:loaded_local_vimrc") 
      \ && (g:loaded_local_vimrc >= s:k_version)
      \ && !exists('g:force_reload_local_vimrc')
  finish 
endif
if lh#path#version() < 3202
  call lh#common#error_msg('local_vimrc requires a version of lh-vim-lib >= 3.2.2. Please upgrade it.')
  finish
endif
let g:loaded_local_vimrc = s:k_version
let s:cpo_save=&cpo
set cpo&vim
" Avoid global reinclusion }}}1
"------------------------------------------------------------------------
" Commands {{{1
command! -nargs=0 SourceLocalVimrc call s:Main(expand('%:p'))

" Functions {{{1
" Name of the files used                                              {{{2
function! s:LocalVimrcName()
  let res = exists('g:local_vimrc') ? g:local_vimrc : ['_vimrc_local.vim']
  if type(res) == type('')
    return [res]
  endif
  return res
endfunction

let s:local_vimrc = s:LocalVimrcName()

" Value of $HOME -- actually a regex.                                 {{{2
let s:home = substitute($HOME, '[/\\]', '[/\\\\]', 'g')

" Regex used to determine when we must stop looking for local-vimrc's {{{2
let s:re_last_path = !empty(s:home) ? ('^'.s:home.'$') : ''

" The main function                                                   {{{2
function! s:IsAForbiddenPath(path)
  let forbidden = a:path =~ '^\(s\=ftp:\|s\=http:\|scp:\|^$\)'
  return forbidden
endfunction

function! s:Main(path) abort
  " echomsg 'Sourcing: '.a:path
  if s:IsAForbiddenPath(a:path) 
    return
  else
    let config_found = lh#path#find_in_parents(a:path, s:local_vimrc, 'file,dir', s:re_last_path)
    let configs = []
    for config in config_found
      if filereadable(config)
        let configs += [config] 
      elseif is_directory(config)
        let gpat = len(s:local_vimrc) > 1
              \ ? ('{'.join(s:local_vimrc, ',').'}')
              \ : (s:local_vimrc)
        let configs += glob(gpat, 0, 1)
      endif
    endfor

    for config in configs
      exe 'source '.escape(config, ' \$,')
      if &verbose >= 2
        echomsg "Sourcing " . config
      endif
    endfor
  endif
endfunction

" Update s:k_version in local_vimrc files                             {{{2
function! s:IncrementVersionOnSave()
  let l = search('let s:k_version', 'n')
  if l > 0
    let nl = substitute(getline(l),
          \ '\(let\s\+s:k_version\s*=\s*\)\(\d\+\)\s*$',
          \ '\=submatch(1).(1+submatch(2))',
          \ '')
    call setline(l, nl)
  endif
endfunction

" Auto-command                                                        {{{2
aug LocalVimrc
  au!
  " => automate the loading of local-vimrc's every time we change buffers 
  " Note: BufEnter seems to be triggerred twice on a "vim foo.bar"
  au BufEnter * :call s:Main(expand('<afile>:p:h'))
  " => Update script version every time it is saved.
  for s:_pat in s:local_vimrc
    exe 'au BufWritePre '.s:_pat. ' call s:IncrementVersionOnSave()'
  endfor
aug END

" Functions }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
