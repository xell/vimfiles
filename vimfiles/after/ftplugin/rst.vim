if g:isw
	call IMAP('**', '*<++>*<++>', 'rst')
	call IMAP('````', '``<++>``<++>', 'rst')
elseif g:ism
	call xelltoolkit#imap('**', '*<++>*<++>', 1)
	call xelltoolkit#imap('````', '``<++>``<++>', 1)
endif
